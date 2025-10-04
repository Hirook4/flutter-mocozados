import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /* Cadastro */
  Future<String?> signUpUser({
    required String name,
    required String email,
    required String password,
    required DateTime birthDate,
  }) async {
    try {
      /* Cria usuario no Firebase Auth */
      UserCredential userCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      /* Atualiza displayName do Firebase Auth */
      await userCredentials.user!.updateDisplayName(name);

      /* Salva dados no Firestore */
      await _firestore.collection('users').doc(userCredentials.user!.uid).set({
        'name': name,
        'birthDate': birthDate.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "Email já cadastrado!";
      }
      return "Erro Desconhecido";
    }
  }

  /* Login */
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
      switch (e.code) {
        case "user-not-found":
          return "Email não cadastrado!";
        case "wrong-password":
          return "Senha incorreta!";
        case "invalid-credential":
          return "Verifique seus dados e tente novamente!";
        default:
          return "Erro desconhecido, tente novamente";
      }
    }
  }

  Future<void> signOutUser() async {
    return _firebaseAuth.signOut();
  }
}
