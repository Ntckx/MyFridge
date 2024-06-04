import 'package:flutter/material.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/dialog_box.dart';
import 'package:myfridgeapp/widget/items_tile.dart';
import 'package:myfridgeapp/widget/navbar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();

  List items = [
    [false, "Milk", 2],
    [true, "Apples", 1],
    [true, "Eggs", 12],
    [false, "Bread", 1],
    [false, "Butter", 1],
    [false, "Cheese", 2],
  ];

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      items[index][0] = value;
    });
  }

  void saveNewItem() {
    setState(() {
      items.add([
        false,
        _itemNameController.text,
        int.parse(_quantityController.text),
      ]);
      _itemNameController.clear();
      _quantityController.clear();
    });
    Navigator.of(context).pop();
  }

  void createNewItem() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          itemNameController: _itemNameController,
          quantityController: _quantityController,
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
      body: Wrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                    onPressed: clearAllItems,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.transparent),
                    ),
                    child: Text(
                      'clear all',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: AppColors.darkblue,
                              ),
                    )),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'No items in the list. Add some items!!',
                        style: TextStyle(color: AppColors.darkblue),
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ItemsTile(
                          isChecked: items[index][0],
                          itemsName: items[index][1],
                          quantity: items[index][2],
                          onChanged: (value) {
                            checkBoxChanged(value, index);
                          },
                          deleteItem: (context) => deleteItem(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
