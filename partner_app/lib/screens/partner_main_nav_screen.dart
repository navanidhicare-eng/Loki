import 'package:flutter/material.dart';
import '../core/constants.dart';
import 'partner_home_screen.dart';
import 'partner_profile_screen.dart';

class PartnerMainNavScreen extends StatefulWidget {
  const PartnerMainNavScreen({Key? key}) : super(key: key);

  @override
  State<PartnerMainNavScreen> createState() => _PartnerMainNavScreenState();
}

class _PartnerMainNavScreenState extends State<PartnerMainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    PartnerHomeScreen(),
    PartnerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: PartnerConstants.primary,
          unselectedItemColor: PartnerConstants.textDim,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.flash_on_outlined),
              activeIcon: Icon(Icons.flash_on),
              label: 'Duty & Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'My Profile',
            ),
          ],
        ),
      ),
    );
  }
}
