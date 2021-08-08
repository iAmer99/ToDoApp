import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LoginRepository{
   FirebaseAuth _auth = FirebaseAuth.instance;

   Future<Either<String?, UserCredential>> login(String email, String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return Right(credential);
    } on FirebaseAuthException catch(error){
      return Left(error.message);
    }
  }

  Future<File> getImageFile(String url) async{
     return await DefaultCacheManager().getSingleFile(url);
  }
}