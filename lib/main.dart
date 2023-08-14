import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tesdatabase/data/message_dao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:tesdatabase/model/message.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainStateHome(),
    );
  }
}

class MainStateHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainStateHome> {
  var result;
  final messageDao = MessageDao();
  ScrollController _scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  void _sendMessage() {
    if (messageController.text.isNotEmpty) {
      try {
        final message =
            Message(text: messageController.text, date: DateTime.now());
        messageDao.saveMessage(message);
        messageController.clear();
        setState(() {});
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Succes send message')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Eror: ${e.toString()}')));
      }
    }
  }

  @override
  void initState() {
    result = messageDao.dataCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    messageDao.dataCount;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: 'Send Messages',
                        border: OutlineInputBorder()),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    _sendMessage();
                  },
                  icon: Icon(Icons.send))
            ],
          ),
          Visibility(
            visible: result != 0 ? true : false,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: FirebaseAnimatedList(
                  query: messageDao.getMessageQuery(),
                  controller: _scrollController,
                  itemBuilder: (context, snapshot, animation, index) {
                    final json = snapshot.value as Map<dynamic, dynamic>;
                    return ListTile(
                      title: Text(json['text']),
                      subtitle: Text(json['date']),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
