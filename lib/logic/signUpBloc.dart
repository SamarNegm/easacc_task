import 'dart:async';
import 'package:easacc_task/common_widgets/platform_exception_alert_dialog.dart';
import 'package:easacc_task/data/models/My_App_User_Model.dart';
import 'package:easacc_task/data/models/signUpModel.dart';
import 'package:easacc_task/data/repo/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class EmailSignUpBloc {
  EmailSignUpBloc({@required this.auth});
  final AuthService auth;
  final StreamController<MyAppUser> _modelController =
      StreamController<MyAppUser>();
  Stream<MyAppUser> get modelStream => _modelController.stream;
  MyAppUser _model = MyAppUser();
  //''''
  final StreamController<SignUpModel> _modelController2 =
      StreamController<SignUpModel>();
  Stream<SignUpModel> get model2Stream => _modelController2.stream;
  SignUpModel _model2 = SignUpModel();
  void dispose() {
    _modelController.close();
    _modelController2.close();
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<MyAppUser> _signIn(
      Future<MyAppUser> Function() signInMethod, BuildContext context) async {
    try {
      _model2 = _model2.copyWith(isLoading: true);
      _modelController2.add(_model2);
      return await signInMethod();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
        _model2 = _model2.copyWith(isLoading: false, access: false);
        _modelController2.add(_model2);
      }
      rethrow;
    }
  }

  Future<MyAppUser> signInWithGoogle(BuildContext context) async =>
      await _signIn(auth.signInWithGoogle, context);
  Future<MyAppUser> signInWithFacebook(BuildContext context) async =>
      await _signIn(auth.signInWithFacebook, context);

  Future<void> submit() async {
    //  updateWith(submitted: true, isLoading: true);
    try {
      print('true');
      _model2 = _model2.copyWith(isLoading: true, access: false);
      _modelController2.add(_model2);
      print(_model2.isLoading);

      await auth.createUserWithEmailAndPassword(_model);
      _model2 = _model2.copyWith(isLoading: true, access: true);
      _modelController2.add(_model2);
    } catch (e) {
      _model2.copyWith(isLoading: false, access: false);
      _modelController2.add(_model2);
      //    updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateName(String name) => updateWith(name: name);
  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void updateWith(
      {String name, String email, String password, String photoUrl}) {
    // update model
    //print(name + ' name ' + _model.displayName.toString());
    _model = _model.copyWith(
        email: email,
        password: password,
        photoUrl: photoUrl,
        displayName: name); // add updated model to _modelController
    _modelController.add(_model);
  }
}
