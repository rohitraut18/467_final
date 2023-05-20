import 'package:finalproject/addtask.dart';
import 'package:finalproject/dashboard.dart';
import 'package:finalproject/edittask.dart';
import 'package:finalproject/first.dart';
import 'package:finalproject/landing.dart';
import 'package:finalproject/second.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      theme: ThemeData(
      useMaterial3: true,  colorSchemeSeed: Colors.redAccent),
      title: 'Final',
      initialRoute: '/',
      routes: {
        '/': (context) => const Landing(),
        '/first': (context) => const MyCustomForm(),
        '/second': (context) => const MyCustomForm2(),
        '/dashboard': (context) => const Dashboard(),
        '/addtask': (context) => const AddTask(),
        '/edittask': (context) => const EditTask(),
      },
    ),
  );
}
