

import 'package:diaster_ngo_app/features/auth/view/Forgotpassword.dart';
import 'package:diaster_ngo_app/features/auth/view/Splasch_screen.dart';
import 'package:diaster_ngo_app/features/auth/view/sigin.dart';
import 'package:diaster_ngo_app/features/auth/view/signup.dart';
import 'package:diaster_ngo_app/navigationmenu.dart';
import 'package:flutter/material.dart';

import 'routes_name.dart';



class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      //Authentication Screen
      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context) => const Splaschscreen());
      case RoutesName.sigin:
        return MaterialPageRoute(builder: (BuildContext context) => const Signin());

      case RoutesName.signup:
        return MaterialPageRoute(builder: (BuildContext context) => const Signup());

      case RoutesName.authwrapper:
        return MaterialPageRoute(builder: (BuildContext context) => const Signup());

      case RoutesName.forgotpassword:
        return MaterialPageRoute(builder: (BuildContext context) =>
        const ForgotPassword());


      case RoutesName.navigationmenu:
        return MaterialPageRoute(builder: (BuildContext context) =>
        const NavigationMenu());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}