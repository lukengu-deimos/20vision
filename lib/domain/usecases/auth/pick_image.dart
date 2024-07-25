import 'dart:convert';
import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/usecases/usecase.dart';
class PickImage implements UseCase<File?, PickImageParams> {
  @override
  Future<Either<Failure, File>> call(PickImageParams params) async {
    final pickedFile = await ImagePicker().pickImage(source: params.imageSource);

    if (pickedFile != null) {
      return Right(File(pickedFile.path));
    }
    return Left(Failure('No image selected'));
  }

}

class PickImageParams {
  final ImageSource imageSource;
  PickImageParams(this.imageSource);
}