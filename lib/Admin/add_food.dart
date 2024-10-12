import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddFoodItem extends StatefulWidget {
  final Function(String name, double price, String description, String category, File image) onAdd;

  AddFoodItem({required this.onAdd});

  @override
  _AddFoodItemState createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Fruits & Vegetables';
  File? image;


  final ImagePicker _picker = ImagePicker(); 
  Future<void> pickImage() async {   //اختيار صوره للمنتج
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void addFoodItem() {
    final name = nameController.text; 
    final price = double.tryParse(priceController.text) ?? 0.0;
    final description = descriptionController.text;

    if (name.isNotEmpty && price > 0 && description.isNotEmpty && image != null) {
      widget.onAdd(name, price, description, selectedCategory, image!);
      Navigator.pop(context); // العودة إلى الواجهة السابقة
    } else {
      // عرض رسالة خطأ إذا كانت البيانات غير صحيحة
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Food Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name',labelStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color:Colors.grey)),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price',labelStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color:Colors.grey)),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description',labelStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color:Colors.grey)),
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
              SizedBox(height: 10),
              ElevatedButton(
                
                onPressed: pickImage,
                child: Text('Pick Image'),

              ),
              SizedBox(height: 10),
              image != null ? Image.file(image!) : Container(), // عرض الصورة المحددة
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addFoodItem,
                child: Text('Add Food Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
