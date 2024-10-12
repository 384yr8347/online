import 'package:flutter/material.dart';
import 'home.dart'; 
import 'package:supermarket/package/dark_light_mode.dart';
import 'package:supermarket/view/bottomnav.dart';

import 'package:supermarket/package/provider.dart';
class Categories extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {
      'name': 'Fruits & Vegetables',
      'image': 'assets/fruits_vegetables.jpg',
    },
    {
      'name': 'Meat & Seafood',
      'image': 'assets/meat_seafood.png',
    },
    {
      'name': 'Dairy & Cheese',
      'image': 'assets/dairy_cheese.jpg',
    },
    {
      'name': 'Bakery & Pastries',
      'image': 'assets/bakery_pastries.jpg',
    },
    {
      'name': 'Canned Goods',
      'image': 'assets/canned_goods.jpg',
    },
    {
      'name': 'Beverages',
      'image': 'assets/beverages.jpg',
    },
    {
      'name': 'Snacks & Chocolate',
      'image': 'assets/snacks_chocolate.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Categories' ,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary,),),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back,color: Theme.of(context).colorScheme.secondary,), 
          onPressed: () {
            Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNav(),
                          )); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3 / 4, 
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()), 
                );
              },
              child: GridTile(
                child: Image.asset(
                  categories[index]['image']!,
                  fit: BoxFit.cover,
                ),
                footer: Container(
                  color: Colors.black54,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      categories[index]['name']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
