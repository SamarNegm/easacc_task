import 'package:flutter/cupertino.dart';

@immutable
class MyAppUser {
  const MyAppUser(
      {this.uid = '',
      this.email = '',
      this.photoUrl = '',
      this.displayName = '',
      this.password = ''});
  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;
  final String password;
  MyAppUser copyWith(
      {String email,
      final String photoUrl,
      final String displayName,
      final String password}) {
    return MyAppUser(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      password: password ?? this.password,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
