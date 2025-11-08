import 'package:flutter/material.dart';
import 'package:flutter_application_1/Frontend/pages/bottomNavBar.dart';

class infoPage extends StatelessWidget {
  const infoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Info Page',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color.fromARGB(255, 90, 90, 90),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/main_logo.png',
              height: 50,
              width: 50,
            ),
          )
        ],
      ),
      bottomNavigationBar: bottomNavBar(),
      backgroundColor: Color(0xffF0F0F2),
      body: Center(
        child: Text('Read Books',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff5A5A5A))),
      ),
    );
  }
}
