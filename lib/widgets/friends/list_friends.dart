import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ListFriends extends StatefulWidget {
  const ListFriends({super.key});

  @override
  State<ListFriends> createState() => _ListFriendsState();
}

class _ListFriendsState extends State<ListFriends> {
  var fetchUser = null;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        fetchUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (ctx, futureSnapShot) {
        if (futureSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('friends')
                .snapshots(),
            builder: (ctx, chatSnapShot) {
              if (chatSnapShot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!chatSnapShot.hasData) return Container();
              final chatDocs = chatSnapShot.data!.docs;

              return ListView.builder(
                itemCount: chatSnapShot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    margin: const EdgeInsets.only(top: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                    chatDocs[index]['chatId'],
                                    chatDocs[index]['friendname'],
                                    chatDocs[index]['friendimg'],
                                    fetchUser['username'],
                                    fetchUser['image_url'],
                                  )),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(chatDocs[index]['friendimg']),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Text(
                              chatDocs[index]['friendname'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            });
      },
    );
  }
}
