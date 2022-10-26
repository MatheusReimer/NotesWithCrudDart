import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopping_list7/db/notes.dart';

import 'note.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note>? notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();

    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  Future addNote(String title) async {
    final note = Note(
      title: title,
      isImportant: true,
      description: "",
      time: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);
  }

  String fieldText = "";

  showAlertDialog(BuildContext context, int index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No, Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Caution"),
      content: Text("Are you sure you want to delete this list?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 200,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Form(
                            child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                height: 100,
                                child: TextFormField(
                                    onChanged: (text) {
                                      fieldText = text;
                                    },
                                    cursorColor: Color.fromARGB(255, 0, 0, 0),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          width: 1.0,
                                        ),
                                      ),
                                      labelText: 'Name of the List',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          width: 2.0,
                                        ),
                                      ),
                                      labelStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.auto,
                                    )))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            SizedBox(width: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text('Create'),
                              onPressed: () => {
                                print(fieldText),
                                setState(() {
                                  addNote(fieldText);
                                }),
                                refreshNotes(),
                                Navigator.pop(context)
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 30,
          ),
        ),
        body: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 120,
                  padding: EdgeInsets.all(8),
                ),
                Text(
                  "Your Lists",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontFamily: 'BebasNeue'),
                ),
              ]),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            alignment: Alignment.centerRight,
          ),
          Expanded(
              child: notes != null
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: notes?.length,
                      padding: EdgeInsets.all(8),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => {},
                          onDoubleTap: () {
                            showAlertDialog(context, index);
                          },
                          /*,
                    setState(() {
                      lists.removeWhere((element) => element == lists[index]);
                    });
                    */

                          child: Card(
                            color: Color.fromARGB(0, 0, 0, 0),
                            child: Center(
                                child: Text(
                              notes!.length > 0
                                  ? notes![index].title
                                  : "Still nothing here",
                              style: TextStyle(color: Colors.white),
                            )),
                          ),
                        );
                      })
                  : Text("Add notes to show here")),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [Container()])
        ]));
  }
}
