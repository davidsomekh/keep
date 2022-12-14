import 'package:firebase_auth/firebase_auth.dart';
import '/auth.dart';
import 'home_page.dart';
import 'account_page.dart';
import 'package:flutter/material.dart';

class NavPage extends StatefulWidget {
  const NavPage({Key? key}) : super(key: key);

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  final User? user = Auth().currentUser;

  int screen  = 0;

  int getScreen(){
    return screen;
  }

  void setScreen(int iScreen){
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      screen = iScreen;
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void showError(String msg) {
    var snackBar = SnackBar(content: Text(msg));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _userUid() {
    return Text(
      user?.email ?? '',
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _title() {
    return const Text('Welcome to keeplist! 👋');
  }

  Widget _nav()
  {
    if(getScreen() == 0) {
      return const HomePage();
    }
    
      return const AccountPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: _userUid(),
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('List'),
                onTap: () {
                  setScreen(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Account'),
                onTap: () {
                  setScreen(1);
                  Navigator.pop(context);

                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
         appBar: AppBar(
        title: _title(),
      ),
        body: _nav());
  }
}
