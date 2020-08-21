import 'package:flutter/material.dart';
import 'package:notes_maker/Screens/Note_List.dart';
import 'package:notes_maker/Screens/Note_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Keeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: NoteList(),
    );
  }
}
