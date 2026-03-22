import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/wallet_provider.dart';
import '../../theme/app_colors.dart';
import '../hardline/hardline_widgets.dart';

/// Bottom sheet with 3 payment methods: UPI, Bank Transfer, Card.
class PaymentMethodSheet extends StatefulWidget {
  const PaymentMethodSheet({super.key});

  @override
  State<PaymentMethodSheet> createState() => _PaymentMethodSheetState();
}

class _PaymentMethodSheetState extends State<PaymentMethodSheet> {
  int _selectedMethod = -1; // 0=UPI, 1=Bank, 2=Card
  int _selectedPreset = -1;
  final _presets = [500, 1000, 2000, 5000];
  final _amountController = TextEditingController();

  // UPI
  final _upiController = TextEditingController();

  // Bank
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  final _holderController = TextEditingController();

  // Card
  final _cardController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _saveForFuture = false;

  @override
  void dispose() {
    _amountController.dispose();
    _upiController.dispose();
    _accountController.dispose();
    _ifscController.dispose();
    _holderController.dispose();
    _cardController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _selectPreset(int index) {
    setState(() {
      _selectedPreset = index;
      _amountController.text = '${_presets[index]}';
    });
  }

  void _proceed() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum amount is ₹100')),
      );
      return;
    }

    context
        .read<WalletProvider>()
        .addMoney(amount, description: 'Wallet Top-up');
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('₹${amount.toStringAsFixed(0)} added to wallet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 24, 16, bottomInset + 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Add Money',
              style: GoogleFonts.merriweather(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // ── Payment Methods ──
            Text(
              'PAYMENT METHOD',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _MethodChip(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'UPI',
                  selected: _selectedMethod == 0,
                  onTap: () => setState(() => _selectedMethod = 0),
                ),
                const SizedBox(width: 8),
                _MethodChip(
                  icon: Icons.account_balance_outlined,
                  label: 'Bank',
                  selected: _selectedMethod == 1,
                  onTap: () => setState(() => _selectedMethod = 1),
                ),
                const SizedBox(width: 8),
                _MethodChip(
                  icon: Icons.credit_card_outlined,
                  label: 'Card',
                  selected: _selectedMethod == 2,
                  onTap: () => setState(() => _selectedMethod = 2),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Method-specific fields ──
            if (_selectedMethod == 0) ..._buildUpiFields(),
            if (_selectedMethod == 1) ..._buildBankFields(),
            if (_selectedMethod == 2) ..._buildCardFields(),

            if (_selectedMethod >= 0) ...[
              const SizedBox(height: 12),
              // Save toggle
              Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        setState(() => _saveForFuture = !_saveForFuture),
                    child: Container(
                      width: 36,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _saveForFuture
                              ? AppColors.accent
                              : AppColors.border,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: AnimatedAlign(
                        alignment: _saveForFuture
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.all(1),
                          color: _saveForFuture
                              ? AppColors.accent
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Save for future',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // ── Amount presets ──
            Text(
              'AMOUNT',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(_presets.length, (i) {
                final selected = _selectedPreset == i;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                    child: HardlinePressable(
                      onTap: () => _selectPreset(i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '₹${_presets[i]}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color:
                                selected ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Custom amount
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.robotoMono(fontSize: 18),
              decoration: const InputDecoration(
                hintText: 'Enter custom amount',
                prefixText: '₹ ',
              ),
              onChanged: (_) => setState(() => _selectedPreset = -1),
            ),
            const SizedBox(height: 24),

            // CTA
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _proceed,
                child: Text(
                  'Proceed to Payment',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUpiFields() {
    return [
      TextField(
        controller: _upiController,
        style: GoogleFonts.robotoMono(fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'yourname@okhdfcbank',
          labelText: 'UPI ID',
        ),
      ),
    ];
  }

  List<Widget> _buildBankFields() {
    return [
      TextField(
        controller: _accountController,
        keyboardType: TextInputType.number,
        style: GoogleFonts.robotoMono(fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'Account Number',
          labelText: 'Account Number',
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _ifscController,
        textCapitalization: TextCapitalization.characters,
        style: GoogleFonts.robotoMono(fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'IFSC Code',
          labelText: 'IFSC Code',
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _holderController,
        style: GoogleFonts.inter(fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'Account Holder Name',
          labelText: 'Account Holder',
        ),
      ),
    ];
  }

  List<Widget> _buildCardFields() {
    return [
      TextField(
        controller: _cardController,
        keyboardType: TextInputType.number,
        style: GoogleFonts.robotoMono(fontSize: 16),
        decoration: const InputDecoration(
          hintText: '#### #### #### ####',
          labelText: 'Card Number',
        ),
      ),
      const SizedBox(height: 16),
      TextField(
        controller: _cardNameController,
        style: GoogleFonts.inter(fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'Cardholder Name',
          labelText: 'Name on Card',
        ),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _expiryController,
              style: GoogleFonts.robotoMono(fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'MM/YY',
                labelText: 'Expiry',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _cvvController,
              obscureText: true,
              keyboardType: TextInputType.number,
              style: GoogleFonts.robotoMono(fontSize: 16),
              decoration: const InputDecoration(
                hintText: '•••',
                labelText: 'CVV',
              ),
            ),
          ),
        ],
      ),
    ];
  }
}

class _MethodChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MethodChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: HardlinePressable(
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 28,
                  color: selected ? Colors.white : AppColors.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
