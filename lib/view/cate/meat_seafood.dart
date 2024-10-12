// import 'package:flutter/material.dart';
// import 'dart:io';

// class MeatSeafoodPage extends StatelessWidget {
//   final List<Map<String, dynamic>> items;

//   MeatSeafoodPage({required this.items});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Meat & Seafood'),
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
