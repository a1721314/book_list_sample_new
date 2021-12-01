import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyModel extends ChangeNotifier{

  bool isLoading = false;
  String? name;
  String? email;
  String? descrition;

  void startLoading(){
    isLoading = true;
    notifyListeners();
  }

  void endLoading(){
    isLoading = true;
    notifyListeners();
  }

  void fetchUser() async{
    final user = FirebaseAuth.instance.currentUser;
    this.email = user?.email;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    this.name = data?['name'];
    this.descrition = data?['description'];

    notifyListeners();
  }

  Future logout() async{
    await FirebaseAuth.instance.signOut();
  }
}