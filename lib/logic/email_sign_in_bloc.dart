import 'dart:async';

import 'package:easacc_task/data/models/email_sign_in_model.dart';
import 'package:easacc_task/data/repo/services/auth.dart';
import 'package:flutter/foundation.dart';

class EmailSignInBloc {
  final AuthService auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();
  EmailSignInModel _model = EmailSignInModel();
  EmailSignInBloc({@required this.auth});
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  void dispose() {
    _modelController.close();
  }

  Future<void> submit(bool login) async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (login) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);
  void updateName(String name) => updateWith(name: name);
  void updatePassword(String password) => updateWith(password: password);
  void updateWith({
    String name,
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    // update model
    _model = _model.copyWith(
      name: name,
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    ); // add updated model to _modelController
    _modelController.add(_model);
  }
}
