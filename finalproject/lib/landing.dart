import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);
  @override
  State<Landing> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return const Icon(
              Icons.format_list_bulleted,
              color: Colors.black,
              size: 30.0,
            );
          },
        ),
        title: const Text("TASK HERO"),
        backgroundColor: Colors.redAccent,
        titleTextStyle: const TextStyle(
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 30,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("WELCOME TO",style: TextStyle(fontSize: 50,color: Colors.red,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,),),
          const Text("TASK HERO",style: TextStyle(fontSize: 60,color: Colors.red,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,),),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/first');
                },
                child: const Text('Register'),
              ),
              const SizedBox(width: 16),
              const Text("/"),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/second');
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
