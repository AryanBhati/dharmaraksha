import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wallet_provider.dart';
import '../theme/app_colors.dart';
import '../utils/app_formatters.dart';
import '../widgets/aurora_background.dart';
import '../widgets/primary_button.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/wallet_header_action.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final List<int> _presets = <int>[100, 200, 500, 1000];
  int _selectedPreset = 0;
  final TextEditingController _customController = TextEditingController();
  bool _isCustom = false;

  double get _finalAmount {
    if (_isCustom) {
      return double.tryParse(_customController.text.trim()) ?? 0;
    }
    return _presets[_selectedPreset].toDouble();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = context.read<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Money'),
        actions: const <Widget>[
          WalletHeaderAction(enabled: false),
          ProfileAvatar(),
        ],
      ),
      body: AuroraBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Select Amount',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _presets.length,
                itemBuilder: (_, i) {
                  final selected = !_isCustom && _selectedPreset == i;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedPreset = i;
                      _isCustom = false;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              selected ? AppColors.primary : AppColors.border,
                          width: selected ? 2 : 1,
                        ),
                        boxShadow: selected
                            ? <BoxShadow>[
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : const <BoxShadow>[],
                      ),
                      child: Center(
                        child: Text(
                          '\u20B9${_presets[i]}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                selected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text('Or Enter Custom Amount',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              TextField(
                controller: _customController,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() => _isCustom = true),
                decoration: const InputDecoration(
                  prefixText: '\u20B9 ',
                  hintText: 'Enter amount',
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Current Balance',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                          AppFormatters.inr(wallet.balance),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Adding',
                            style: Theme.of(context).textTheme.bodyMedium),
                        Text(
                          AppFormatters.inr(_finalAmount),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Add ${AppFormatters.inr(_finalAmount)} to Wallet',
                icon: Icons.account_balance_wallet_rounded,
                onPressed: _finalAmount > 0
                    ? () {
                        wallet.addMoney(_finalAmount);
                        showDialog<void>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.success
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_circle,
                                      color: AppColors.success, size: 48),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Money Added',
                                  style: Theme.of(ctx)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${AppFormatters.inr(_finalAmount)} has been added to your wallet.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(ctx).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 18),
                                PrimaryButton(
                                  label: 'Done',
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
