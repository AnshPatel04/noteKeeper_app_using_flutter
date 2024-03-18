import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_keeper/db/my_database.dart';
import 'note_details.dart';

class NoteListPage extends StatefulWidget {
  const NoteListPage({super.key});


  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {

  List<Map<String, dynamic>> mainList = [];
  List<Map<String, dynamic>> filterList = [];
  List<Map<String, dynamic>> noteList = [];

  var logos = ['assets/images/noun-health-5967585.png',
    'assets/images/noun-education-1100140.png',
    'assets/images/noun-gym-4460797.png',
    'assets/images/noun-game-6568451.png'];

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(fontSize: 27,color: Colors.white,fontWeight: FontWeight.w500)),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return NoteDetail('Add Note');
              },
            ),
          ).then((value) {
            setState(() {

            });
          });

        },

        tooltip: 'Add Note',

        child: Icon(Icons.add),

      ),

      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(5),
            height: 40,

            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(CupertinoIcons.search),
                suffixIcon: InkWell(
                    onTap: (){
                      searchController.text = '';
                      setState(() {

                      });
                    },
                    child: Icon(Icons.close,color: Colors.grey,)),
                hintText: 'Search',
                contentPadding: EdgeInsets.only(bottom: 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              controller: searchController,
              onChanged: (value) {
                filterList.clear();
                for (int i = 0; i < mainList.length; i++) {
                  if (mainList[i]['Title']
                      .toString()
                      .toLowerCase()
                      .contains(searchController.text.toLowerCase())) {
                      // .contains(value.toLowerCase())) {
                    filterList.add(mainList[i]);
                  }
                }
                setState(() {
                  if (searchController.text.isNotEmpty){
                    noteList = filterList;
                  }else{
                    noteList = mainList;
                  }
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: MyDataBase().getNotesFromTable(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  mainList = snapshot.data!;

                  if (searchController.text.isEmpty){
                    noteList = mainList;
                  }
            
                  return noteList.isNotEmpty
                      ? ListView.builder(
                    itemCount: noteList.length,
                    itemBuilder: (context, index) {
                        return Card(
                            color: Colors.white,
                            elevation: 2.0,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.yellow,
                                child: Image.asset(logos[noteList[index]['Priority']-1],fit: BoxFit.cover,),
                              ),
            
                              title: Text("${noteList[index]['Title']}", style: TextStyle(fontWeight: FontWeight.w500)),
                              subtitle: Text(noteList[index]['Description']),
            
                              trailing: Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(noteList[index]['Date'],style: TextStyle(fontSize: 12.3,color: Colors.grey.shade600),),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // getItemBuilderWidget(index);
                                      setState(() {
                                        MyDataBase db = MyDataBase();
                                        db.deleteNote(noteList[index]['NoteId']);
                                        // int i = index;
                                        // noteList.removeAt(index);
                                        // noteList.remove(i);
                                      });
                                    },
                                    child: InkWell(
                                        child: const Icon(Icons.delete, color: Colors.grey,)))
                                ],
                              ),
            
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return  NoteDetail('Edit Note', id: noteList[index]['NoteId'],);
                                    },
                                  ),
                                ).then((value) {
                                  setState(() {
            
                                  });
                                });
                              },
                            )
                        );
                      },
                  )
                      : const Center(
                          child: Text(
                            'No Data Found',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        );
            
                } else{
                  return  const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getItemBuilderWidget(index) {

    return Card(
      color: Colors.white,
      elevation: 5,
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: index == noteList.length ? 10 : 0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30, // Image radius
              backgroundColor: Colors.yellow,
              // backgroundImage: AssetImage(
              //   'assets/images/bg_1.jpg',
              // ),
            ),
            SizedBox(width: 10),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                    noteList[index]['Title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: index % 2 == 0 ? Colors.orange : Colors.black,
                        fontSize: 25,
                      ),
                    ),

                  ],
                ),
            ),
            InkWell(
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 40,
              ),
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return   CupertinoAlertDialog(
                        title: Text(
                          'Alert!',
                        ),
                        content: Text(
                          'Are you sure want to delete this user?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // noteList.removeAt(index);
                                noteList.remove(index);
                              });
                            },
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'),
                          ),
                      ],
                    );

                  },
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
