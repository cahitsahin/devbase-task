import 'package:devbase/pages/homepage.dart';
import 'package:devbase/pages/login_register.dart';
import 'package:devbase/pages/splash_screen.dart';
import 'package:devbase/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: RootPage());
  }
}

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return SplashScreen();
            case Status.Unauthenticated:
              return LoginRegisterPage();
            case Status.Authenticated:
              return HomePage();
          }
          return Scaffold();
        },
      ),
    );
  }
}
