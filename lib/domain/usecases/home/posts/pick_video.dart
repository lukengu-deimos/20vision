import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class PickVideo implements UseCase<File?, PickImageParams> {
  @override
  Future<Either<Failure, File>> call(PickImageParams params) async {
    final pickedFile = await ImagePicker().pickVideo(source: params.imageSource);

    if (pickedFile != null) {
      return Right(File(pickedFile.path));
    }
    return Left(Failure('No video selected'));
  }

}

class PickImageParams {
  final ImageSource imageSource;
  PickImageParams(this.imageSource);
}