import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/widget/dialog_box.dart';
import 'package:myfridgeapp/widget/todo_tile.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({Key? key}) : super(key: key);

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final _controller = TextEditingController();
  List items = [
["Milk", false],
  ["Eggs", true],
  ["Bread", false],
  ["Butter", false],
  ["Cheese", false],

  ];

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      items[index][1] = !items[index][1];
    });
  }

  void saveNewItem() {
    setState(() {
      items.add([_controller.text, false]);
      _controller.clear();
    });
  }

  void createNewItem() {
    showDialog(context: context, builder:(context) {
      return DialogBox(
        controller: _controller,
        onSaved: saveNewItem,
        onCanceled: () {
          Navigator.of(context).pop();
        },
      );
    
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewItem,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ToDoTile(
                    itemsName: items[index][0],
                    isChecked: items[index][1],
                    onChanged: (value) {
                      checkBoxChanged(value, index);
                    },
                  );
                },
              ),
            ),
            const Text(
              'This is a Shopping List page.',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go("/"),
              child: const Text('Themed Button'),
            ),
          ],
        ),
      ),
    );
  }
}

