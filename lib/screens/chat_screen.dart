import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:halawa_naim_chat/components/messages_stream.dart';
import 'package:halawa_naim_chat/screens/welcome_screen.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String messageText;
  final messageTextController = TextEditingController();
  final fireStore = FirebaseFirestore.instance;
  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  // void getToken() {
  //   fbm.getToken().then((token) {
  //     print(token);
  //     fireStore.collection('users').doc(loggedInUser.uid).update({
  //       'token': token,
  //     });
  //   });
  // }
// void registerNotification() {
//   firebaseMessaging.requestNotificationPermissions();

//   firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
//     print('onMessage: $message');
//     Platform.isAndroid
//         ? showNotification(message['notification'])
//         : showNotification(message['aps']['alert']);
//     return;
//   }, onResume: (Map<String, dynamic> message) {
//     print('onResume: $message');
//     return;
//   }, onLaunch: (Map<String, dynamic> message) {
//     print('onLaunch: $message');
//     return;
//   });

//   firebaseMessaging.getToken().then((token) {
//     print('token: $token');
//     Firestore.instance
//         .collection('users')
//         .document(currentUserId)
//         .updateData({'pushToken': token});
//   }).catchError((err) {
//     Fluttertoast.showToast(msg: err.message.toString());
//   });
// }
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: const Text('🤫 ️Chat'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(fireStore: fireStore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      fireStore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                        'time': DateTime.now()
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
