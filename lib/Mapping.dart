import 'package:flutter/material.dart';

// My custom classes
import 'AuthenticationPage.dart';
import 'HomePage.dart';
import 'Authentication.dart';
import 'Database.dart';

class Mapping extends StatefulWidget {
  final AuthImplementation auth;

  // Takes an instance of the class Authentication
  Mapping({this.auth});

  State<StatefulWidget> createState() {
    return _MappingState();
  }
}

// '''Considering making this class a Singleton''''

// Enum that keeps hold of the state whether a user is signed in or signed out
enum AuthStatus { unsigned, signed }

class _MappingState extends State<Mapping> {
  // Defines the enum to unsigned as default
  AuthStatus authStatus = AuthStatus.unsigned;

  // Runs first, before the build method
  @override
  void initState() {
    super.initState();

    // First sign the user out to make sure that we start fresh in the app
    widget.auth.signOut();
    
    // Get the current logged in user from Firebase
    widget.auth.getCurrentUser().then((userId) {
      // Update the enum according to whether the user exists or not
      setState(() {
        // If no user is found set the status to unsigned or else to signed
        authStatus = (userId == null) ? AuthStatus.unsigned : AuthStatus.signed;
      });
    });
  }

  // A function that is passed to other classes to update the Authentication status
  void _setAuthentication() {
    setState(() {
      authStatus = (authStatus == AuthStatus.signed) ? AuthStatus.unsigned : AuthStatus.signed;
    });
  }

  // After the init method took place, the build method starts
  @override
  Widget build(BuildContext context) {
    // If the enum state is signed; return the homepage and pass the data as argument
    // If the enum state is unsigned; return the AuthenticationPage and pass the data as argument
    if(authStatus == AuthStatus.signed) {
      return HomePage(auth: widget.auth, setAuthentication: _setAuthentication);
    } else {
      return AuthenticationPage(auth: widget.auth, setAuthentication: _setAuthentication);
    }
  }
}