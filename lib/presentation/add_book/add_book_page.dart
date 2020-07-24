import 'package:flutter/material.dart';
import 'package:flutter_study2/presentation/add_book/add_book_model.dart';
import 'package:provider/provider.dart';

class AddBookPage extends StatelessWidget {
  AddBookPage({this.book}); //{}があれば引数がなくてもよくなる
  final book;
  @override
  Widget build(BuildContext context) {
    final bool isUpdate = book != null; // 引数があればtrueになり編集画面へ
    final textEditingController = TextEditingController();
    if (isUpdate) {
      textEditingController.text = book.title;
    }

    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isUpdate ? '本を編集' : '本を追加'),
        ),
        body: Consumer<AddBookModel>(builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: textEditingController,
                  onChanged: (text) {
                    model.bookTitle = text;
                  },
                ),
                RaisedButton(
                  child: Text(isUpdate ? '更新する' : '追加する'),
                  onPressed: () async {
                    if (isUpdate) {
                      await updateBook(model, context);
                    } else {
                      // todo: firebaseに値を追加
                      await addBook(model, context);
                    }
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Future addBook(AddBookModel model, BuildContext context) async {
    try {
      await model.addBookToFirebase();
      await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('保存しました'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future updateBook(AddBookModel model, BuildContext context) async {
    try {
      await model.updateBook(book);
      await showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('更新しました'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}