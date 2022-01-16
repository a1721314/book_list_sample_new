import 'package:book_list_sample_new/domain/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookListModel extends ChangeNotifier {
  List<Book>? books;

  void fetchBookList({required String uid, required bool isAllBook}) async {
    final QuerySnapshot snapshot;

    // booksコレクションのデータを取得
    if (isAllBook == true) {
      snapshot = await FirebaseFirestore.instance
          // 全ての本を取得
          .collection('books')
          .where('uid', isNotEqualTo: uid)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          // 自身の本のみ取得
          .collection('books')
          .where('uid', isEqualTo: uid)
          .get();
    }

    final List<Book> books = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String title = data['title'];
      final String author = data['author'];
      final String? imgURL = data['imgURL'];
      final String uid = data['uid'];
      final String? memo = data['memo'];
      return Book(id, title, author, imgURL, uid, memo);
    }).toList();

    this.books = books;
    notifyListeners();
  }

  Future delete(Book book) {
    return FirebaseFirestore.instance.collection('books').doc(book.id).delete();
  }
}
