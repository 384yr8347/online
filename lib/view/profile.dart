import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supermarket/view/Login.dart';
import 'package:supermarket/package/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:supermarket/view/signup.dart';
import 'home.dart';
import 'bottomnav.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? profile, name, email;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    profile = await SharedPreferenceHelper().getUserProfile();
    name = await SharedPreferenceHelper().getUserName();
    email = await SharedPreferenceHelper().getUserEmail();
  }

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
      await uploadProfileImage();
    }
  }

  Future<void> uploadProfileImage() async {
    if (selectedImage != null) {
      String addId = randomAlphaNumeric(10);
      await SharedPreferenceHelper().saveUserProfile(addId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNav(),
                ));
          },
        ),
      ),
      body: FutureBuilder(
        future: loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                buildProfileHeader(context),
                const SizedBox(height: 20.0),
                buildProfileDetail(
                  "Name",
                  name ?? "Not available",
                  Icons.person,  Theme.of(context).colorScheme.onSecondary,
                ),
                const SizedBox(height: 30.0),
                buildProfileDetail(
                    "Email", email ?? "Not available", Icons.email, Theme.of(context).colorScheme.onSecondary),
                const SizedBox(height: 30.0),
                buildActionButton("Log Out", Icons.logout, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ));
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildProfileHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
          height: MediaQuery.of(context).size.height / 4.3,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.vertical(
              bottom:
                  Radius.elliptical(MediaQuery.of(context).size.width, 150.0),
            ),
          ),
        ),
        Center(
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 6.5),
            child: Material(
              elevation: 10.0,
              borderRadius: BorderRadius.circular(60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: GestureDetector(
                  onTap: getImage,
                  child: selectedImage == null || profile!.isEmpty
                      ? (profile == null
                          ? Image.asset("assets/food.jpg",
                              height: 120, width: 120, fit: BoxFit.cover)
                          : Image.asset("assets/food.jpg",
                              height: 120, width: 120, fit: BoxFit.cover))
                      : Image.file(selectedImage!,
                          height: 120, width: 120, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Center(
            child: Text(
              name ?? 'User Name', // Show a placeholder if name is null
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildProfileDetail(String title, String value, IconData icon,Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.onSecondary),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 2.0,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 20.0),
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
