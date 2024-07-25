import 'dart:io';

import 'package:fpdart/src/either.dart';
import 'package:visionapp/core/data/base_response.dart';
import 'package:visionapp/data/datasources/remote/auth_remote_datasource.dart';
import 'package:visionapp/data/datasources/remote/file_remote_datasource.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/domain/repostories/auth_repository.dart';
import 'package:visionapp/domain/repostories/file_repository.dart';

class FileRepositoryImpl implements FileRepository {

  final FileRemoteDatasource remoteDataSource;
  FileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> upload({required File file, required String path}) async{
    try {
      final url = await remoteDataSource.upload(file: file, path: path);
      return Right(url);
    } on ServiceException catch(e) {
      return Left(Failure(e.message));
    }
  }
}