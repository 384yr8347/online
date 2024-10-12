// import 'package:flutter/material.dart';
// import 'dart:io';

// class FruitsVegetablesPage extends StatelessWidget {
//   final List<Map<String, dynamic>> items; // قائمة العناصر المضافة

//   FruitsVegetablesPage({required this.items});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fruits & Vegetables'),
//       ),
//       body: items.isEmpty
//           ? Center(child: Text('No items added yet'))
//           : ListView.builder(
//               itemCount: items.length,
//               itemBuilder: (context, index) {
//                 final item = items[index];
//                 return ListTile(
//                   leading: Image.file(File(item['image'])),
//                   title: Text(item['name']),
//                   subtitle: Text('${item['price']} USD\n${item['description']}'),
//                 );
//               },
//             ),
//     );
//   }
// }
