class Notes {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Notes(this._title, this._date, this._priority,
      [this._description]); //without id

  Notes.withId(this._id, this._title, this._date, this._priority,
      [this._description]);

  //Getter
  int get id => _id;

  String get title => _title;

  String get description => _description;

  String get date => _date;

  int get priority => _priority;

  //Setter  , not required for id column , as it automatically sets id with each entry.

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      //setting conditions before saving to database(title has to less than 255 characters)
      this._title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      //setting conditions before saving to database(title has to less than 255 characters)
      this._description = newDescription;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

  //function to convert data into map
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>(); //constructor

    if (id != null) {
      //to check for new insertion
      map['id'] = _id;
    }

    map['title'] = _title; //convert to map then store.
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;

    return map;
  }

  //Extraction Note data from map objects
  Notes.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._priority = map['priority'];
  }
}
