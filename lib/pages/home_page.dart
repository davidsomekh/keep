import 'package:firebase_auth/firebase_auth.dart';
import '/db.dart';
import '/auth.dart';
import 'package:flutter/material.dart';
import '/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;

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
      await DB().addTaskRecord("dart rules");

      //showError('Record added!');
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

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
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

  double GetListPadding() {
    if (kIsWeb) return 40;
    return 0;
  }

  Widget _getTaskButton() {
    return ElevatedButton(
      onPressed: () {
        getRecords();
      },
      child: const Text('Get Tasks'),
    );
  }

  Widget buildTest(Task rec) {
    int index = 22;
    return ListTile(key: Key(generateRandomString(7)), title: Text(rec.name));
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    final List<int> items = List<int>.generate(50, (int index) => index);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addRecord();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: _title(),
      ),
      body: StreamBuilder<List<Task>>(
        stream: DB().getCollectionUpdates(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error loading data! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            return ReorderableListView(
              padding: EdgeInsets.symmetric(horizontal: GetListPadding()),
              children: data.map(buildTest).toList(),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  print(newIndex);
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final int item = items.removeAt(oldIndex);
                  items.insert(newIndex, item);
                });
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
