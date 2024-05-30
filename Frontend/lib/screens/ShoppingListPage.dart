import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myfridgeapp/widget/dialog_box.dart';
import 'package:myfridgeapp/widget/items_tile.dart';
import 'package:myfridgeapp/widget/NavBar.dart';
import 'package:myfridgeapp/widget/CustomAppBar.dart';

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
    Navigator.of(context).pop();
  }

  void createNewItem() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSaved: saveNewItem,
            onCanceled: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void clearAllItems() {
    setState(() {
      items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Shopping List',
      ),
      bottomNavigationBar: const BottomNav(path: "/shoppinglist"),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewItem,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: clearAllItems,
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: Color.fromARGB(255, 255, 141, 152)),
                  ),
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: items.length == 0 ? 1 : items.length,
              itemBuilder: (context, index) {
                if (items.length == 0) {
                  return Center(
                    child: Text(
                      'No items in the list. Add some items!!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  return ItemsTile(
                    itemsName: items[index][0],
                    isChecked: items[index][1],
                    onChanged: (value) {
                      checkBoxChanged(value, index);
                    },
                    deleteItem: (context) => deleteItem(index),
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
