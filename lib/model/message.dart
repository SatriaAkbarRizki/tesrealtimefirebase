class Message {
  String text;
  DateTime? date;

  Message({required this.text, required this.date});

  Message.fromJson(Map<dynamic, String> json)
      : date = DateTime.parse(json['date'] as String),
        text = json['text'] as String;
        
  Map<dynamic, dynamic> toJson() =>
      <dynamic, dynamic>{'date': date.toString(), 'text': text};
}
