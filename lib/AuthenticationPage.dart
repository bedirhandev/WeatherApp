import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

// My custom classes
import 'HomePage.dart';

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage();

  State<StatefulWidget> createState() {
    return _AuthenticationPageState();
  }
}

// Form for the login aswell as the registration page
class _Form {
  String email;
  String password;

  String buttonText1 = "Login";
  String buttonText2 = "Nog geen account? Registreer dan hier.";

  final key = GlobalKey<FormState>();

  emailValidator(String value) =>
      value.isEmpty ? 'Geef een geldig email op.' : null;

  passwordValidator(String value) =>
      value.isEmpty ? 'Geef een geldig wachtwoord op.' : null;

  reset() => key.currentState.reset();

  _Form();
}

// An enum whether to update the page based on it's current state
enum AuthenticationPageAction { Login, Register }

class _AuthenticationPageState extends State<AuthenticationPage> {
  // Initialize the enum with defautl
  AuthenticationPageAction _authenticationAction =
      AuthenticationPageAction.Login;
  // Initialize the form
  final _Form form = _Form();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool loading = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // methods
  bool save() {
    // Saves the values of the form after a button pressed
    bool isValid = form.key.currentState.validate();

    if (isValid) {
      form.key.currentState.save();
    }

    return isValid;
  }

  // The callback for login button if pressed
  void submit() async {
    if (save() == false) return;

    setState(() => loading = true);

    // If we are on the login page singin, else signup
    if (_authenticationAction == AuthenticationPageAction.Login) {
      try {
        await auth.signInWithEmailAndPassword(
            email: form.email, password: form.password);
      } catch (error) {
        print(error);
      }
    } else {
      await auth.createUserWithEmailAndPassword(
          email: form.email, password: form.password);
    }

    setState(() => loading = false);
  }

  // The callback for the registration button if pressed
  void update() {
    // Reset all form fields
    form.reset();

    // Updates the text of the buttons and the state of the enum
    setState(() {
      _authenticationAction =
          (_authenticationAction == AuthenticationPageAction.Login)
              ? AuthenticationPageAction.Register
              : AuthenticationPageAction.Login;

      form.buttonText1 =
          (_authenticationAction == AuthenticationPageAction.Login)
              ? "Login"
              : "Registreer";

      form.buttonText2 =
          (_authenticationAction == AuthenticationPageAction.Login)
              ? "Nog geen account? Registreer dan hier."
              : "Al een account? Log dan hier in.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weersverwachtingen'),
      ),
      body: (loading)
          ? Center(child: CircularProgressIndicator())
          : Container(
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
