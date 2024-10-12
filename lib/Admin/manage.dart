import 'dart:io';
import 'package:flutter/material.dart';

class EditFoodItem extends StatefulWidget {
  final String name;
  final double price;
  final String description;
  final String category;
  final File image;
  final Function(String name, double price, String description, String category, File image) onUpdate;

  EditFoodItem({
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.onUpdate,
  });

  @override
  _EditFoodItemState createState() => _EditFoodItemState();
}

class _EditFoodItemState extends State<EditFoodItem> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = '';
  File? image;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    priceController.text = widget.price.toString();
    descriptionController.text = widget.description;
    selectedCategory = widget.category;
    image = widget.image;
  }

  void updateFoodItem() {
    final name = nameController.text;
    final price = double.tryParse(priceController.text) ?? 0.0;
    final description = descriptionController.text;

    if (name.isNotEmpty && price > 0 && description.isNotEmpty) {
      widget.onUpdate(name, price, description, selectedCategory, image!);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Food Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: <String>[
                  'Fruits & Vegetables',
                  'Meat & Seafood',
                  'Dairy & Cheese',
                  'Bakery & Pastries',
                  'Canned Goods',
                  'Beverages',
                  'Snacks & Chocolate'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),  
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateFoodItem,
                child: Text('Update Food Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
