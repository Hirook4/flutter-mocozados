import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /* Faz cadastro do usuario */
  Future<String?> signUpUser({
    required String name,
    required String email,
    required String password,
    /* required DateTime date, */
  }) async {
    try {
      UserCredential userCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredentials.user!.updateDisplayName(name);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        print("Usuario já cadastrado");
        return "Usuario já cadastrado!";
      }
      return "Erro Desconhecido";
    }
  }

  /* Faz login do usuario */
  Future<String?> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOutUser() async {
    return _firebaseAuth.signOut();
  }
}
