import 'package:firebase_auth/firebase_auth.dart';
import '/auth.dart';
import 'package:flutter/material.dart';
import '/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
   
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Welcome to keeplist! 👋');
  }

  Widget _userUid() {
    return Text(user?.email ?? '');
  }

  Widget _userFullName() {
    return Text(user?.displayName ?? '');
  }

  Widget _userImage() {
    if (user == null) return const Text("no image");

    return CircleAvatar(
        radius: 40, backgroundImage: NetworkImage(user?.photoURL ?? ''));
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: (){
           final provider = Provider.of<GoogleSignInProvider>(context,listen:false);
           provider.googleLogout();
           signOut();
      },
      child: const Text('Sign Out'),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 32),
            _userImage(),
            const SizedBox(height: 8),
            _userFullName(),
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
