import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

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

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<Either<String?, String>> uploadImage(File image) async{
      String fileName = Path.basename(image.path);
      try{
        await storage.ref('uploads/${_auth.currentUser!.uid}/$fileName').putFile(image);
        final String imageUrl = await  storage.ref('uploads/${_auth.currentUser!.uid}/$fileName').getDownloadURL();
        _auth.currentUser!.updatePhotoURL(imageUrl);
        return Right("Success");
      } on FirebaseException catch(error){
        return Left(error.message);
      }
  }
}
