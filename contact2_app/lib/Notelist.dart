import 'package:contact2_app/Databasehelper.dart';
import 'package:contact2_app/Model.dart';
import 'package:contact2_app/contactdetail.dart';
import 'package:contact2_app/edit.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class Notelist extends StatefulWidget {
  @override
  _NotelistState createState() => _NotelistState();
}

class _NotelistState extends State<Notelist> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Phone",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: () {
                  navigateToDetail2(Note('', '', " "), 'Add Note');
                },
              )),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: getNoteListView(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {

      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.green,
      // ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Dismissible(
                      key: UniqueKey(),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 300),
                        child: Icon(Icons.call,color: Colors.white,),
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue,
                      child:  Padding(
                        padding: const EdgeInsets.only(left: 300),
                        child: Icon(Icons.message,color: Colors.white,),
                      ),
                      
                    ),
                      child: Card(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              elevation: 0.3,
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    navigateToDetail(this.noteList[position], 'Edit to do');
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  this.noteList[position].name,
                  style: TextStyle(color: Colors.black),
                ),

                // trailing: GestureDetector(
                //   child: Icon(Icons.open_in_new, color: Colors.white),
                //   onTap: () {
                //     navigateToDetail(this.noteList[position], 'Edit to do');
                //   },
                // ),
              ),
            ),
          );
        });
  }

  void navigateToDetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return contact(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void navigateToDetail2(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Edit(note, title);
    }));
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        {
          setState(() {
            this.noteList = noteList;
            this.count = noteList.length;
          });
        }
      });
    });
  }
}
