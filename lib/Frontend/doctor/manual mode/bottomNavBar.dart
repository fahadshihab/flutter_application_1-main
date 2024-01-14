import 'package:flutter/material.dart';

class bottomNavBar extends StatelessWidget {
  const bottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        selectedItemColor: Color.fromARGB(255, 0, 70, 136),
        unselectedItemColor: Color.fromARGB(255, 0, 70, 136),
        onTap: (value) {
          if (value == 0) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/calibration', (route) => false);
          } else if (value == 1) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/manual', (route) => false);
          } else if (value == 2) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/therapy', (route) => false);
          } else if (value == 3) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/info', (route) => false);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/colors/calibration icon (1).png',
              height: 30,
            ),
            label: 'Calibration',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/colors/Manual icon B.png',
              height: 30,
            ),
            label: 'Manual',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/colors/therapy icon B.png',
              height: 30,
            ),
            label: 'Therapy',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/colors/info icon B.png',
              height: 30,
            ),
            label: 'Info',
          ),
        ]);
  }
}
