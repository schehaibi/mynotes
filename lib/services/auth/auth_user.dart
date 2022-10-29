import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

//immutable that mean that this class will not be changeble after build
@immutable
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});
  factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVerified: user.emailVerified);
}
