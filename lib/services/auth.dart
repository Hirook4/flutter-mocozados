import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String?> signUpUser({
    required String name,
    required String email,
    required String password,
    /*   required DateTime date, */
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
}
