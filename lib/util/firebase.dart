import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lms/model/book.dart';

class FireBase {
  final databaseReference = Firestore.instance;
  final storage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String errorMessage;

  Future<bool> checkdata(title) {
    return databaseReference
        .collection("books")
        .getDocuments()
        .then((value) async {
      return value.documents.any((element) => element.documentID == title);
    });
  }

  Future<StorageTaskSnapshot> getImagesnap(String title, image) async {
    return await storage
        .ref()
        .child("images")
        .child(title)
        .putFile(image)
        .onComplete;
  }

  Future signIn(String email, String password) async {
    FirebaseUser user;
    errorMessage = "";
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
      print("Firebase user: ${user.email}");
    } catch (error) {
      print(error.code);
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage.isNotEmpty) {
      return errorMessage;
    }
    return user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future signUp(String email, String password) async {
    FirebaseUser user;
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } catch (e) {
      return e;
    }
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser()
      ..reload();
    return user.isEmailVerified;
  }

  Future<void> delete(String title) async {
    await storage.ref().child("images").child(title).delete();
    await storage.ref().child("pdf").child(title).delete();
    await databaseReference.collection("books").document(title).delete();
    return;
  }

  Future<StorageTaskSnapshot> setPdf(String title, File pdf) async {
    return await storage
        .ref()
        .child("pdf")
        .child(title)
        .putFile(pdf)
        .onComplete;
  }

  Future<void> updateData(Book book) async {
    return await databaseReference
        .collection("books")
        .document(book.getTitle.toLowerCase())
        .setData(book.data(), merge: true);
  }

  Future<void> addUserData(Map user, FirebaseUser firebaseUser) async {
    return await databaseReference
        .collection("users")
        .document(firebaseUser.uid)
        .setData(user, merge: true);
  }

  Future<void> updateUser(String id) async {
    print(id);
    await databaseReference
        .collection("users")
        .document(id)
        .setData({"id": id}, merge: true);
  }

  Future addClgStaff(String id) async {
    var list = [id];
    return await databaseReference
        .collection("member")
        .document("college")
        .updateData({"id": FieldValue.arrayUnion(list)});
  }

  Future removeMember(String id) async {
    var list = [id];
    return await databaseReference
        .collection("member")
        .document("college")
        .updateData({"id": FieldValue.arrayRemove(list)});
  }

  Future<bool> clgStaff(id) async {
    return databaseReference
        .collection("member")
        .document("college")
        .get()
        .then((value) async {
      return value.data["id"].contains(id);
    });
  }

  signInOtp(AuthCredential authCreds) async {
    return await FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(String smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    return signInOtp(authCreds);
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /*  searchByName(String searchField) {
    databaseReference
        .collection('books')
        .startAt([searchField])
        .endAt([searchField + '\uf8ff'])
        .getDocuments()
        .then((snapshot) {
          return snapshot.documents;
        });
  } */
/* 
    return Firestore.instance
        .collection('books')
        .where('title',
            isEqualTo: searchField.substring(0, 1))
        .getDocuments(); */

  /* Future<DocumentSnapshot> search() async {
    databaseReference
        .collection('books')
        .orderBy('your-document')
        .startAt([searchkey])
        .endAt([searchkey + '\uf8ff'])
        .getDocuments()
        .then((snapshot) {
          return snapshot.documents;
        });
  } */

  Future<DocumentSnapshot> getUserData(String userid) async {
    return await databaseReference.collection("users").document(userid).get();
  }
}
