import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/dialog_box.dart';
import 'package:myfridgeapp/widget/items_tile.dart';
import 'package:myfridgeapp/widget/navbar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final _itemNameController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _storageLocationController = TextEditingController();

  List items = [
    [false, "Milk", "12/12/2021", "2% milk", "Fridge"],
    [true, "Apples", "12/12/2021", "Red apples", "Fridge"],
    [true,"Eggs", "12/12/2021", "Brown eggs", "Fridge"],
    [false, "Bread", "12/12/2021", "Whole wheat", "Pantry"],
    [false, "Butter", "12/12/2021", "Salted butter", "Fridge"],
    [false, "Cheese", "12/12/2021", "Cheddar cheese", "Fridge"]
  ];

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      items[index][0] = !items[index][0];
    });
  }

  void saveNewItem() {
    setState(() {
      items.add([
        false,
        _itemNameController.text,
        _expirationDateController.text,
        _descriptionController.text,
        _storageLocationController.text
      ]);
      _itemNameController.clear();
      _expirationDateController.clear();
      _descriptionController.clear();
      _storageLocationController.clear();
    });
    Navigator.of(context).pop();
  }

void createNewItem() {
  showDialog(
    context: context,
    builder: (context) {
      return DialogBox(
        itemNameController: _itemNameController,
        expirationDateController: _expirationDateController,
        descriptionController: _descriptionController,
        storageLocationController: _storageLocationController,
        onSaved: saveNewItem,
        onCanceled: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
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
      appBar: const CustomAppBar(
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
              padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
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
                  return const Center(
                    child: Text(
                      'No items in the list. Add some items!!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  return ItemsTile(
                    isChecked: items[index][0],
                    itemsName: items[index][1],
                    expirationDate: items[index][2],
                    description: items[index][3],
                    storageLocation: items[index][4],
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
