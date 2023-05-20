// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);
  @override
  State<AddTask> createState() => _MyHomePageState();
  }


class _MyHomePageState extends State<AddTask> {
  String _title= "";
  String _description = "";
  String _date = "";
  bool gallery = true;
  File? _image;
  List<XFile>? _imageFileList;
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
        title: const Text("TASK HERO"),
        backgroundColor: Colors.redAccent,
        titleTextStyle: const TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'ADD NEW TASK',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40, color: Colors.redAccent),
            ),
            const SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty ) {
                  return 'Please enter Title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'TITLE',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Description';
                }
                return null;
              },
              onSaved: (value) => _description = value!,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DESCRIPTION',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Date';
                }
                return null;
              },
              onSaved: (value) => _date = value!,
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
              child: const Text('ADD TASK'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:(){ Navigator.pushNamed(context, '/dashboard');},
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
    if(formState!.validate())
    {
      formState.save();
      try{
        User? user = FirebaseAuth.instance.currentUser;
        String userid = user!.uid;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref().child("tasks/$userid/$fileName.jpg");
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();
        FirebaseFirestore.instance.collection('tasks').doc(userid).collection('subTasks').doc().set({
          'title': _title,
          'description': _description,
          'date': _date,
          'photoUrl': downloadURL,
          'status': false,
        });
        Navigator.pushNamed(context, '/dashboard');
      }
      catch(e){
        if (kDebugMode) {
          print("Error $e");
        }
      }
    }
  }
}