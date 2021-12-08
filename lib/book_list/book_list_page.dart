import 'dart:ffi';

import 'package:book_list_sample_new/add_book/add_book_page.dart';
import 'package:book_list_sample_new/book_list/book_list_model.dart';
import 'package:book_list_sample_new/domain/book.dart';
import 'package:book_list_sample_new/edit_book/edit_book_page.dart';
import 'package:book_list_sample_new/login/login_page.dart';
import 'package:book_list_sample_new/mypage/my_model.dart';
import 'package:book_list_sample_new/mypage/my_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';


class BookListPage extends StatelessWidget {

  // ユーザーIDの取得
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<BookListModel>(
            create: (_) => BookListModel()..fetchBookList(uid:uid,isAllBook: true),
          ),
        ],
      child: DefaultTabController(
        length:2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('本棚'),
            // actions:[
            //   IconButton(
            //       onPressed: () async {
            //         //画面遷移
            //         if(FirebaseAuth.instance.currentUser != null){
            //           await Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => MyPage(),
            //             ),
            //           );
            //         }else{
            //           await Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => LoginPage(),
            //             ),
            //           );
            //         }
            //       },
            //       icon: Icon(Icons.person)),
            // ],
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text:'自分の本棚'),
                Tab(text:'他の人の本棚'),
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
              model.fetchBookList(uid:uid,isAllBook: false);

              final Iterable widgets = books
                  .map(
                    (book) => Slidable(
                      child: ListView.separated(
                         itemBuilder:(context,index){
                           ListTile(
                            leading: Container(child: book.imgURL!= null? Image.network(book.imgURL!, height:60,width:60,fit:BoxFit.cover):null),
                            title: Text(book.title),
                            subtitle: Text(book.author),
                          );},
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
                                }
                                //model.fetchBookList(uid:uid,isAllBook: false);
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
              Center(
                child: Consumer<BookListModel>(builder: (context, model, child) {
                  final List<Book>? books = model.books;

                  if(books == null)
                  {
                    return const CircularProgressIndicator();
                  }
                  model.fetchBookList(uid:uid,isAllBook: true);

                  final List<Widget> widgets = books
                      .map(
                        (book) => Slidable(
                      child: ListTile(
                        leading: book.imgURL!= null? Image.network(book.imgURL!, height:60,width:60,fit:BoxFit.cover):null,
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
                              }
                              //model.fetchBookList(uid:uid,isAllBook: true);
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
                  ).toList();
                  return ListView(
                    children:widgets,
                  );
                }),
              ),
            ],
          ),
        bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('マイページ'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('本追加'),
          ),
        ], fixedColor: Colors.blueAccent,
          unselectedItemColor: Colors.blueAccent,
          onTap: (index) async{
            if(index == 0){
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
            }else{
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
                  //model.fetchBookList(uid: uid, isAllBook: false);
            }
          }
        ),

          // floatingActionButton: Consumer<BookListModel>(builder: (context, model, child) {
          //     return FloatingActionButton(
          //       onPressed: () async{
          //         //画面遷移
          //         final bool? added = await Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => AddBookPage(),
          //             fullscreenDialog: true,
          //           ),
          //         );
          //
          //         if(added != null && added){
          //           final snackBar = SnackBar(
          //             backgroundColor:Colors.green,
          //             content: Text('本を追加しました'),
          //           );
          //           ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //         }
          //         model.fetchBookList(uid:uid,isAllBook: false);
          //
          //       },
          //       tooltip: 'Increment',
          //       child: const Icon(Icons.add),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }

  Future showConfirmDialog(BuildContext context, Book book, model){
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
