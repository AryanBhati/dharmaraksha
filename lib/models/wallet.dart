import 'transaction.dart';

class Wallet {
  final String userId;
  final double balance;
  final List<Transaction> transactions;

  const Wallet({
    required this.userId,
    required this.balance,
    required this.transactions,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'balance': balance,
      'transactions':
          transactions.map((transaction) => transaction.toJson()).toList(),
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((dynamic item) =>
              Transaction.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}
