import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_book_model.dart';

class EditBookPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBookModel>(
      create: (_) => EditBookModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('本を編集'),
        ),
        body: Center(
          child: Consumer<EditBookModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:[
                  TextField(
                    decoration:const InputDecoration(
                      hintText: '本のタイトル',
                    ),
                    onChanged: (text){
                      model.title = text;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration:const InputDecoration(
                      hintText: '本の著者',
                    ),
                    onChanged: (text){
                      model.author = text;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        // 追加の処理
                        try {
                          await model.update();
                          Navigator.of(context).pop(true);
                        } catch(e){
                          final snackBar = SnackBar(
                            backgroundColor:Colors.red,
                            content: Text(e.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text('更新する')),
                ],),
            );
          }),
        ),

      ),
    );
  }
}