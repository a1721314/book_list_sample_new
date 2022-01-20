import 'package:book_list_sample_new/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditBookModel extends ChangeNotifier {
  final Book book;
  EditBookModel(this.book) {
    titleController.text = book.title;
    authorController.text = book.author;
    if (book.memo == null) {
      memoController.text = "";
    }
    else{
      memoController.text = book.memo!; 
    }
  }

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final memoController = TextEditingController();

  String? title;
  String? author;
  String? memo;

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

  bool isUpdated() {
    return title != null || author != null || memo != null;
  }

  Future update() async {
    this.title = titleController.text;
    this.author = authorController.text;
    this.memo = memoController.text;

    //firestoreに追加
    await FirebaseFirestore.instance.collection('books').doc(book.id).update({
      'title': title,
      'author': author,
      'memo': memo,
    });
  }
}
