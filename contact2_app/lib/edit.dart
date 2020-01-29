
import 'package:contact2_app/Databasehelper.dart';
import 'package:contact2_app/Model.dart';
import 'package:flutter/material.dart';



class Edit extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  Edit(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return EditState(this.note, this.appBarTitle);
  }
}

class EditState extends State<Edit> {
  static var _priorities = ['High', 'Low'];
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  EditState(this.note, this.appBarTitle);

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
          backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(appBarTitle,style: TextStyle(color: Colors.black)),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                  onPressed: () {
                    moveToLastScreen();
                  }),
                  
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
                          child: Icon(Icons.person,size: 45,),
                        ) ),
                      
                    
                    Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: TextField(
                            controller: nameController,
                            style: textStyle,
                            onChanged: (value) {
                              updateTitle();
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: textStyle,
                              icon: Icon(Icons.person,color: Colors.black,),
                            ))),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: TextField(
                          controller: numberController,
                          style: textStyle,
                          onChanged: (value) {
                            updateDescription();
                          },
                          decoration: InputDecoration(
                              labelText: 'Mobile No.',
                              labelStyle: textStyle,
                              icon: Icon(Icons.phone,color: Colors.black,))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: TextField(
                          controller: emailController,
                          style: textStyle,
                          onChanged: (value) {
                            updateEmail();
                          },
                          decoration: InputDecoration(
                              labelText: 'Email Id',
                              labelStyle: textStyle,
                              icon: Icon(Icons.email,color: Colors.black,))),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.green,
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        )),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                            child: RaisedButton(
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          },
                        ))
                      ]),
                    )
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
			content: Text(message),//
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}
}