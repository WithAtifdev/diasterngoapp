
import 'package:diaster_ngo_app/features/alerts/view/alerts_screen.dart';
import 'package:diaster_ngo_app/features/home/view/home_screen.dart';
import 'package:diaster_ngo_app/features/ngos/view/ngos_screen.dart';
import 'package:diaster_ngo_app/features/profile/view/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int selectedIndex = 0;

  Widget getScreen(int index) {
    switch (index) {
      case 0: return HomeScreen();
      case 1: return AlertsScreen();
      case 2: return NGOScreen();
      case 3: return ProfileScreen();
      default: return HomeScreen();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getScreen(selectedIndex),
      // body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        height: 80,
        elevation: 0,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        backgroundColor: Colors.grey[900],
        indicatorColor: Colors.white.withValues(alpha: 0.3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
labelTextStyle: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
    return const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    }
    return TextStyle(color: Colors.grey[400]);
    }),

    // style icons for dark background
        destinations: [
          NavigationDestination(
            icon: Icon(Iconsax.home, color: Colors.grey[400]),
            selectedIcon: Icon(Iconsax.home, color: Colors.white),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.error_outline,color: Colors.grey[400]),
            selectedIcon: Icon(Icons.error_outline, color: Colors.white,),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism, color: Colors.grey[400]),
            selectedIcon: Icon(Icons.volunteer_activism, color: Colors.white,),
            label: 'NGOS',
          ),
          NavigationDestination(
            icon: Icon(Iconsax.user, color: Colors.grey[400]),
            selectedIcon: Icon(Iconsax.user, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}