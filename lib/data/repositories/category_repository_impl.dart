import 'package:fpdart/fpdart.dart';
import 'package:visionapp/core/networks/connection_checker.dart';
import 'package:visionapp/data/datasources/local/categoy_local_datasource.dart';
import 'package:visionapp/data/datasources/remote/category_remote_datasource.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/exceptions/failure.dart';
import 'package:visionapp/domain/exceptions/service_exception.dart';
import 'package:visionapp/domain/repostories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {

  final CategoryRemoteDatasource remoteDataSource;
  final CategoryLocalDatasource localDataSource;
  final ConnectionChecker connectionChecker;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectionChecker
  });

  @override
  Future<Either<Failure, List<Category>>> listCategory() async{
    if(! await (connectionChecker.isConnected)){
      return Right(localDataSource.getCategories());
    }
    try {
      final categories = await remoteDataSource.getCategories();
      localDataSource.save(categories);
      return Right(categories);
    }  on ServiceException catch  (e) {
      return Left(Failure(e.message));
    }
  }

}