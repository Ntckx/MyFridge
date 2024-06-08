import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/myfridge_item.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/additem_homepage.dart';
import 'package:myfridgeapp/widget/edititem_homepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> items = [
    {
      "quantity": 1,
      "itemName": "Egg",
      "isExpired": false,
      "expiryDate": "01/01/2001",
      "description": "Amet ea nisi deserunt culpa ea anim",
    },
    {
      "quantity": 100,
      "itemName": "Milk",
      "isExpired": false,
      "expiryDate": "01/01/2023",
      "description":
          "Lorem Ea sunt elit sunt nulla elit reprehenderit excepteur. Exercitation in laborum excepteur aliquip esse ullamco eiusmod id cillum.",
    },
    {
      "quantity": 100,
      "itemName": "Milk",
      "isExpired": true,
      "expiryDate": "01/01/2023",
      "description":
          "Lorem Ea sunt elit sunt nulla elit reprehenderit excepteur. Exercitation in laborum excepteur aliquip esse ullamco eiusmod id cillum.",
    },
    {
      "quantity": 100,
      "itemName": "Milk",
      "isExpired": true,
      "expiryDate": "01/01/2023",
      "description":
          "Lorem Ea sunt elit sunt nulla elit reprehenderit excepteur. Exercitation in laborum excepteur aliquip esse ullamco eiusmod id cillum.",
    },
    // Add more items here
  ];

  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _addItem(
      String itemName, String expiryDate, int quantity, String description) {
    setState(() {
      items.add({
        "quantity": quantity,
        "itemName": itemName,
        "isExpired": false, // Calculate based on expiryDate if needed
        "expiryDate": expiryDate,
        "description": description,
      });
    });
  }

  void _updateItem(int index, String itemName, String expiryDate, int quantity,
      String description) {
    setState(() {
      items[index] = {
        "quantity": quantity,
        "itemName": itemName,
        "isExpired": false, // Calculate based on expiryDate if needed
        "expiryDate": expiryDate,
        "description": description,
      };
    });
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddItemToMyFridge(addItem: _addItem);
      },
    );
  }

  void _showEditItemDialog(int index, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditItemInMyFridge(
          updateItem: (itemName, expiryDate, quantity, description) {
            _updateItem(index, itemName, expiryDate, quantity, description);
          },
          itemName: item['itemName'],
          expiryDate: item['expiryDate'],
          quantity: item['quantity'],
          description: item['description'],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(80.0), // Set your desired height here
        child: CustomAppBar(
          title: 'MyFridge',
          // height: 80.0, // Ensure the height is set here as well
        ),
      ),
      bottomNavigationBar: const BottomNav(path: "/"),
      backgroundColor: AppColors.blue,
      body: Stack(
        children: [
          Container(
            color: AppColors.blue,
          ),
          Positioned(
            top:
                50, // Adjust this value to position the white container correctly
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                      60.0), // Change this to your desired radius
                ),
              ),
              height: MediaQuery.of(context).size.height -
                  50, // Adjust height as needed
            ),
          ),
          Positioned(
            top: 0, // Adjust this value to position the list correctly
            left: 0,
            right: 0,
            bottom: 0, // Set bottom to 0 to fill the remaining space
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Center(
                  child: Container(
                    width: 350, // Set a fixed width to center the card
                    margin: const EdgeInsets.symmetric(
                        vertical: 10), // Add vertical margin for spacing
                    child: Slidable(
                      key: Key('$item'),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _showEditItemDialog(index, item);
                            },
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.grey,
                            icon: Icons.edit,
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              deleteItem(index);
                            },
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: MyFridgeItemCard(
                        initialQuantity: item['quantity'],
                        itemName: item['itemName'],
                        isExpired: item['isExpired'],
                        expiryDate: item['expiryDate'],
                        description: item['description'],
                        deleteItem: (context) => deleteItem(index),
                        editItem: (context) => _showEditItemDialog(index, item),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: const Color(0xFFF9DD6D),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
