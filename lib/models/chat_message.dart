class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String type; // text, image, document
  final DateTime timestamp;
  final bool isRead;
  final String? documentUrl;
  final String? documentName;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.documentUrl,
    this.documentName,
  });

  ChatMessage copyWith({bool? isRead}) {
    return ChatMessage(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: type,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      documentUrl: documentUrl,
      documentName: documentName,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'receiverId': receiverId,
        'content': content,
        'type': type,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
        'documentUrl': documentUrl,
        'documentName': documentName,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      content: json['content'] as String,
      type: json['type'] as String? ?? 'text',
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      documentUrl: json['documentUrl'] as String?,
      documentName: json['documentName'] as String?,
    );
  }
}
