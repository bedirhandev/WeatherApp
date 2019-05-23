import 'package:cloud_firestore/cloud_firestore.dart';

//custom imports
import 'Authentication.dart';

class Collections {
  final AuthImplementation _auth = Authentication();

  Collections() {}

  Future<CollectionReference> credentials() async {
    String userId = await this._auth.getCurrentUser();
    
    if(userId != null) {
      return Database.databaseReference
              .collection('users')
              .document(userId)
              .collection('credentials');
    }
  }

  Future<CollectionReference> favoCities() async {
    String userId = await this._auth.getCurrentUser();
    
    if(userId != null) {
      return Database.databaseReference
              .collection('users')
              .document(userId)
              .collection('favoCity');
    }
  }
}

class Database {
  static final databaseReference = Firestore.instance;
  static Collections collections = Collections();
}