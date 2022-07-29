import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final List<int> _items = List<int>.generate(50, (int index) => index);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return ReorderableListView(
      buildDefaultDragHandles: false,
      children: <Widget>[
        for (int index = 0; index < _items.length; index++)
          Container(
            key: Key('$index'),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 64,
                  padding: const EdgeInsets.all(8),
                  child: ReorderableDragStartListener(
                    index: index,
                    child: ListTile(
                        key: Key('$index'),
                        tileColor: evenItemColor,
                        title: Text('Task ${_items[index]}'),
                        onTap: () => print("ListTile")),
                  ),
                )
              ],
            ),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        print("starting");
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final int item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
    );
  }
}
