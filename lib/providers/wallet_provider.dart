import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class WalletProvider extends ChangeNotifier {
  static const String _balanceKey = 'wallet_balance';
  static const String _transactionsKey = 'wallet_transactions';

  double _balance = 0.0;
  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];
  
  final _balanceStreamController = StreamController<double>.broadcast();
  Timer? _searchDebounce;

  WalletProvider() {
    _init();
  }

  // Getters
  double get balance => _balance;
  Stream<double> get balanceStream => _balanceStreamController.stream;
  List<Transaction> get transactions => _filteredTransactions.isEmpty 
      ? _allTransactions 
      : _filteredTransactions;

  // Initialize
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _balance = prefs.getDouble(_balanceKey) ?? 5000.0;
    
    final txJson = prefs.getStringList(_transactionsKey);
    if (txJson != null) {
      _allTransactions = txJson
          .map((item) => Transaction.fromJson(jsonDecode(item)))
          .toList();
      _allTransactions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    } else {
      _seedMockData();
    }
    
    _filteredTransactions = List.from(_allTransactions);
    _balanceStreamController.add(_balance);
    notifyListeners();
  }

  Future<void> refreshTransactions() async {
    // Simulate a network refresh
    await Future<void>.delayed(const Duration(seconds: 1));
    await _init();
  }

  void _seedMockData() {
    _allTransactions = [
      Transaction(
        id: '1',
        userId: 'u01',
        amount: 500,
        title: 'Consultation - Pandit Ji',
        description: 'Vedic Astrology Reading',
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.debit,
        category: 'Consultation',
      ),
      Transaction(
        id: '2',
        userId: 'u01',
        amount: 2000,
        title: 'Wallet Top-up',
        description: 'Added via UPI',
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.credit,
        category: 'Top-up',
      ),
    ];
    _saveToPrefs();
  }

  // Actions
  Future<void> addMoney(double amount, {String? category, String? description}) async {
    _balance += amount;
    final tx = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'u01',
      amount: amount,
      title: 'Money Added',
      description: description ?? 'Wallet top-up',
      dateTime: DateTime.now(),
      type: TransactionType.credit,
      category: category ?? 'Top-up',
    );
    
    _allTransactions.insert(0, tx);
    _filteredTransactions = List.from(_allTransactions);
    
    await _saveToPrefs();
    _balanceStreamController.add(_balance);
    notifyListeners();
  }

  Future<void> spendMoney(double amount, String title, {String? category, String? description}) async {
    if (_balance < amount) throw Exception('Insufficient balance');
    
    _balance -= amount;
    final tx = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'u01',
      amount: amount,
      title: title,
      description: description ?? '',
      dateTime: DateTime.now(),
      type: TransactionType.debit,
      category: category ?? 'Other',
    );
    
    _allTransactions.insert(0, tx);
    _filteredTransactions = List.from(_allTransactions);
    
    await _saveToPrefs();
    _balanceStreamController.add(_balance);
    notifyListeners();
  }

  Future<void> refundTransaction(String transactionId) async {
    final index = _allTransactions.indexWhere((tx) => tx.id == transactionId);
    if (index != -1 && _allTransactions[index].type == TransactionType.debit) {
      final originalTx = _allTransactions[index];
      _balance += originalTx.amount;
      
      final refundTx = originalTx.copyWith(
        id: '${originalTx.id}_refund',
        title: 'Refund: ${originalTx.title}',
        type: TransactionType.refund,
        dateTime: DateTime.now(),
      );
      
      _allTransactions.insert(0, refundTx);
      _filteredTransactions = List.from(_allTransactions);
      
      await _saveToPrefs();
      _balanceStreamController.add(_balance);
      notifyListeners();
    }
  }

  // Legacy Compatibility Actions
  bool canAfford(double amount) => _balance >= amount;

  bool deductBalance(double amount, {String? description, String? category, String? title}) {
    if (!canAfford(amount)) return false;
    
    _balance -= amount;
    final tx = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'u01',
      amount: amount,
      title: title ?? 'Payment',
      description: description ?? 'Consultation fee',
      dateTime: DateTime.now(),
      type: TransactionType.debit,
      category: category ?? 'Consultation',
    );
    
    _allTransactions.insert(0, tx);
    _filteredTransactions = List.from(_allTransactions);
    
    _saveToPrefs();
    _balanceStreamController.add(_balance);
    notifyListeners();
    return true;
  }

  // Search and Filter
  void searchTransactions(String query) {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        _filteredTransactions = List.from(_allTransactions);
      } else {
        _filteredTransactions = _allTransactions
            .where((tx) => 
                tx.title.toLowerCase().contains(query.toLowerCase()) ||
                tx.description.toLowerCase().contains(query.toLowerCase()) ||
                tx.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      notifyListeners();
    });
  }

  void filterByType(TransactionType? type) {
    if (type == null) {
      _filteredTransactions = List.from(_allTransactions);
    } else {
      _filteredTransactions = _allTransactions.where((tx) => tx.type == type).toList();
    }
    notifyListeners();
  }

  // Analytics
  double getMonthlySpending() {
    final now = DateTime.now();
    return _allTransactions
        .where((tx) => 
            tx.type == TransactionType.debit && 
            tx.dateTime.month == now.month && 
            tx.dateTime.year == now.year)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  Map<String, double> getCategoryBreakdown() {
    final breakdown = <String, double>{};
    for (var tx in _allTransactions.where((t) => t.type == TransactionType.debit)) {
      breakdown[tx.category] = (breakdown[tx.category] ?? 0) + tx.amount;
    }
    return breakdown;
  }

  // Persistence
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_balanceKey, _balance);
    
    final txJson = _allTransactions
        .map((tx) => jsonEncode(tx.toJson()))
        .toList();
    await prefs.setStringList(_transactionsKey, txJson);
  }

  @override
  void dispose() {
    _balanceStreamController.close();
    _searchDebounce?.cancel();
    super.dispose();
  }
}
