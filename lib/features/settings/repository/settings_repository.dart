import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsRepository{
  FirebaseAuth _auth = FirebaseAuth.instance;
    Future<Either<String?, void>> logout() async{
   try{
     var res = await _auth.signOut();
     return Right(res);
   } on FirebaseAuthException catch (error){
     return Left(error.message);
   }
  }
}