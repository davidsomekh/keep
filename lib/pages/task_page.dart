import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/db.dart';

class TaskPage extends StatefulWidget {
  final String name;
  final String id;
  final bool edit;

  const TaskPage(
      {Key? key, required this.name, required this.edit, required this.id})
      : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TextEditingController _controllerName = TextEditingController(text: "");

  @override
  void initState() {
    _controllerName.text = widget.name;
    super.initState();
  }

  String _getTitle() {
    if (!widget.edit) return "New Task";

    return "";
  }

  Future<void> addRecord(String name) async {
    try {
      await DB().addTaskRecord(name);

      //showError('Record added!');
    } on FirebaseException catch (e) {
      showError(e.message!);
    }
  }

  Future<void> deleteRecord(String id) async {
    try {
      await DB().deleteRecord(id);

      // showError('Record deleted!');
    } on FirebaseException catch (e) {
      showError(e.message!);
    }
  }

  Future<void> updateRecord(String id, String name) async {
    try {
      await DB().updateRecord(id, name);

      //showError('Record updated!');
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

  Widget _editWidget(TextEditingController controller) {
    return TextFormField(
      autofocus: true,
      controller: controller,
      decoration: _getNameEdit(),
    );
  }

  Widget _deleteButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, foregroundColor: Colors.white),
      onPressed: () {
        deleteRecord(widget.id);
        Navigator.of(context, rootNavigator: true).pop();
      },
      label: const Text("Delete"),
      icon: const Icon(Icons.delete),
    );
  }

  Widget _saveButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, foregroundColor: Colors.black),
      onPressed: () {
        if (!widget.edit) {
          addRecord(_controllerName.text);
          _controllerName.text = "";
        } else {
          updateRecord(widget.id, _controllerName.text);
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      label: const Text("Save"),
      icon: const Icon(Icons.send),
    );
  }

  Widget _buttons() {
    return Row(children: <Widget>[
      _saveButton(),
      if (widget.edit) const SizedBox(width: 20),
      if (widget.edit) _deleteButton()
    ]);
  }

  InputDecoration _getNameEdit() {
    if (!widget.edit) {
      return InputDecoration(
          border: const UnderlineInputBorder(), labelText: _getTitle());
    }

    return const InputDecoration(border: UnderlineInputBorder());
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _editWidget(_controllerName),
              const SizedBox(height: 10),
              _buttons(),
            ]),
      );
}
