import 'package:flutter/material.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/calibration_Page.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/info.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/manual_Mode.dart';
import 'package:flutter_application_1/Frontend/doctor/manual%20mode/therapymode.dart';

class bottomNavBar extends StatelessWidget {
  const bottomNavBar({super.key});
  void _navigateWithoutAnimation(
      BuildContext context, String routeName, Widget destinationPage) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            destinationPage,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child; // No animation, return the child directly
        },
        transitionDuration: Duration.zero, // Disable animation
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        elevation: 5,
        backgroundColor: Color(0xffEAEBF1),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        selectedItemColor: Color.fromARGB(255, 0, 70, 136),
        unselectedItemColor: Color.fromARGB(255, 0, 70, 136),
        onTap: (value) {
          if (value >= 0 && value <= 3) {
            String currentRoute = ModalRoute.of(context)!.settings.name ?? '';

            if (value == 0 && currentRoute != '/calibration') {
              _navigateWithoutAnimation(
                  context, '/calibration', calibration_page());
            } else if (value == 1 && currentRoute != '/manual') {
              _navigateWithoutAnimation(context, '/manual', manualMode());
            } else if (value == 2 && currentRoute != '/therapy') {
              _navigateWithoutAnimation(context, '/therapy', therapyMode());
            } else if (value == 3 && currentRoute != '/info') {
              _navigateWithoutAnimation(context, '/info', infoPage());
            }
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
