import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easacc_task/common_widgets/platform_alert_dialog.dart';
import 'package:easacc_task/data/models/My_App_User_Model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
abstract class AuthService {
  String currentUserId();
  Future<MyAppUser> currentUser();
  Future<MyAppUser> signInWithEmailAndPassword(String email, String password);
  Future<MyAppUser> createUserWithEmailAndPassword(MyAppUser user);
  Future<void> sendPasswordResetEmail(String email);
  Future<MyAppUser> signInWithGoogle();
  Future<MyAppUser> signInWithFacebook();
  Future<void> signOut();
  Stream<MyAppUser> get onAuthStateChanged;
  void dispose();
}

class Auth implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MyAppUser _userFromFirebase(User user) {
    print('gettineg user from fir    ,,,,' + user.email);
    if (user == null) {
      return null;
    }

    return MyAppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Future<MyAppUser> createUserWithEmailAndPassword(MyAppUser user) async {
    final UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: user.email, password: user.password);
    savaUserToDataBase(user);
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<MyAppUser> currentUser() async {
    MyAppUser currentUserData;
    DocumentReference user =
        FirebaseFirestore.instance.doc('/users/${currentUserId()}');
    await user.get().then((sp) {
      currentUserData = new MyAppUser(
          displayName: sp.get('displayName').toString(),
          email: sp.get('email').toString(),
          photoUrl: sp.get('photoUrl').toString(),
          uid: currentUserId());
    });

    print(currentUserData.displayName + '<<<<<');

    return currentUserData;
  }

  String currentUserId() {
    print(_firebaseAuth.currentUser.uid + ' id auth');
    return _firebaseAuth.currentUser.uid;
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Stream<MyAppUser> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(_userFromFirebase);

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<MyAppUser> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential userCredential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<MyAppUser> signInWithFacebook() async {
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final authResult = await _firebaseAuth.signInWithCredential(
          FacebookAuthProvider.credential(
            result.accessToken.token,
          ),
        );
        return _userFromFirebase(authResult.user);

        break;
      case FacebookLoginStatus.cancelledByUser:
        PlatformAlertDialog(
          content: 'Login cancelled by the user.',
          defaultActionText: 'ok',
          cancelActionText: 'cancle',
          title: 'cancelled',
        );
        break;
      case FacebookLoginStatus.error:
        PlatformAlertDialog(
            defaultActionText: 'ok',
            cancelActionText: 'cancle',
            content: 'Something went wrong with the login process.\n'
                'Here\'s the error Facebook gave us: ${result.errorMessage}');
        print(result.errorMessage + '>>>>>>>>>');
        break;
    }
  }

  @override
  Future<MyAppUser> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        MyAppUser myAppUser = new MyAppUser(
            displayName: userCredential.user.displayName,
            photoUrl: userCredential.user.photoURL,
            email: userCredential.user.email,
            uid: userCredential.user.uid);

        savaUserToDataBase(myAppUser);
        return _userFromFirebase(userCredential.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }

  void savaUserToDataBase(MyAppUser user) {
    print(user.displayName + ' dn');
    DocumentReference Users =
        FirebaseFirestore.instance.doc('users/${currentUserId()}');
    Users.set({
      'uid': currentUserId(),
      'displayName': user.displayName,
      'email': user.email,
      'photoUrl': user.photoUrl
    });
  }
}
