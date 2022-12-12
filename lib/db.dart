import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DB {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future addTestRecord() async {
    final docUser = FirebaseFirestore.instance.collection("test");
    final json = {"name": "david"};

    await docUser.add(json);
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

  Stream<List<Test>> getCollectionUpdates() => FirebaseFirestore.instance
      .collection('test')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Test.fromJson(doc.data())).toList());

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
