import 'package:firebase_database/firebase_database.dart';
import 'package:tesdatabase/model/message.dart';

class MessageDao {
  final DatabaseReference _messageRef =
      FirebaseDatabase.instance.ref().child('message');

  void saveMessage(Message message) {
    _messageRef.push().set(message.toJson());
  }

  Query getMessageQuery() {
    return _messageRef;
  }

  Future<int?> dataCount() async {
    var result;
    await _messageRef.onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      final datacount = dataSnapshot.children.length;
      result = datacount;
      print('length: ${datacount}');
    });

    return result;
  }
}
