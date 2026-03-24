import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../theme/app_colors.dart';

class AddMoneyBottomSheet extends StatefulWidget {
  const AddMoneyBottomSheet({super.key});

  @override
  State<AddMoneyBottomSheet> createState() => _AddMoneyBottomSheetState();
}

class _AddMoneyBottomSheetState extends State<AddMoneyBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedAmount = '';
  bool _isLoading = false;

  final List<String> _presets = ['500', '1000', '2000', '5000'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wallet = Provider.of<WalletProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Money',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              )
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixText: '₹ ',
              hintText: 'Enter Amount',
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              fillColor: isDark ? AppColors.backgroundDark : AppColors.background,
            ),
            onChanged: (val) {
              setState(() => _selectedAmount = '');
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _presets.map((amount) {
              final isSelected = _selectedAmount == amount;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedAmount = amount;
                    _amountController.text = amount;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primary 
                        : (isDark ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.surface),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '₹$amount',
                    style: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.primary),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          const Text(
            'Payment Methods',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildPaymentOption(Icons.account_balance_wallet_outlined, 'UPI (PhonePe, GPay, Paytm)'),
          const SizedBox(height: 12),
          _buildPaymentOption(Icons.credit_card_outlined, 'Debit / Credit Card'),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : () async {
              final amount = double.tryParse(_amountController.text);
              if (amount != null && amount > 0) {
                final navigator = Navigator.of(context);
                setState(() => _isLoading = true);
                
                // Simulate payment processing
                await Future.delayed(const Duration(seconds: 2));
                
                await wallet.addMoney(amount);
                
                if (mounted) {
                  navigator.pop(true); // Return true on success
                }
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Add Money Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.radio_button_off, color: Colors.grey, size: 20),
        ],
      ),
    );
  }
}
