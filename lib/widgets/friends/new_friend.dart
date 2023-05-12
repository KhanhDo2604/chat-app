import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewFriend extends StatefulWidget {
  const NewFriend({super.key});

  @override
  State<NewFriend> createState() => _NewFriendState();
}

class _NewFriendState extends State<NewFriend> {
  String _enterMessage = '';

  final _controller = new TextEditingController();

  void _addFriend(String name) async {
    FocusScope.of(context).unfocus();
    final add = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: name)
        .get();
    final user = await FirebaseAuth.instance.currentUser!;

    final currentUserData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (add.size != 0) {
      final ref = await FirebaseFirestore.instance.collection('chat').add({});

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection("friends")
          .doc(add.docs[0].id)
          .set({
        'friendname': add.docs[0]['username'],
        'friendimg': add.docs[0]['image_url'],
        'chatId': ref.id,
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(add.docs[0].id)
          .collection("friends")
          .doc(user.uid)
          .set({
        'friendname': currentUserData['username'],
        'friendimg': currentUserData['image_url'],
        'chatId': ref.id,
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: const Text("user not found")));
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          child: Container(
        padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                // border: InputBorder.none,
                hintText: 'Add your friend',
              ),
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _enterMessage = value.toString();
                });
              },
            ),
            ElevatedButton(
                onPressed: () => _addFriend(_enterMessage),
                child: const Text('Add'))
          ],
        ),
      )),
    );
  }
}
