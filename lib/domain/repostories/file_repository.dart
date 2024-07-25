import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/exceptions/failure.dart';

abstract interface class FileRepository {

  Future<Either<Failure, String>> upload({required File file, required String
  path});

}