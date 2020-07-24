import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study2/domain/book.dart';
import 'package:flutter_study2/presentation/add_book/add_book_page.dart';
import 'package:provider/provider.dart';

import 'book_list_model.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBooks(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('BookList'),
        ),
        body: Consumer<BookListModel>(builder: (context, model, child) {
          final books = model.books;
          final listTiles = books
              .map(
                (book) => ListTile(
                  title: Text(book.title),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddBookPage(
                            book: book,
                          ),
                          fullscreenDialog: true,
                        ),
                      );
                      model.fetchBooks();
                    },
                  ),
                  onLongPress: () async {
                    // todo: 長押しで削除
                    await showDialog(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('${book.title}を削除しますか？'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () async {
                                Navigator.of(context).pop();

                                //todo: 削除のAPIをたたく
                                await deleteBook(model, context, book);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
              .toList();
          return ListView(
            children: listTiles,
          );
        }),
//      公式のやつ
//      body: StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance.collection('books').snapshots(),
//        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//          return ListView(
//            children: snapshot.data.documents.map((DocumentSnapshot document) {
//              return ListTile(
//                title: Text(document['title']),
////                subtitle: new Text(document['author']),
//              );
//            }).toList(),
//          );
//        },
//      ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(),
                  fullscreenDialog: true,
                ),
              );
              model.fetchBooks();
            },
          );
        }),
      ),
    );
  }
}

Future deleteBook(BookListModel model, BuildContext context, Book book) async {
  try {
    await model.deleteBook(book);
    await model.fetchBooks();
//    await _showDialog(context, '削除しました');
  } catch (e) {
    await _showDialog(context, e.toString());
  print(e.toString());
  }
}

Future _showDialog(BuildContext context, String title) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
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
