import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(this.chatId, this.username, this.userImage, this.name, this.img, 
      {super.key});
  final String chatId;
  final String username;
  final String userImage;
  final String name;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(username, style: const TextStyle(color: Colors.black),),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone),
            color: Colors.black,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera),
            color: Colors.black,
          ),
        ],
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        child: Column(children: [
          Expanded(
            child: Messages(chatId, username, userImage),
          ),
          NewMessage(chatId),
        ]),
      ),
    );
  }
}
