import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/db/my_database.dart';

class NoteDetail extends StatefulWidget {
  String? appTitle;
  List<Map<String, dynamic>> noteList = [];
  int? id;

  NoteDetail(String appTitle, {int id = -1}) {
    this.appTitle = appTitle;
    this.id = id;
  }


  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {

  bool isGetData = true;

  @override
  void initState() {
    super.initState();
  }

  static var _priorities = [
    'Health care',
    'Education',
    'Work out',
    'Entertainment'
  ];
  TextStyle textStyle = const TextStyle(fontSize: 20, color: Colors.black);

  final GlobalKey<FormState> _validationKey = GlobalKey();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  int priorityInt = 1;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle!,
            style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w500)),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Colors.deepPurple,
      ),
      body: widget.id != -1 ? FutureBuilder(
        future: isGetData ? getNoteById() : null,
        builder: (context, snapshot) {

          if(snapshot.hasData && snapshot.data!=null) {
            isGetData = false;
            return Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, left: 10.0, right: 10.0),
              child: Form(
                key: _validationKey,
                child: ListView(children: <Widget>[
                  // First element
                  ListTile(
                    title: DropdownButton(
                        items: _priorities.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        style: textStyle,
                        value: getPriorityAsString(priorityInt),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            // debugPrint('User selected $valueSelectedByUser');

                            updatePriorityAsInt(valueSelectedByUser!);
                          });
                        }),
                  ),
                  // Second Element
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint('Something changed in Title Text Field');
                        // updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),

                  // Third Element
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) {
                        debugPrint(
                            'Something changed in Description Text Field');
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),

                  // Fourth Element
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: const Text(
                              'Save',
                            ),
                            onPressed: () async {
                              setState(() async {
                                if (titleController.text.trim() != '') {
                                  MyDataBase db = MyDataBase();
                                  int idOfInsert = -1;
                                  if (widget.id == -1) {
                                    Map<String, Object?> values = {
                                      'Title': titleController.text,
                                      'Description': descriptionController.text,
                                      'Date': DateFormat.yMMMd()
                                          .format(DateTime.now()),
                                      'Priority': priorityInt
                                    };
                                    idOfInsert =
                                    await db.insertNoteInNotes(values);
                                  } else {
                                    Map<String, Object?> values = {
                                      'Title': titleController.text,
                                      'Description': descriptionController.text,
                                      'Date': DateFormat.yMMMd()
                                          .format(DateTime.now()),
                                      'Priority': priorityInt
                                    };
                                    idOfInsert = await db.updateNoteInNotes(
                                        values, widget.id!);
                                    // idOfInsert = await db.updateNoteInNotes(values, widget.noteList[0]['NoteId']);
                                  }
                                  if (idOfInsert >= 1) {
                                    showAlert(
                                        context,
                                        widget.id! == -1
                                            ? 'Data Inserted Successfully'
                                            : 'Data Updated Successfully',
                                        idOfInsert);
                                  } else {
                                    showAlert(
                                        context,
                                        'Error While Inserting Note Detail',
                                        idOfInsert);
                                  }
                                } else {
                                  showAlert(context,
                                      'Error While Inserting Note Detail', -1);
                                }
                                // debugPrint("Save button clicked");
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 5.0,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            child: const Text(
                              'Delete',
                            ),
                            onPressed: () {
                              setState(() {
                                debugPrint("Delete button clicked");
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      )
          : Padding(
        padding: const EdgeInsets.only(
            top: 15.0, left: 10.0, right: 10.0),
        child: Form(
          key: _validationKey,
          child: ListView(children: <Widget>[
            // First element
            ListTile(
              title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityAsString(priorityInt),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      updatePriorityAsInt(valueSelectedByUser!);
                    });
                  }),
            ),
            // Second Element
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  // updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Third Element
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (value) {
                  debugPrint(
                      'Something changed in Description Text Field');
                  // updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),

            // Fourth Element
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: const Text(
                        'Save',
                      ),
                      onPressed: () async {
                        setState(() async {
                          if (titleController.text.trim() != '') {
                            MyDataBase db = MyDataBase();
                            int idOfInsert = -1;
                            if (widget.id == -1) {
                              Map<String, Object?> values = {
                                'Title': titleController.text,
                                'Description': descriptionController.text,
                                'Date': DateFormat.yMMMd()
                                    .format(DateTime.now()),
                                'Priority': priorityInt
                              };
                              idOfInsert =
                              await db.insertNoteInNotes(values);
                            } else {
                              Map<String, Object?> values = {
                                'Title': titleController.text,
                                'Description': descriptionController.text,
                                'Date': DateFormat.yMMMd()
                                    .format(DateTime.now()),
                                'Priority': priorityInt
                              };
                              idOfInsert = await db.updateNoteInNotes(
                                  values, widget.id!);
                            }
                            if (idOfInsert >= 1) {
                              showAlert(
                                  context,
                                  widget.id! == -1
                                      ? 'Data Inserted Successfully'
                                      : 'Data Updated Successfully',
                                  idOfInsert);
                            } else {
                              showAlert(
                                  context,
                                  'Error While Inserting Note Detail',
                                  idOfInsert);
                            }
                          } else {
                            showAlert(context,
                                'Error While Inserting Note Detail', -1);
                          }
                          // debugPrint("Save button clicked");
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text(
                        'Delete',
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Delete button clicked");
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),


    );
  }

  void showAlert(ctx, title, int id) {
    showCupertinoDialog(
      context: ctx,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          actions: [
            TextButton(
                onPressed: () {
                  if (id >= 1) {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  } else {
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Ok'))
          ],
        );
      },
    );
  }

  // Convert the String priority un the form of int before saving it toDB
  void updatePriorityAsInt(String value) {
    switch (value) {
      // 'Health care', 'Education', 'Work out', 'Entertainment'
      case 'Health care':
        priorityInt = 1;
        break;
      case 'Education':
        priorityInt = 2;
        break;
      case 'Work out':
        priorityInt = 3;
        break;
      default:
        priorityInt = 4;
        break;
    }
  }

  // Convert the int priority un the form of String before saving it toDB
  String getPriorityAsString(int priorityInt) {
    print('VALUE INT ::: $priorityInt');
    String priority;
    switch (priorityInt) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
      case 3:
        priority = _priorities[2];
        break;
      default:
        priority = _priorities[3];
    }
    return priority;
  }

  Future<int>   getNoteById() async {
    MyDataBase db = MyDataBase();
    widget.noteList = await db.getNoteByIdFromTable(widget.id!);
    titleController.text = widget.noteList[0]['Title'];
    descriptionController.text = widget.noteList[0]['Description'];
    priorityInt = widget.noteList[0]['Priority'];
    return priorityInt;
  }

}
