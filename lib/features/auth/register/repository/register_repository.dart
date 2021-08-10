import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as Path;

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
   FirebaseStorage storage = FirebaseStorage.instance;

  void uploadCachedImage(File image) async{
    String fileName = Path.basename(image.path);
    await storage.ref('uploads/${_auth.currentUser!.uid}/$fileName').putFile(image);
    final String imageUrl = await  storage.ref('uploads/${_auth.currentUser!.uid}/$fileName').getDownloadURL();
    _auth.currentUser!.updatePhotoURL(imageUrl);
  }

  Future<File> getImageFile(String url) async{
    return await DefaultCacheManager().getSingleFile(url);
  }

}
