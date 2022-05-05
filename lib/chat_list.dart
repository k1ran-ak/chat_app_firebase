import 'package:chat_app/chat_bubble.dart';
import 'package:chat_app/chat_model.dart';
import 'package:chat_app/data_access_object.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/intl.dart';

class ChatListHome extends StatefulWidget {
  MessageDao messageDao;
  String receiver;
  User user;
  String users;

  ChatListHome(
      {required this.messageDao,
      required this.receiver,
      required this.user,
      required this.users});

  @override
  State<StatefulWidget> createState() {
    return ChatListState();
  }
}

class ChatListState extends State<ChatListHome> {
  final ScrollController _scrollController = ScrollController();
  bool _canSendMessage() => _messageController.text.isNotEmpty;
  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  late Message _chat;
  void _sendMessage() {
    if (_canSendMessage()) {
      // setState(() {
      // List<Message> messageArray = messages;
      // messageArray.add(Message(
      //     content: _messageController.text, date: DateTime.now().toString()));
      setState(() {
        messages.add(Message(
            sender: widget.user.email ?? '',
            receiver: widget.receiver,
            content: _messageController.text,
            date: DateTime.now().toString()));
      });

      // widget.messageDao.sendMessage(
      //     Chat(
      //         from: widget.user.email ?? '',
      //         to: widget.receiver,
      //         messages: messageArray),
      //     widget.user.email ?? '');

      widget.messageDao
          .sendMessageToChat(ChatLists(users: widget.users, messages: messages),
              widget.user.email ?? '')
          .then((value) {
        debugPrint('Message sent ? $value');
      }, onError: (e) {
        debugPrint(e);
      });
      _messageController.clear();
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    chatPopulator();
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiver)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            // chatPopulator(context),
            Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: _listView(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller: _messageController,
                      onChanged: (text) => setState(() {}),
                      onSubmitted: (input) {
                        _sendMessage();
                      },
                      decoration:
                          const InputDecoration(hintText: 'Enter new message'),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(_canSendMessage()
                        ? CupertinoIcons.arrow_right_circle_fill
                        : CupertinoIcons.arrow_right_circle),
                    onPressed: () {
                      _sendMessage();
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<DatabaseReference> refForChat(String sender) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await ref.once();

    final json = event.snapshot.value as Map<dynamic, dynamic>;
    DatabaseReference newRef = ref;
    json.forEach((key, value) {
      // var chats = Chat.fromJson(value);
      var chats = ChatListModel.fromJson(value);
      if (chats.chatLists.users.contains(sender)) {
        // chats.messages.add(chat.messages.last);
        newRef = ref.child(key).child("chat_lists").child("messages");
      }
    });
    return newRef;
  }

  Query getQuery() {
    Future<DatabaseReference> query = refForChat(widget.user.email ?? '');
    Query newQuery = FirebaseDatabase.instance.ref();
    query.then((value) {
      newQuery = value;
    }, onError: (e) {
      debugPrint(e);
    });
    return newQuery;
  }

  Widget _listView(BuildContext context) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        return MessageWidget(messages[index]);
      }),
      itemCount: messages.length,
    );
  }

  // Widget _getMessageList() {
  //   return Expanded(
  //     child: FirebaseAnimatedList(
  //       controller: _scrollController,
  //       query: getQuery(),
  //       itemBuilder: (context, snapshot, animation, index) {
  //         final json = snapshot.value as Map<dynamic, dynamic>;
  //         final chat = Chat.fromJson(json);
  //         // widget.receiver = chat.to;

  //         return MessageWidget(
  //             chat.messages.last.content, chat.messages.last.date);
  //       },
  //     ),
  //   );
  // }

  void chatPopulator() {
    Future<DatabaseReference> query = refForChat(widget.user.email ?? '');
    DatabaseReference newQuery = FirebaseDatabase.instance.ref();
    query.then((value) {
      newQuery = value;
    }, onError: (e) {
      debugPrint(e);
    });

    // Get the Stream

    // Stream<DatabaseEvent> stream = newQuery.onValue;

    var messagesLoadForFirstTime = getMessage();
    messagesLoadForFirstTime.then((value) {
      if (messages.length < value.length) {
        setState(() {
          messages = value;
        });
      }
    }, onError: (e) {
      debugPrint(e);
    });
    // if (stream.last == )
    // Subscribe to the stream!
    // stream.listen((DatabaseEvent event) {
    //   messages = [];
    //   debugPrint('Event Type: ${event.type}'); // DatabaseEventType.value;
    //   debugPrint('Snapshot: ${event.snapshot}'); // DataSnapshot
    //   debugPrint('Value: ${event.snapshot.value}');
    //   var json = event.snapshot.value as Map<dynamic, dynamic>;

    //   json.forEach((key, value) {
    //     var chats = Chat.fromJson(value);
    //     final sender = widget.user.email;
    //     if (chats.from == sender) {
    //       setState(() {
    //         messages.addAll(chats.messages);
    //       });
    //     }
    //   });
    // });
  }

  Future<List<Message>> getMessage() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await ref.once();
    var json = event.snapshot.value as Map<dynamic, dynamic>;
    List<Message> messagesList = [];
    json.forEach((key, value) {
      var chats = ChatListModel.fromJson(value);
      var messages = chats.chatLists.messages;

      final sender = widget.user.email ?? '';
      if (chats.chatLists.users.contains(sender)) {
        messagesList = messages;
      }
    });
    return messagesList;
  }

  Widget MessageWidget(Message message) {
    final DateTime dateTime = DateTime.parse(message.date);
    return Padding(
        padding: const EdgeInsets.only(left: 1, top: 5, right: 1, bottom: 2),
        child: Column(
          children: [
            // Padding(
            //     padding: const EdgeInsets.only(top: 4),
            //     child: Align(
            //         alignment: Alignment.topRight, child: Text(receiverName))),
            // Container(
            //     decoration: BoxDecoration(
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.grey[350]!,
            //               blurRadius: 2.0,
            //               offset: Offset(0, 1.0))
            //         ],
            //         borderRadius: BorderRadius.circular(50.0),
            //         color: Colors.white),
            //     child: MaterialButton(
            //         disabledTextColor: Colors.black87,
            //         padding: EdgeInsets.only(left: 18),
            //         onPressed: null,
            //         child: Wrap(
            //           children: <Widget>[
            //             Container(
            //                 child: Row(
            //               children: [
            //                 Text(message),
            //               ],
            //             )),
            //           ],
            //         ))),
            returnMessageScreen(message),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    DateFormat('yyyy-MM-dd, kk:mma')
                        .format(dateTime)
                        .toString(),
                    style: const TextStyle(color: Colors.grey),
                  )),
            ),
          ],
        ));
  }

  Widget returnMessageScreen(Message message) {
    return widget.user.email == message.sender
        ? SentMessageScreen(message: message.content)
        : ReceivedMessageScreen(message: message.content);
  }
}
