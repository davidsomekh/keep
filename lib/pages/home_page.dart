import 'package:firebase_auth/firebase_auth.dart';
import '/db.dart';
import '/auth.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import '/pages/task_page.dart';

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

  String generateRandomString(int len) {
    var r = Random();
    return String.fromCharCodes(
        List.generate(len, (index) => r.nextInt(33) + 89));
  }

  double getListPadding() {
    if (kIsWeb) return 40;
    return 0;
  }

  Widget getTaskOVerlay(String taskName) {
    return Text(taskName,
        style: const TextStyle(
            color: Colors.black, decoration: TextDecoration.none));
  }

  void onTaskPage(
      BuildContext context, String taskName, bool taskEdit, String id) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return const Text("hi");
        },
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionBuilder: (context, anim1, anim2, child) {
          final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;

          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: anim1.value,
              child: TaskPage(name: taskName, edit: taskEdit, id: id),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300));
  }

  Widget buiidList(Task rec) {
    return ListTile(
      key: Key(rec.id),
      title: Text(rec.name),
      onTap: () {
        onTaskPage(context, rec.name, true, rec.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<int> items = List<int>.generate(50, (int index) => index);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onTaskPage(context, "", false, "");
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder<List<Task>>(
        stream: DB().getCollectionUpdates(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error loading data! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final data = snapshot.data!;

            return ReorderableListView(
              padding: EdgeInsets.symmetric(horizontal: getListPadding()),
              children: data.map(buiidList).toList(),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  // print(newIndex);
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
