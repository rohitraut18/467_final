// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyCustomForm2 extends StatefulWidget {
  const MyCustomForm2({Key? key}) : super(key: key);
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm2> {
  late String _email;
  late String _password;
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
        titleTextStyle:const TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold, color: Colors.black, fontSize: 30),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'SIGN-IN',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40,),
            ),
            const SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value) => _email = value!,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value) => _password = value!,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: signIn,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/first');
              },
              child: const Text(
                'New member? SIGNUP',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic,color: Colors.blue,decoration: TextDecoration.underline),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> signIn() async{
    final formState = _formKey.currentState;
    if(formState!.validate())
      {
        formState.save();
        try{
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully Signed IN.!')),);
        Navigator.pushNamed(context, '/dashboard');
        }
        catch(e){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Sorry!'),
                content: const Text("No User with the email provided \nTry Again!"),
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
      }
  }
}