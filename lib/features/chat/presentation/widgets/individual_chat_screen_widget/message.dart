enum TickStatus {
  none,
  single,
  double,
  blue,
}




class Message {
  final String text;
  final bool isSent;
  final String time;
  final TickStatus tickStatus;

  Message({
    required this.text,
    required this.isSent,
    required this.time,
    required this.tickStatus,
  });

  Message copyWith({
    String? text,
    bool? isSent,
    String? time,
    TickStatus? tickStatus,
  }) {
    return Message(
      text: text ?? this.text,
      isSent: isSent ?? this.isSent,
      time: time ?? this.time,
      tickStatus: tickStatus ?? this.tickStatus,
    );
  }
}