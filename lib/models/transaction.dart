

enum TransactionType { credit, debit, refund }

class Transaction {
  final String id;
  final String userId; // Legacy
  final double amount;
  final String title;
  final String description;
  final DateTime dateTime;
  final TransactionType type;
  final String category;
  final String? note;
  final String? receiptPath;
  final String? location;
  final String? consultationId; // Legacy

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.type,
    required this.category,
    this.note,
    this.receiptPath,
    this.location,
    this.consultationId,
  });

  // Helper for legacy code using 'createdAt' or 'timestamp'
  DateTime get createdAt => dateTime;
  DateTime get timestamp => dateTime;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'amount': amount,
        'title': title,
        'description': description,
        'dateTime': dateTime.toIso8601String(),
        'type': type.index,
        'category': category,
        'note': note,
        'receiptPath': receiptPath,
        'location': location,
        'consultationId': consultationId,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        userId: json['userId'] ?? 'u01',
        amount: (json['amount'] as num).toDouble(),
        title: json['title'] ?? (json['type'] == 0 ? 'Money Added' : 'Payment'),
        description: json['description'],
        dateTime: DateTime.parse(json['dateTime'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()),
        type: TransactionType.values[json['type']],
        category: json['category'] ?? 'General',
        note: json['note'],
        receiptPath: json['receiptPath'],
        location: json['location'],
        consultationId: json['consultationId'],
      );

  Transaction copyWith({
    String? id,
    String? userId,
    double? amount,
    String? title,
    String? description,
    DateTime? dateTime,
    TransactionType? type,
    String? category,
    String? note,
    String? receiptPath,
    String? location,
    String? consultationId,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      type: type ?? this.type,
      category: category ?? this.category,
      note: note ?? this.note,
      receiptPath: receiptPath ?? this.receiptPath,
      location: location ?? this.location,
      consultationId: consultationId ?? this.consultationId,
    );
  }
}
