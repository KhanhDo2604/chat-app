import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.message, this.userName, this.isMe, this.key);

  final String message;
  final bool isMe;
  final String userName;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.grey : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black : Colors.white),
                ),
                Text(
                  message,
                  style: TextStyle(color: isMe ? Colors.black : Colors.white),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ],
            ),
          ),
        ]);
  }
}
