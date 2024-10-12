import 'package:flutter/material.dart';


class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Supermarket!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16.0),
            Text(
              'Supermarket is your go-to app for discovering and ordering delicious food conveniently. We aim to provide the best food experience with a variety of options to suit all tastes.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.0),
            Text(
              'Features:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8.0),
            Text(
              '• Explore a variety of food items\n'
              '• Easy ordering process\n'
              '• Customized themes\n'
              '• User-friendly interface',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            SizedBox(height: 50,),

  SizedBox(height: 30,),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  foregroundColor: Colors.white,
                ),
                child: Icon(
                  Icons.home,color: Theme.of(context).colorScheme.secondary,
                )),
          ],
        ),
      ),
    );
  }
}
