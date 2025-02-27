
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseBucket {
  /*This method is complete task of storing medial file to the firebase storage(bucket)
  @param name-filename and path-file path
  @ret future String - Download link
  @Auth-Abhishek Bhosale 
  */
Future<String> uploadFile(String folder, String name, File path) async {
  try {
    Reference reference = FirebaseStorage.instance.ref().child("$folder/$name");
    UploadTask uploadTask = reference.putFile(path);
    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      String downloadUrl = await reference.getDownloadURL();
      return downloadUrl; 
    } else {
      return 'Upload failed'; 
    }
  } catch (e) {
    log("Error uploading file: $e");
    return 'Error: $e'; 
  }
}

}
