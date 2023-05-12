import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return Container();
          }
          final userData = snapshot.data!.data();
          return Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userData!['image_url']),
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                userData['username'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          );
        });
  }
}
