import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/core/networks/connection_checker.dart';
import 'package:visionapp/core/utils/shared_prefs.dart';
import 'package:visionapp/data/datasources/local/alert_local_data_source.dart';
import 'package:visionapp/data/datasources/local/auth_local_data_source.dart';
import 'package:visionapp/data/datasources/local/categoy_local_datasource.dart';
import 'package:visionapp/data/datasources/local/comment_local_datasource.dart';
import 'package:visionapp/data/datasources/remote/alert_remote_data_source.dart';
import 'package:visionapp/data/datasources/remote/auth_remote_datasource.dart';
import 'package:visionapp/data/datasources/remote/category_remote_datasource.dart';
import 'package:visionapp/data/datasources/remote/comment_remote_datasource.dart';
import 'package:visionapp/data/datasources/remote/metric_remote_data_source.dart';
import 'package:visionapp/data/datasources/remote/post_remote_datasource.dart';
import 'package:visionapp/data/repositories/alert_repository_impl.dart';
import 'package:visionapp/data/repositories/auth_repository_impl.dart';
import 'package:visionapp/data/repositories/category_repository_impl.dart';
import 'package:visionapp/data/repositories/comment_repository_impl.dart';
import 'package:visionapp/data/repositories/metric_repository_impl.dart';
import 'package:visionapp/data/repositories/post_repository_impl.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/entities/comment.dart';
import 'package:visionapp/domain/repostories/alert_repository.dart';
import 'package:visionapp/domain/repostories/auth_repository.dart';
import 'package:visionapp/domain/repostories/category_repository.dart';
import 'package:visionapp/domain/repostories/comment_repository.dart';
import 'package:visionapp/domain/repostories/metric_repository.dart';
import 'package:visionapp/domain/repostories/post_repository.dart';
import 'package:visionapp/domain/usecases/alert/delete_alert.dart';
import 'package:visionapp/domain/usecases/alert/get_alerts.dart';
import 'package:visionapp/domain/usecases/alert/update_alerts.dart';
import 'package:visionapp/domain/usecases/auth/current_user.dart';
import 'package:visionapp/domain/usecases/auth/pick_image.dart';
import 'package:visionapp/domain/usecases/auth/update_profile.dart';
import 'package:visionapp/domain/usecases/auth/user_sigin.dart';
import 'package:visionapp/domain/usecases/auth/user_signup.dart';
import 'package:visionapp/domain/usecases/home/category/list_category.dart';
import 'package:visionapp/domain/usecases/home/comments/post_comments.dart';
import 'package:visionapp/domain/usecases/home/posts/create_post.dart';
import 'package:visionapp/domain/usecases/home/posts/fetch_recent_category_posts.dart';
import 'package:visionapp/domain/usecases/home/posts/fetch_recent_posts.dart';
import 'package:visionapp/domain/usecases/home/posts/get_metrics_for_post.dart';
import 'package:visionapp/domain/usecases/metrics/add_metric.dart';
import 'package:visionapp/features/services/amqp_client.dart';
import 'package:visionapp/features/services/api_client_service.dart';
import 'package:visionapp/features/services/http_service.dart';
import 'package:visionapp/features/services/notification_service.dart';
import 'package:visionapp/features/services/vision_api.dart';
import 'package:visionapp/presentation/blocs/auth_bloc.dart';
import 'package:visionapp/presentation/blocs/category_bloc.dart';
import 'package:visionapp/presentation/blocs/comment_bloc.dart';
import 'package:visionapp/presentation/blocs/metric_bloc.dart';
import 'package:visionapp/presentation/blocs/post_bloc.dart';
import 'package:visionapp/presentation/blocs/video_bloc.dart';

import 'data/datasources/local/post_local_datasource.dart';
import 'domain/entities/post.dart';
import 'domain/entities/notification.dart' as Notification;
import 'domain/usecases/auth/reset_password.dart';
import 'domain/usecases/home/posts/pick_video.dart';
import 'presentation/blocs/alert_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  //Core Dependencies
  serviceLocator
    ..registerLazySingleton(() => SharedPrefs())
    ..registerLazySingleton(() => AppUserCubit())
    ..registerLazySingleton(() => AmqpClient())
    ..registerFactory<HttpService>(() => HttpServiceImpl())
    ..registerFactory<ApiClientService>(() => VisionApi(serviceLocator()))
    ..registerFactory(() => InternetConnectionCheckerPlus())
    ..registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(serviceLocator()))
    ..registerFactory<NotificationService>(() => NotificationServiceImpl())
  //Hive
    ..registerLazySingleton(() => Hive.box<Post>('posts'))
    ..registerLazySingleton(() => Hive.box<Category>('categories'))
    ..registerLazySingleton(() => Hive.box<Comment>('comments'))
    ..registerLazySingleton(() => Hive.box<Notification.Notification>
      ('notifications'));
  
  //Features Dependencies
  _initAuthDependencies();
  _initPostDependencies();
  _initCategoryDependencies();
  _initCommentDependencies();
  _initAlertDependencies();
}

void _initAuthDependencies() {
  //DataSource
  serviceLocator
     ..registerFactory<AuthRemoteDatasource>(() => AuthRemoteDataSourceImpl(
         service: serviceLocator(),
        notificationService: serviceLocator())
     )
     ..registerFactory<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(
         sharedPrefs: serviceLocator())
     )
   // Repository
      ..registerFactory<AuthRepository>(() => AuthRepositoryImpl (
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          connectionChecker: serviceLocator())
      )


   //Auth

   //Use Cases
     ..registerFactory(() => UserSignIn(serviceLocator()))
     ..registerFactory(() => PickImage())
     ..registerFactory(() => UserSignUp(serviceLocator()))
     ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UpdateProfile(repository: serviceLocator()))
    ..registerFactory(() => ResetPassword(serviceLocator()))
   // Bloc
  ..registerLazySingleton(
          () => AuthBloc(
              userSignIn: serviceLocator(),
              pickImage: serviceLocator(),
              userSignUp: serviceLocator(),
              currentUser: serviceLocator(),
              appUserCubit: serviceLocator(),
              updateProfile: serviceLocator(),
              resetPassword: serviceLocator()
          )
  );


}

void _initPostDependencies() {
  //DataSource
  serviceLocator..registerFactory<PostRemoteDatasource>(() => PostRemoteDatasourceImpl(service: serviceLocator()))
      ..registerFactory<PostLocalDatasource>(() => PostLocalDatasourceImpl(serviceLocator()))
    ..registerFactory<MetricRemoteDataSource>(() => MetricRemoteDataSourceImpl(service: serviceLocator()) )
  // Repository
      ..registerFactory<PostRepository>(() => PostRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          connectionChecker: serviceLocator()
      ))
    ..registerFactory<MetricRepository>(() => MetricRepositoryImpl(
        remoteDataSource: serviceLocator()
    ))
  //Use Cases
      ..registerFactory(() => FetchRecentPosts(serviceLocator()))
      ..registerFactory(() => GetMetricsForPost(serviceLocator()))
      ..registerFactory(() => FetchRecentCategoryPosts(serviceLocator()))
      ..registerFactory(() => PickVideo())
      ..registerFactory(() => CreatePost(serviceLocator()))
      ..registerFactory(() => AddMetric(serviceLocator()))
  // Bloc
      ..registerLazySingleton(() => PostBloc(
          fetchRecentPosts: serviceLocator(),
          fetchRecentCategoryPosts: serviceLocator(),
          pickVideo: serviceLocator(),
          createPost: serviceLocator()

      ))
      ..registerLazySingleton(() => VideoBloc())
      ..registerLazySingleton(() => MetricBloc(amqpClient: serviceLocator(), sharedPrefs:
      serviceLocator(), getMetricsForPost: serviceLocator(),addMetric:
      serviceLocator()));
}

void _initCategoryDependencies() {
  //DataSource
  serviceLocator..registerFactory<CategoryRemoteDatasource>(() =>
      CategoryRemoteDatasourceImpl(service: serviceLocator()))
    ..registerFactory<CategoryLocalDatasource>(() => CategoryLocalDatasourceImpl
      (serviceLocator()))

  // Repository
    ..registerFactory<CategoryRepository>(() => CategoryRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        connectionChecker: serviceLocator()
    ))

  //Use Cases
    ..registerFactory(() => ListCategory(serviceLocator()))
  // Bloc
    ..registerLazySingleton(() => CategoryBloc(
        listCategory: serviceLocator(),
    ));
}

_initCommentDependencies() {
  //DataSource
  serviceLocator..registerFactory<CommentRemoteDataSource>(() =>
      CommentRemoteDataSourceImpl(service: serviceLocator()))
    ..registerFactory<CommentLocalDataSource>(() => CommentLocalDataSourceImpl
      (serviceLocator()))

  // Repository
    ..registerFactory< CommentRepository>(() =>  CommentRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        connectionChecker: serviceLocator()
    ))
  //Use Cases
    ..registerFactory(() => PostComments(serviceLocator()))
    // Bloc
    ..registerLazySingleton(() => CommentBloc(
        postComments: serviceLocator(),
        sharedPrefs: serviceLocator(),
        amqpClient: serviceLocator()
    ));

}
_initAlertDependencies() {
  //DataSource
  serviceLocator..registerFactory<AlertRemoteDataSource>(() =>
      AlertRemoteDataSourceImpl(service: serviceLocator()))
    ..registerFactory<AlertLocalDataSource>(() => AlertLocalDataSourceImpl
      (serviceLocator()))

  // Repository
    ..registerFactory< AlertRepository>(() =>  AlertRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
    ))
  //Use Cases
    ..registerFactory(() => GetAlerts(repository: serviceLocator()))
    ..registerFactory(() => DeleteAlert(serviceLocator()))
    ..registerFactory(() => UpdateAlerts(serviceLocator()))
  // Bloc
    ..registerLazySingleton(() => AlertBloc(
        getchAlerts: serviceLocator(), deleteAlert: serviceLocator(),
      updateAlerts:  serviceLocator()
    ));

}