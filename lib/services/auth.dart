import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  signUpUser({
    required String name,
    required String email,
    required String password,
    /*   required DateTime date, */
  }) async {
    UserCredential userCredentials = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    userCredentials.user!.updateDisplayName(name);
  }
}
