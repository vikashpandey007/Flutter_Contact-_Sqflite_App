class Note {
  int _id;
  String _name;
  String _number;
  String _email;

  Note(this._name, this._number, this._email);

  Note.withId(this._id, this._name, this._number, this._email);

  int get id => _id;
  String get name => _name;
  String get number => _number;
  String get email => _email;

  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set number(String number) {
    this._number = number;
  }

  set email(String newEmail) {
    this._email = newEmail;
  }

  

  

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['number'] = _number;
    map['email'] = _email;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._number = map['number'];
    this._email = map['email'];
  }
}