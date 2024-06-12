import 'package:flutter/material.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/dialog_box.dart';
import 'package:myfridgeapp/widget/items_tile.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  late List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchListData();
  }

  final Logger _logger = Logger('ShoppingListPage');
  void fetchListData() async {
    try {
      final response = await Dio().post(
        'http://localhost:8000/allList',
        // Waiting For UserID
        data: {'UserID': 1},
      );
      final listData = response.data;
      if (response.statusCode == 200) {
        setState(() {
          items = List<Map<String, dynamic>>.from(listData);
        });
      }
      _logger.info('User data fetched successfully');
      print('User data fetched successfully');
    } catch (e) {
      _logger.severe('Error fetching user data: $e');
      print('Error fetching user data');
    }
  }

  void checkBoxChanged(bool? value, int index) async {
    try {
      final response = await Dio().patch(
        'http://localhost:8000/updateList',
        data: {
          'ListId': items[index]['ListID'],
          'isChecked': value,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          items[index]['isChecked'] = value;
        });
        print('Checkbox changed successfully');
      } else {
        print('Failed to update checkbox: ${response.data}');
      }
    } catch (e) {
      print('Error updating checkbox: $e');
    }
  }

  void saveNewItem() async {
    try {
      final response = await Dio().post(
        'http://localhost:8000/createList',
        data: {
          // Waiting For UserID
          'UserId': 1,
          'Listname': _itemNameController.text,
          'Quantity': int.parse(_quantityController.text),
          'isChecked': false,
        },
      );
      if (response.statusCode == 200) {
        fetchListData();
        _itemNameController.clear();
        _quantityController.clear();
        print('New item created successfully');
      } else {
        print('Failed to create new item: ${response.data}');
      }
    } catch (e) {
      print('Error creating new item: $e');
    }
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

  void deleteItem(int index) async {
    try {
      final response = await Dio().delete(
        'http://localhost:8000/deleteList',
        data: {
          // Waiting For UserID
          'ListId': items[index]['ListID'],
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          items.removeAt(index);
        });
        print('Item deleted successfully');
      } else {
        print('Failed to delete item: ${response.data}');
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  void clearAllItems() async{
     try {
    final response = await Dio().delete(
      'http://localhost:8000/deleteAllList',
      data: {
        // Waiting For UserID
        'UserId': 1,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        items.clear();
      });
      print('All items deleted successfully');
    } else {
      print('Failed to delete all items: ${response.data}');
    }
  } catch (e) {
    print('Error deleting all items: $e');
  }
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20.0),
          backgroundColor: AppColors.darkblue,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Text(
                  "Are you sure you want to clear all the list?",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(color: AppColors.white),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.darkblue),
                  ),
              child: Text("Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                clearAllItems();
                Navigator.of(context).pop();
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.white),
                  ),
              child: Text(
                "Clear all",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: AppColors.darkblue),
              ),
            ),
          ],
        );
      },
    );
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
        body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Wrapper(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, right: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: items.isNotEmpty
                            ? ElevatedButton(
                                onPressed: _showClearDialog,
                                child: Text(
                                  'clear all',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: AppColors.white),
                                ),
                              )
                            : SizedBox(),
                      ),
                    ),
                    items.isEmpty
                        ? const Center(
                            child: Text(
                              'No items in the list. Add some items!!',
                              style: TextStyle(color: AppColors.darkblue),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return ItemsTile(
                                    isChecked: items[index]['isChecked'],
                                    itemsName: items[index]['ListName'],
                                    quantity: items[index]['Quantity'],
                                    onChanged: (value) {
                                      checkBoxChanged(value, index);
                                    },
                                    deleteItem: (context) => deleteItem(index),
                                  );
                                },
                              ),
                            ),
                          )
                  ],
                ),
              ),
            )));
  }
}
