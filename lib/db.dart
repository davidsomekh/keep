import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DB {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future addTaskRecord(String name) async {
    if (_firebaseAuth.currentUser?.uid == null) return;

    String? sUID = _firebaseAuth.currentUser?.uid;

    final usersCollection = FirebaseFirestore.instance.collection('users');
    final docUser = usersCollection.doc(sUID);
    final sTasksCollection = docUser.collection('tasks');

    Task t = Task(created: Timestamp.now());
    t.owner = sUID!;
    t.name = name;

    await sTasksCollection.add(t.toJson());
  }

  void clearPersistence() async {
    if (!kIsWeb) {
      await FirebaseFirestore.instance.terminate();
      await FirebaseFirestore.instance.clearPersistence();
    }

    // await FirebaseFirestore.instance.settings();
  }

  Future updateTestRecord() async {
    final docUser = FirebaseFirestore.instance.collection("test");
    final json = {"name": "david_edit"};

    await docUser.doc('HyPC5RPLr4IgycWRs2W7').update(json);
  }

  Future deleteTestRecord() async {
    final docUser = FirebaseFirestore.instance.collection("test");
    await docUser.doc('HyPC5RPLr4IgycWRs2W7').delete();
  }

  Stream<List<Task>> getCollectionUpdates() => FirebaseFirestore.instance
      .collection('users')
      .doc(_firebaseAuth.currentUser?.uid)
      .collection('tasks')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Task.fromJson(doc.data(),doc.id)).toList());
          


  Future<QuerySnapshot<Map<String, dynamic>>> getOfflineData() =>
      FirebaseFirestore.instance
          .collection("test")
          .get(const GetOptions(source: Source.cache));

  Future<QuerySnapshot<Map<String, dynamic>>> getOnlineData() =>
      FirebaseFirestore.instance
          .collection("test")
          .get(const GetOptions(source: Source.server));
}

class Test {
  String name;
  Test({this.name = ''});

  static Test fromJson(Map<String, dynamic> json) => Test(
        name: json['name'],
      );
}

class Task {
  bool deleted = false;
  bool done = false;
  String name = "babo";
  String owner = "dave";
  int priority = 3;
  String project = "inbox";
  String id="";
  Timestamp created;
  Task({
    this.name = '',
    this.done = false,
    this.deleted = false,
    this.owner = "dave",
    this.priority = 3,
    this.id="",
    this.project = 'inbox',
    required this.created,
    // this.created = '',
//    this.created = FieldValue.serverTimestamp(),
  });

  static Task fromJson(Map<String, dynamic> json,String sDocID) => Task(
        name: json['name'],
        done: json['done'],
        deleted: json['deleted'],
        owner: json['owner'],
        priority: json['priority'],
        project: json['project'],
        id:sDocID,
        created: json['created'] ?? Timestamp.now(),
      );

  String getTimeStamp() {
    DateTime now = DateTime.now();
    return now.toString();
  }

  Map<String, dynamic> toJson() => {
        'deleted': deleted,
        'done': done,
        'name': name,
        'owner': owner,
        'priority': priority,
        'project': project,
        'created': FieldValue.serverTimestamp()
      };
}
