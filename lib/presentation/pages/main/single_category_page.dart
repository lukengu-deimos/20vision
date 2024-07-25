import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:visionapp/core/utils/video_cache_manager.dart';
import 'package:visionapp/core/widgets/container_with_bg.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/usecases/home/posts/fetch_recent_category_posts.dart';
import 'package:visionapp/presentation/blocs/post_bloc.dart';
import 'package:visionapp/presentation/blocs/video_bloc.dart';
import 'package:visionapp/presentation/pages/main/widgets/post_player.dart';
import 'package:visionapp/presentation/pages/main/widgets/top_bar.dart';

class SingleCategoryPage extends StatefulWidget {
  final Category category;
  const SingleCategoryPage({super.key, required this.category});

  @override
  State<SingleCategoryPage> createState() => _SingleCategoryPageState();
}

class _SingleCategoryPageState extends State<SingleCategoryPage> {
  late PageController _pageController;
  int _size = 0;
  late List<Post> posts;

  @override
  void initState() {
    posts = [];
    _pageController = PageController(initialPage: 0);
    context.read<PostBloc>().add(FetchCategoryPosts(widget.category));
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
        if(state is PostInitial) {
          return const Loader();
        }
        if(state is PostsFetched){
          return posts.isNotEmpty ? Scaffold(
            backgroundColor: Colors.black,
            appBar: TopBar(title: widget.category.name,),
            body:  PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return VisibilityDetector(
                  key: Key(posts[index].videoUrl),
                  onVisibilityChanged: (VisibilityInfo info) {
                    if (info.visibleFraction > 0.5) {
                      _preloadVideo(index);
                    }
                  },
                  child: PostPlayer(post: posts[index]),
                );
              },
              onPageChanged: (index) {
                _navigateTo(index);
              },
            ),
          ): Scaffold(
            appBar: TopBar(title: widget.category.name,),
            body: Stack(
              fit: StackFit.expand,
              children: [
              const ContainerWithBg(child: Center(child: Padding(padding:
              EdgeInsets.only(left:20, right:10), child: Text("No videos", style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30)) ,)
              ) ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.9),
                    padding: const EdgeInsets.all(8.0),
                    height: 15,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return const SizedBox();

      },
      listener: (context, state){
        if(state is PostsFetched){
          posts = state.posts;
          _size = state.posts.length;
          _onVideoEnd();
        }

      },
    );
  }

  void _onVideoEnd() {
    final videoBloc = BlocProvider.of<VideoBloc>(context);
    videoBloc.stream.listen((state) {
      if (state is VideoEnded) {
        //_navigateTo(_currentPage);
        var nextPage = _pageController.page!.toInt() == _size - 1 ? 0 : _pageController.page!.toInt() + 1;
        _pageController.page!.toInt() + 1;
        if(nextPage != 0) {
          _navigateTo(nextPage);
        } else {
          if(mounted) {
            context.read<PostBloc>().add(FetchCategoryPosts(widget.category));
          }
        }
      }
    });
  }

  void _preloadVideo(int index) {
    if (index < posts.length) {
      VideoCacheManager().getSingleFile(posts[index].videoUrl);
      CachedVideoPlayerController.network(posts[index].videoUrl).initialize();
    }
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