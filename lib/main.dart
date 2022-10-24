import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Welcome to keeplist! 👋';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(

      children: <Widget>[
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              
              border: UnderlineInputBorder(),
              labelText: 'Enter your username 👇',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your password 👇',
            ),
            obscureText: true,
          ),
        ),
    
        Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
                          child: const Text('Submit'),

              onPressed: () {},
            ),
          ),
        ),
        Container(
             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton(
                          child: const Text('New User ❤️ '),

              onPressed: () {},
               style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                ),
            ),
          ),
        ),
        
      ],
      
    );
    
  }
}
