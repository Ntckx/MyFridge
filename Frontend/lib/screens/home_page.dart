import 'package:flutter/material.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../widget/myfridge_item.dart';
import '../theme/color_theme.dart';
import '../widget/additem_homepage.dart';

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

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddItemToMyFridge(addItem: _addItem,);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Material(
          elevation: 20.0,
          shadowColor: Colors.black,
          child: CustomAppBar(
            title: 'MyFridge',
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(path: "/"),
      backgroundColor: AppColors.blue, // Background color set to cream
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Slidable(
            key: Key('$item'),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    // Implement share functionality here
                  },
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.grey,
                  icon: Icons.edit,
                ),
                SlidableAction(
                  onPressed: (context) {
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.red,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: MyFridgeItemCard(
              quantity: item['quantity'],
              itemName: item['itemName'],
              isExpired: item['isExpired'],
              expiryDate: item['expiryDate'],
              description: item['description'],
              deleteItem: (context) => deleteItem(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: Color(0xFFF9DD6D),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
