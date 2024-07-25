
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/video_cache_manager.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/presentation/blocs/post_bloc.dart';
import 'package:visionapp/presentation/blocs/video_bloc.dart';
import 'package:visionapp/presentation/pages/main/widgets/post_player.dart';

class RecentPostsPage extends StatefulWidget {
  const RecentPostsPage({super.key});
  @override
  State<RecentPostsPage> createState() => _RecentPostsPageState();
}

class _RecentPostsPageState extends State<RecentPostsPage> {
  late PageController _pageController;
  int _size = 0;
  late List<Post> posts;


  @override
  void initState() {
    posts = [];
    context.read<PostBloc>().add(FetchPosts());
    _pageController = PageController(initialPage: 0);
    super.initState();
  }



  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostBloc, PostState>(
      builder: (context, state) {




        if (state is PostsFetched) {

          return Scaffold(
            backgroundColor: Colors.black,
            body: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostPlayer(post: posts[index]);
              },
              onPageChanged: (index) {
                _navigateTo(index);
              },
            ),
          );
        }
        return const SizedBox();
      },
      listener: (context, state) {
        if (state is PostsFetched) {
          posts = state.posts;
          _size = posts.length;
          _onVideoEnd();
        }
      },
    );
  }

  void _onVideoEnd() {
    final videoBloc = BlocProvider.of<VideoBloc>(context);
    videoBloc.stream.listen((state) {
      if (state is VideoEnded) {
        var nextPage = _pageController.page!.toInt() == _size - 1 ? 0 : _pageController.page!.toInt() + 1;
        _pageController.page!.toInt() + 1;
        if(nextPage != 0) {
          _navigateTo(nextPage);
        } else {
          if(mounted) {
            context.read<PostBloc>().add(FetchPosts());
          }
        }
      }
    });
  }


  void _navigateTo(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeIn,
        );
      }
    });
  }
}