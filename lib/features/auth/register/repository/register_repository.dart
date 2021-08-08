import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterRepository {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Either<String?, UserCredential?>> register(String email, String password, String name) async {
    try{
     UserCredential? credential =  await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((_) async{
        await _auth.currentUser!.updateDisplayName(name);
      });
      return Right(credential);
    }on FirebaseAuthException catch(error){
      return Left(error.message);
    }
  }
}
