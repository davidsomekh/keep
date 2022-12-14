import 'package:firebase_auth/firebase_auth.dart';
import '/auth.dart';
import 'package:flutter/material.dart';
import '/google_sign_in.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final User? user = Auth().currentUser;

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

  Widget _userFullName() {
    return Text(user?.displayName ?? '');
  }

  Widget _userImage() {
    if (user?.photoURL == null) return const Text("");

    return CircleAvatar(
        radius: 40, backgroundImage: NetworkImage(user?.photoURL ?? ''));
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.googleLogout();
        signOut();
      
      },
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _userUid(),
                _userFullName(),
                _userImage(),
                const SizedBox(height: 6),
                _signOutButton(),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
