
import 'package:contact2_app/Databasehelper.dart';
import 'package:contact2_app/Model.dart';
import 'package:contact2_app/edit.dart';
import 'package:flutter/material.dart';

class contact extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  contact(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return contactState(this.note, this.appBarTitle);
  }
}

class contactState extends State<contact> {
  static var _priorities = ['High', 'Low'];
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  contactState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    nameController.text = note.name;
    numberController.text = note.number;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(appBarTitle,style: TextStyle(color: Colors.black),),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                  onPressed: () {
                    moveToLastScreen();
                  }),
              actions: <Widget>[
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Edit(note, appBarTitle)));
                    },
                    child: Icon(Icons.edit,color: Colors.black,))
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(2),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: CircleAvatar(
                          radius: 45,
                          child: Icon(
                            Icons.person,
                            size: 45,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  child: Text(
                                    'Name - ',
                                    style: TextStyle(fontSize: 24),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: Text('Number - ',
                                    style: TextStyle(fontSize: 24)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: Text('Email - ',
                                    style: TextStyle(fontSize: 24)),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  child: Text(
                                    note.name,
                                    style: TextStyle(fontSize: 24),
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: Text(note.number,
                                    style: TextStyle(fontSize: 24)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                child: Text(note.email,
                                    style: TextStyle(fontSize: 24)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
            )));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
    }
    return priority;
  }

  void updateTitle() {
    note.name = nameController.text;
  }

  void updateDescription() {
    note.number = numberController.text;
  }

  void updateEmail() {
    note.email = emailController.text;
  }

  void _save() async {
    moveToLastScreen();

    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
      print("update $result");
    } else {
      result = await helper.insertNote(note);
      print(result);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Contact Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (note.id == null) {
      _showAlertDialog('Status', 'No Contact was deleted');
      return;
    }

    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Task Deleted');
    } else {
      _showAlertDialog('Status', 'Error');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message), //
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}