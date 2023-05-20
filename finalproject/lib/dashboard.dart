// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Dashboard> {
  final User? userid = FirebaseAuth.instance.currentUser;
  String _firstName = "";
  String _imageUrl = "";

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>(

        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  void _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userInfo = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        _firstName = userInfo.get('firstName');
        _imageUrl = userInfo.get('profilepic');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    return Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (BuildContext context) {return const Icon(
            Icons.format_list_bulleted,
            color: Colors.black,
            size: 30.0,
          ); },),
          title: const Text("TASK HERO"),
          backgroundColor: Colors.redAccent,
          titleTextStyle: const TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16),
            Row(
              children: [
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addtask');
                  },
                  child: const Text('ADD TASK'),
                ),
                const SizedBox(width: 60),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Image.network(_imageUrl,width: 400,height: 400,fit: BoxFit.cover,),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(radius: 40,backgroundImage: Image.network(_imageUrl).image,),
                ),
                const SizedBox(width: 60),
                ElevatedButton(
                  onPressed: signOut,
                  child: const Text('SIGN OUT'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Welcome, $_firstName !",
              style: const TextStyle(fontSize: 25, color: Colors.red,fontWeight: FontWeight.bold),
            ),
            const Text(
              'YOUR TASKS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('tasks').doc(userid!.uid).collection('subTasks').orderBy('title').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.data!.docs.isEmpty)
                  {
                    return const Center(child: Text("No tasks to display!",style: TextStyle(fontSize: 15),),);
                  }
                  else{
                    return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          dividerThickness: 2,
                          columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text('Sr. No')
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('Title')
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('Description')
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('Date')
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('Image'),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text('Status')
                              ),
                            ),
                          DataColumn(
                            label: Expanded(
                              child: Text('Actions')
                            ),
                          ),
                        ],
                          rows: rowscalc(snapshot),
                        )
                    );
                  }
                }
            )
          ],
        )
    );
  }

  List<DataRow> rowscalc(AsyncSnapshot<QuerySnapshot> snapshot)
  {
    List<DataRow> rows = [];
    for (var i = 0; i < snapshot.data!.docs.length; i++) {
      final eachuser = snapshot.data!.docs[i].data();
      String docId = snapshot.data!.docs[i].id;
      bool light1 = ((eachuser as Map)['status']);
      rows.add(
          DataRow(
            cells: <DataCell>[
              DataCell(Text((i + 1).toString())),
              DataCell(Text((eachuser)['title'])),
              DataCell(Text((eachuser)['description'])),
              DataCell(Text((eachuser)['date'])),
              DataCell(GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Image.network(eachuser['photoUrl'],width: 400,height: 400,fit: BoxFit.cover,)
                      );
                    },
                  );
                },
                child: Image.network(eachuser['photoUrl'],width: 40,height: 30,fit: BoxFit.cover,),
              )
              ),
              DataCell(Switch(value: light1,thumbIcon: thumbIcon,onChanged: (bool value) async {
                setState(() {
                    light1 = value;
                  });
                  await FirebaseFirestore.instance.collection('tasks').doc(userid!.uid).collection('subTasks').doc(docId).update({'status': value});
                  if (value == true) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Task Completed'),
                          content: const Text('Congratulations! You have completed this task.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              )),
              DataCell(
                Row(
                  children: [ElevatedButton(onPressed: () async {
                        SharedPreferences prefs0 = await SharedPreferences.getInstance();
                        prefs0.setString('docId', docId);
                        Navigator.pushNamed(context, '/edittask');},
                        child: const Icon(Icons.edit),
                      ),
                    const SizedBox(width: 5),
                    ElevatedButton(onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('docId', docId);
                        _dialogBuilder(context);
                      },
                      child: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ]
          )
      );
    }
    return rows;
  }


  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Option'),
          content: const Text('Are you sure you want to DELETE?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('YES'),
              onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? id = prefs.getString('docId');
              FirebaseFirestore.instance.collection('tasks').doc(userid!.uid).collection('subTasks').doc(id).delete();Navigator.of(context).pop();},
            ),
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('NO'),
              onPressed: () {Navigator.of(context).pop();},
            ),
          ],
        );
      },
    );
  }

  Future<void> signOut() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              child:const Text('Yes'),
              onPressed: () async {await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/');
              },
            ),
            TextButton(
              child:const Text('No'),
              onPressed: () {
              Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}