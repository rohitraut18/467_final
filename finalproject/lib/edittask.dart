// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditTask extends StatefulWidget {
  const EditTask({Key? key}) : super(key: key);
  @override
  State<EditTask> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<EditTask> {
  String title= "";
  String description = "";
  String date = "";
  String imageid = "";
  bool gallery = true;
  String docId = "";
  final User? userid = FirebaseAuth.instance.currentUser;
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _date = TextEditingController();
  File? _image;
  List<XFile>? _imageFileList;

  @override
  void initState() {
    super.initState();
    getdata();
    getid();
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> getdata() async {
    DocumentSnapshot docid2 = await FirebaseFirestore.instance.collection('tasks').doc(userid!.uid).collection('subTasks').doc(docId).get();
    setState(() {
      _title.text = docid2.get('title');
      _description.text = docid2.get('description');
      _date.text = docid2.get('date');
      imageid = docid2.get('photoUrl');
    });
  }

  Future<void> getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    docId = prefs.getString('docId')!;
    getdata();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {return const Icon(
          Icons.format_list_bulleted,
          color: Colors.black,
          size: 30.0,
        ); },),
        title:const Text("TASK HERO"),
        backgroundColor: Colors.redAccent,
        titleTextStyle:const TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'EDIT TASK',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.redAccent),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _title,
              validator: (value) {
                if (value == null || value.isEmpty ) {
                  return 'Please enter Title';
                }
                return null;
              },
              onSaved: (value) => title = value!,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TITLE',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Description';
                }
                return null;
              },
              onSaved: (value) => description = value!,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DESCRIPTION',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _date,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Date';
                }
                return null;
              },
              onSaved: (value) => date = value!,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DATE (MM/DD/YYYY)',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => getImage(ImageSource.gallery, gallery: true),
                    child: const Text("CHOOSE IMAGE"),
                  ),
                ),
                const SizedBox(width: 20),
                const Text("OR"),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => getImage(ImageSource.camera, gallery: false),
                    child: const Text("CAPTURE IMAGE"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: createTask,
              child: const Text('EDIT TASK'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:(){ Navigator.pushNamed(context, '/dashboard');docId = "";} ,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> getImage(ImageSource source,
      {BuildContext? context, required bool gallery}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
      );
      setState(() {
        if (pickedFile != null) {
          if (gallery==false) {
            _image = File(pickedFile.path);
          }
          else {
            _setImageFileListFromFile(pickedFile);
          }
        }});
    } catch (e) {
      setState(() {
      });
    }
  }
  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
    _image = File(_imageFileList![0].path);
  }

  Future<void> createTask() async{
    final formState = _formKey.currentState;
    User? user = FirebaseAuth.instance.currentUser;
    String userid = user!.uid;
    if(formState!.validate())
    {
      formState.save();
      if(_image==null)
      {
        FirebaseFirestore.instance.collection('tasks').doc(userid).collection('subTasks').doc(docId).update({
          'title': title,
          'description': description,
          'date': date,
          'photoUrl': imageid,
        });
        Navigator.pushNamed(context, '/dashboard');
      }
      else
        {
          try{
            String fileName = DateTime.now().millisecondsSinceEpoch.toString();
            Reference ref = FirebaseStorage.instance.ref().child("tasks/$userid/$fileName.jpg");
            UploadTask uploadTask = ref.putFile(_image!);
            TaskSnapshot taskSnapshot = await uploadTask;
            String downloadURL = await taskSnapshot.ref.getDownloadURL();
            FirebaseFirestore.instance.collection('tasks').doc(userid).collection('subTasks').doc(docId).update({
              'title': title,
              'description': description,
              'date': date,
              'photoUrl': downloadURL,
            });
            Navigator.pushNamed(context, '/dashboard');
          }
          catch(e){
            print("Error $e");
          }
        }
      docId = "";
    }
  }
}