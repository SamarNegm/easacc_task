import 'dart:async';
import 'package:easacc_task/common_widgets/platform_exception_alert_dialog.dart';
import 'package:easacc_task/data/models/My_App_User_Model.dart';
import 'package:easacc_task/data/repo/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInBloc {
  final StreamController<bool> _isLoading = new StreamController<bool>();
  final AuthService authService;

  SignInBloc(@required this.authService);
  Stream<bool> get isLoadingStram => _isLoading.stream;
  void dipose() {
    _isLoading.close();
  }

  void _setIsLoading(bool isLoading) => _isLoading.add(isLoading);
  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<MyAppUser> _signIn(
      Future<MyAppUser> Function() signInMethod, BuildContext context) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
        _setIsLoading(false);
      }
      rethrow;
    }
  }

  Future<MyAppUser> signInWithGoogle(BuildContext context) async =>
      await _signIn(authService.signInWithGoogle, context);
  Future<MyAppUser> signInWithFacebook(BuildContext context) async =>
      await _signIn(authService.signInWithFacebook, context);
}
