import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../core/errors/exceptions.dart';
import '../models/form_data_model.dart';

abstract class FirebaseDataSource {
  Future<void> createUserWithEmailAndPassword(
      String email, String password, String name);
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<bool> isSignedIn();
  User? getCurrentUser();
  Future<String> uploadImage(File imageFile);
  Future<void> createFormData(FormDataModel formData);
  Future<List<FormDataModel>> getFormData();
}

class FirebaseDataSourceImpl implements FirebaseDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseDataSourceImpl(
      {required this.auth, required this.firestore, required this.storage});

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCredential.user?.updateDisplayName(name);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return auth.currentUser != null;
  }

  @override
  User? getCurrentUser() {
    return auth.currentUser;
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw ServerException();
      }
      final storageRef = storage.ref().child(
          'images/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException {
      throw ServerException();
    }
  }

  @override
  Future<void> createFormData(FormDataModel formData) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw ServerException();
      }
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('forms')
          .add(formData.toJson());
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<FormDataModel>> getFormData() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        throw ServerException();
      }
      final querySnapshot = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('forms')
          .get();
      return querySnapshot.docs
          .map((doc) => FormDataModel.fromJson(doc.data()))
          .toList();
    } on FirebaseException {
      rethrow;
    } catch (e) {
      throw ServerException();
    }
  }
}
