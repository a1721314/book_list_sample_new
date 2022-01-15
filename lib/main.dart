import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'book_list/book_list_page.dart';
import 'login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  // ユーザ情報がDBにあるか
  bool checkExistUserInfo () {
    bool isExist = false;
    if (user != null) {
      var doc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
      if (doc.id != null) {
        isExist = true;
      }
    }
  return isExist;
  }

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    home: checkExistUserInfo() ? BookListPage() : LoginPage(),
  );
  }
}