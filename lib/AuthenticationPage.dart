import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// My custom classes
import 'Authentication.dart';
import 'HomePage.dart';
import 'Database.dart';

class AuthenticationPage extends StatefulWidget {
  final AuthImplementation auth;
    // A callback to method setAuthentication inside the Authentication model
  final VoidCallback setAuthentication;

  AuthenticationPage({this.auth, this.setAuthentication});

  State<StatefulWidget> createState() {
    return _AuthenticationPageState();
  }
}

// Form for the login aswell as the registration page
class _Form {
  String email;
  String password;

  String buttonText1 ="Login";
  String buttonText2 = "Nog geen account? Registreer dan hier.";

  final key = GlobalKey<FormState>();

  emailValidator(String value) {
    return value.isEmpty ? 'Geef een geldig email op.' : null;
  }

  passwordValidator(String value) {
    return value.isEmpty ? 'Geef een geldig wachtwoord op.' : null;
  }

  reset() => key.currentState.reset();

  _Form();
}

// An enum whether to update the page based on it's current state
enum AuthenticationPageAction { Login, Register }

class _AuthenticationPageState extends State<AuthenticationPage> {
  // Initialize the enum with defautl
  AuthenticationPageAction _authenticationAction = AuthenticationPageAction.Login;
  // Initialize the form
  _Form form = _Form();

  bool loading = false;

  @override
   void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  // methods
  bool save() { // Saves the values of the form after a button pressed
    if(form.key.currentState.validate()) {
      form.key.currentState.save();
      return true;
    }
    return false;
  }

  // The callback for login button if pressed
  void submit() async {
    if(save()) { // Call the save method
      try {
        await setState(() => loading = true);

        // If we are on the login page singin, else signup
        String userId = (_authenticationAction == AuthenticationPageAction.Login) 
        ? await widget.auth.signIn(form.email, form.password)
        : await widget.auth.signUp(form.email, form.password);

        // If we get a user from Firebase 
        if(userId != null) {
          // Update status to user signed (in)
          widget.setAuthentication();

          // Add user to the database
          CollectionReference credentials = await Database.collections.credentials();
          credentials.add({
              'email': form.email,
              'password': form.password,
              'uid': userId
          });

          // Navigate to the homepage and forget all the previous routes
          // This disables the navigation between the homepage and this page
          Navigator
          .of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomePage(auth: widget.auth, setAuthentication: widget.setAuthentication)));
        }
      } catch(e) {
        // Catch the error if authenticating to Firebase fails
        print("Error: ${e.toString()}");
        await setState(() => loading = false);
      }
    }
  }

  // The callback for the registration button if pressed
  void update() {
    // Reset all form fields
    form.reset();

    // Updates the text of the buttons and the state of the enum 
    setState(() {
      _authenticationAction = (_authenticationAction == AuthenticationPageAction.Login) 
      ? AuthenticationPageAction.Register 
      : AuthenticationPageAction.Login;

      if(_authenticationAction == AuthenticationPageAction.Login) {
        form.buttonText1 = "Login";
        form.buttonText2 = "Nog geen account? Registreer dan hier.";
      } else {
        form.buttonText1 = "Registreer";
        form.buttonText2 = "Al een account? Log dan hier in.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weersverwachtingen'),
      ),
      body: (loading) ? Center(child: CircularProgressIndicator()) : Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: form.key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // A list of Widgets passed as children inside the Column
            children: inputs() + buttons(),
          ),
        ),
      ),
    );
  }

  // The methods to create the custom from fields
  List<Widget> inputs() {
    return [
      SizedBox(height: 10.0),
      logo(),
      SizedBox(height: 20.0),
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => form.emailValidator(value),
        onSaved: (value) => form.email = value,
      ),
      SizedBox(height: 10.0),
      TextFormField(
        decoration: InputDecoration(labelText: 'Wachtwoord'),
        obscureText: true,
        validator: (value) => form.passwordValidator(value),
        onSaved: (value) => form.password = value,
      ),
      SizedBox(height: 20.0),
    ];
  }

  Widget logo() {
    return Hero(
        tag: 'hero',
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 110.0,
            // The path to the logo (located in the rootfolder)
            child: Image.asset('images/logo.png')));
  }

  List<Widget> buttons() {
    return [
      RaisedButton(
        child: Text(form.buttonText1, style: TextStyle(fontSize: 20.0)),
        textColor: Colors.white,
        color: Colors.pink,
        onPressed: submit,
      ),
      FlatButton(
        child: Text(form.buttonText2, style: TextStyle(fontSize: 14.0)),
        textColor: Colors.pink,
        color: Colors.transparent,
        onPressed: update,
      ),
    ];
  }
}
