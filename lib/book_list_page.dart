import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study2/book_list_model.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBooks(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('booklist'),
        ),
        body: Consumer<BookListModel>(builder: (context, model, child) {
          final books = model.books;
          final listTiles = books
              .map((book) => ListTile(
                    title: Text(book.title),
                  ))
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
      ),
    );
  }
}
