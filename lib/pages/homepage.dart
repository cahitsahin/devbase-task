import 'package:devbase/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
          userRepo.signOut();
        }),
      ],title: Text("MainPage"),),
      body: Center(),
    );
  }
}
