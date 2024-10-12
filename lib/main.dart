import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supermarket/Admin/home_admin.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supermarket/package/provider.dart';
import 'package:provider/provider.dart';
import 'package:supermarket/view/Login.dart';
import 'package:supermarket/view/details.dart';
import 'package:supermarket/view/splash.dart';
import 'package:supermarket/view/forgotpassword.dart';
import 'package:supermarket/view/category.dart';
import 'package:supermarket/view/home.dart';
import 'package:supermarket/view/order.dart';
import 'package:supermarket/view/profile.dart';
import 'package:supermarket/view/signup.dart';
import 'package:supermarket/view/wallet.dart';
import 'package:supermarket/view/onboard.dart';
import 'package:supermarket/view/bottomnav.dart';
import 'package:supermarket/view/login.dart';
import 'package:supermarket/Admin/api_manage.dart';


void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  const String Publishablekey ="pk_test_51Q1YJFKk5yMTe3Unf4wASMd2D22OON0g6uMqnEHb09rgf4Ukx2jjOC2yj0Zo8vLp70ZUEV3Rhrx48BAHNQqFwgcU00Q46YPWta";
  Stripe.publishableKey = Publishablekey;
  await Firebase.initializeApp().then((_) {
  print('Firebase connected successfully');
}).catchError((error) {
  print('Firebase connection failed: $error');
});

  runApp(
    MultiProvider(
      providers: [
    
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (_) => CartModel()),



      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
// routes: {
//   "/": (context) => Onboarding(),
//   "/home": (context) => Home(),
// },
  
    // home: BottomNav(),
      // home:Login(),
      // home:SignUp(),
     // home:ForgotPassword(),
      // home:Details(),
      // home:DetailsTwo(),
      // home:Profile(),
      // home:Order(),
      // home:Wallet(),
      //home:AdminLogin(),
      // home:HomeAdmin(),
      //home:add(),
      //home:Categories(),
     // home:SplashScreen(),
    // home:HomeAdmin(),
    home:EmployeeScreen()
    //home:ApiAdmin(),
    );
  }
}


// class StorageDemo extends StatefulWidget {
//   @override
//   _StorageDemoState createState() => _StorageDemoState();
// }

// class _StorageDemoState extends State<StorageDemo> {
//   TextEditingController _controller = TextEditingController();
//   String _storedData = '';

//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();
//     return directory.path;
//   }

//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/data.txt');
//   }

//   Future<File> writeData(String data) async {
//     final file = await _localFile;
//     return file.writeAsString(data);
//   }

//   Future<String> readData() async {
//     try {
//       final file = await _localFile;
//       String contents = await file.readAsString();
//       return contents;
//     } catch (e) {
//       return 'Error: $e';
//     }
//   }

//   void _saveData() async {
//     await writeData(_controller.text);
//     setState(() {
//       _storedData = _controller.text;
//     });
//   }

//   void _loadData() async {
//     String data = await readData();
//     setState(() {
//       _storedData = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Internal Storage Example')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: _controller),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _saveData,
//               child: Text('Save Data'),
//             ),
//             ElevatedButton(
//               onPressed: _loadData,
//               child: Text('Load Data'),
//             ),
//             SizedBox(height: 20),
//             Text('Stored Data: $_storedData'),
//           ],
//         ),
//       ),
//     );
//   }
// }
