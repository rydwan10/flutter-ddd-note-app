import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:note_app_ddd/domain/auth/auth_failure.dart';
import 'package:note_app_ddd/domain/auth/user.dart';
import 'package:note_app_ddd/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  Future<Option<User>> getSignedInUser();

  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    @required required EmailAddress emailAddress,
    @required required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    @required required EmailAddress emailAddress,
    @required required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();

  Future<void> signOut();
}
