import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/repostories/file_repository.dart';
import 'package:visionapp/domain/usecases/usecase.dart';

class UploadFile implements UseCase<String, UploadFileParams> {
  final FileRepository repository;
  UploadFile({required this.repository});

  @override
  Future<Either<Failure, String>> call(UploadFileParams params) async  {
    return  await repository.upload(file: params.file, path: params.path);
  }



}
class UploadFileParams{
  final File file;
  final String path;
  UploadFileParams({required this.file, required this.path});
}