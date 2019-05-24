import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// My custom classes
import 'AuthenticationPage.dart';
import 'HomePage.dart';

class Mapping extends StatefulWidget {
  final auth = FirebaseAuth.instance;

  // Takes an instance of the class Authentication
  Mapping();

  State<StatefulWidget> createState() {
    return _MappingState();
  }
}

class _MappingState extends State<Mapping> {
  @override
  void initState() {
    widget.auth.signOut();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var loggedIn = Provider.of<FirebaseUser>(context) != null;
    return (loggedIn) ? HomePage() : AuthenticationPage();
  }
}
