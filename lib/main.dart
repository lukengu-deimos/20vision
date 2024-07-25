import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/core/utils/notification_utils.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/entities/comment.dart';
import 'package:visionapp/domain/entities/notification.dart' as Notification;
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/features/services/video_post_cache.dart';
import 'package:visionapp/init_dependencies.dart';
import 'package:visionapp/presentation/blocs/auth_bloc.dart';
import 'package:visionapp/presentation/blocs/category_bloc.dart';
import 'package:visionapp/presentation/blocs/comment_bloc.dart';
import 'package:visionapp/presentation/blocs/metric_bloc.dart';
import 'package:visionapp/presentation/blocs/video_bloc.dart';
import 'package:visionapp/presentation/pages/auth/login_page.dart';
import 'package:visionapp/presentation/pages/main/home_page.dart';
import 'package:hive/hive.dart';

import 'core/theme/theme.dart';
import 'presentation/blocs/alert_bloc.dart';
import 'presentation/blocs/post_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeNotifications();

  //Hive
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(CommentAdapter());
  Hive.registerAdapter(Notification.NotificationAdapter());
  await Hive.openBox<Post>('posts');
  await Hive.openBox<Category>('categories');
  await Hive.openBox<Comment>('comments');
  await Hive.openBox<Notification.Notification>('notifications');
  initDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<PostBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<VideoBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<MetricBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<CategoryBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<CommentBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AlertBloc>(),
      ),
    ],
    child: const VisionApp(),
  ));
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class VisionApp extends StatefulWidget {
  const VisionApp({super.key});
  @override
  State<VisionApp> createState() => _VisionAppState();
}


class _VisionAppState extends State<VisionApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    context.read<AuthBloc>().add(AuthUserIsLoggedIn());
    VideoPostCache().networkCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: '20Vision',
      theme: AppTheme.lightTheme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserIsLoggedIn;
        },
        builder: (context, isLoggedIn) {
          print("state is $isLoggedIn");
          if (isLoggedIn) {
            return const HomePage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}




