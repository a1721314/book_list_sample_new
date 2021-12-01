import 'dart:ffi';

import 'package:book_list_sample_new/add_book/add_book_page.dart';
import 'package:book_list_sample_new/book_list/book_list_model.dart';
import 'package:book_list_sample_new/domain/book.dart';
import 'package:book_list_sample_new/edit_book/edit_book_page.dart';
import 'package:book_list_sample_new/login/login_page.dart';
import 'package:book_list_sample_new/mypage/my_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BookListPage(),
    );
  }
}

class BookListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
    create: (_) => BookListModel()..fetchBookList(),
      child: DefaultTabController(
        length:2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('本一覧'),
            actions:[
              IconButton(
                  onPressed: () async {
                    //画面遷移
                    if(FirebaseAuth.instance.currentUser != null){
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyPage(),
                        ),
                      );
                    }else{
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.person)),
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.cloud_outlined)),
                Tab(icon: Icon(Icons.beach_access_sharp)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
            child: Consumer<BookListModel>(builder: (context, model, child) {
              final List<Book>? books = model.books;

              if(books == null)
                {
                  return const CircularProgressIndicator();
                }

              final List<Widget> widgets = books
                  .map(
                    (book) => Slidable(
                      child: ListTile(
                        leading: book.imgURL!= null? Image.network(book.imgURL!):null,
                        title: Text(book.title),
                        subtitle: Text(book.author),
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children:  [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            backgroundColor: Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: '編集',
                            onPressed: (BuildContext context) async {
                              //編集画面に遷移
                                final String? title = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditBookPage(book),
                                  ),
                                );

                                if(title != null){
                                  final snackBar = SnackBar(
                                    backgroundColor:Colors.green,
                                    content: Text('$titleを編集しました'),
                                  );
                                  //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  print('編集完了！！！！！！！！！');
                                }
                                model.fetchBookList();

                              },
                          ),
                          SlidableAction(
                            backgroundColor: Color(0xFF0392CF),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: '削除',
                            onPressed: (BuildContext context) async{
                              //削除しますか？って聞いて、はいだったら削除
                              await showConfirmDialog(context,book,model);
                            },
                          ),
                        ],
                      ),

                    ),
              )
              .toList();
              return ListView(
                children:widgets,
              );
            }),
              ),
              Center(child: Text('雨', style: TextStyle(fontSize: 50))),
            ],
          ),
          floatingActionButton: Consumer<BookListModel>(builder: (context, model, child) {
              return FloatingActionButton(
                onPressed: () async{
                  //画面遷移
                  final bool? added = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddBookPage(),
                      fullscreenDialog: true,
                    ),
                  );

                  if(added != null && added){
                    final snackBar = SnackBar(
                      backgroundColor:Colors.green,
                      content: Text('本を追加しました'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  model.fetchBookList();

                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              );
            },
          ),
        ),
      ),
    );
  }

  Future showConfirmDialog(BuildContext context, Book book, BookListModel model){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("『${book.title}』を削除しますか？"),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async{
                //modelで削除
                await model.delete(book);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor:Colors.red,
                  content: Text('${book.title}を削除しました'),
                );
                model.fetchBookList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}