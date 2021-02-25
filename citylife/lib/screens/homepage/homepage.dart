import 'package:citylife/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final _authInstance = context.read<AuthService>();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Sign out"),
          onPressed: () => _authInstance.signOut(context),
        ),
      ),
    );
  }
}
