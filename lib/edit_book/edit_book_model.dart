import 'dart:io';

import 'package:book_list_sample_new/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditBookModel extends ChangeNotifier {
  final Book book;
  EditBookModel(this.book) {
    imgURL = book.imgURL!;
    titleController.text = book.title;
    authorController.text = book.author;
    if (book.memo == null) {
      memoController.text = "";
    } else {
      memoController.text = book.memo!;
    }
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final memoController = TextEditingController();
  
  final picker = ImagePicker();

  String? title;
  String? author;
  String? memo;
  String? imgURL;
  File? imageFile;

  void setTitle(String title) {
    this.title = title;
    notifyListeners();
  }

  void setAuthor(String author) {
    this.author = author;
    notifyListeners();
  }

  void setMemo(String memo) {
    this.memo = memo;
    notifyListeners();
  }

  Future editBook() async {
    if (title == null || title == "") {
      throw 'タイトルが入力されていません';
    }

    if (author == null || author!.isEmpty) {
      throw '著者が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('books').doc();

    if (imageFile != null) {
      //storageにアップロード
      final task = await FirebaseStorage.instance
          .ref('books/${doc.id}')
          .putFile(imageFile!);
      imgURL = await task.ref.getDownloadURL();
    }

    //firestoreに追加
    await doc.set({
      'title': title,
      'author': author,
      'imgURL': imgURL,
      'memo': memo,
    });
  }

  bool isUpdated() {
    return title != null || author != null;
  }

  Future update() async {
    this.title = titleController.text;
    this.author = authorController.text;
    this.memo = memoController.text;
    this.imgURL = imgURL;

    //firestoreに追加
    await FirebaseFirestore.instance.collection('books').doc(book.id).update({
      'title': title,
      'author': author,
      'memo': memo,
      'imgURL': imgURL,
    });
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}
