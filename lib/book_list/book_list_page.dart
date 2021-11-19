import 'dart:ffi';

import 'package:book_list_sample_new/add_book/add_book_page.dart';
import 'package:book_list_sample_new/book_list/book_list_model.dart';
import 'package:book_list_sample_new/domain/book.dart';
import 'package:book_list_sample_new/edit_book/edit_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BookListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBookList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('本一覧'),
        ),
        body: Center(
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
                      title: Text(book.title),
                      subtitle: Text(book.author),
                    ),
                    // Specify a key if the Slidable is dismissible.
                    key: const ValueKey(0),
                    // The end action pane is the one at the right or the bottom side.

                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {}),
                      children: const [

                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 2,
                          backgroundColor: Color(0xFF7BC043),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: '編集',
                          onPressed: () async {
                            //編集画面に遷移
                              final bool? added = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditBookPage(),
                                ),
                              );

                              if(added != null && added){
                                final snackBar = SnackBar(
                                  backgroundColor:Colors.green,
                                  content: Text('本を編集しました'),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                              model.fetchBookList();
                            },
                        ),
                        SlidableAction(
                          backgroundColor: Color(0xFF0392CF),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '削除',
                          onPressed: (){
                            //削除しますか？って聞いて、はいだったら削除
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
    );
  }
}