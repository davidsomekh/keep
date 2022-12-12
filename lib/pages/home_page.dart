import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/db.dart';
import '/auth.dart';
import 'package:flutter/material.dart';
import '/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:math';

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

  Future<void> addRecord() async {
    try {
      await DB().addTestRecord();

      showError('Record added!');
    } on FirebaseException catch (e) {
      showError(e.message!);
    }
  }

  Future<void> updateRecord() async {
    try {
      await DB().updateTestRecord();

      showError('Record updated!');
    } on FirebaseException catch (e) {
      showError(e.message!);
    }
  }

  Future<void> deleteRecord() async {
    try {
      await DB().deleteTestRecord();

      showError('Record deleted!');
    } on FirebaseException catch (e) {
      showError(e.message!);
    }
  }

  Future<void> getRecords() async {
    //print('h')
    try {
      // DB().getCollectionUpdates();

      showError('Record deleted!');
    } on FirebaseException catch (e) {
      showError(e.message!);
    }
  }

  void showError(String msg) {
    var snackBar = SnackBar(content: Text(msg));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        DB().clearPersistence();
      },
      child: const Text('Sign Out'),
    );
  }

  Widget _editTaskButton() {
    return ElevatedButton(
      onPressed: () {
        updateRecord();
      },
      child: const Text('Edit Task'),
    );
  }

  Widget _deleteTaskButton() {
    return ElevatedButton(
      onPressed: () {
        deleteRecord();
      },
      child: const Text('Delete Task'),
    );
  }

  Widget _addTaskButton() {
    return ElevatedButton(
      onPressed: () {
        addRecord();
      },
      child: const Text('New Task'),
    );
  }

  Widget _source(String src) {
    return ElevatedButton(
      onPressed: () {
        addRecord();
      },
      child: Text(src),
    );
  }

  Widget _getTaskButton() {
    return ElevatedButton(
      onPressed: () {
        getRecords();
      },
      child: const Text('Get Tasks'),
    );
  }

  Widget _buildList(BuildContext context, QueryDocumentSnapshot? document) {
   // print(document);
    if (document == null) return const Text("hi");
    return ListTile(
      title: Text(document['name']),
      subtitle: Text(document['name']),
    );
  }

  Widget buildTest(Test rec) {
    return ListTile(title: Text(rec.name));
  }

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: 50 > random.nextInt(100)
              ? DB().getOnlineData()
              : DB().getOfflineData(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }

            //  if (snapshot.hasData) {
            //  return Text("Document does not exist");
            // }

            if (snapshot.connectionState == ConnectionState.done) {
              String src = 'online';
              bool? ds = snapshot.data?.metadata.isFromCache ?? false;
              if (ds) src = "offline";
                 // print(data);

              return Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    _source(src),
                    const SizedBox(height: 8),
                    _signOutButton(),
                    ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _buildList(
                              context, snapshot.data?.docs[index]);
                        }),
                  ],
                ),
              );

              //data.docs.forEach((key,value){

              // }

              // Map<String, dynamic> data = snapshot.data!;
              //     return Text("Printed data");
            }

            return const Text("good things");
          }),
    );
  }
}
