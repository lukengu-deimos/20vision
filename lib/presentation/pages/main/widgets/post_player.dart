import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/asset_sound.dart';
import 'package:visionapp/core/utils/video_cache_manager.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/domain/entities/metric_count.dart';
import 'package:visionapp/domain/entities/post.dart';
import 'package:visionapp/domain/enums/metric_type.dart';
import 'package:visionapp/presentation/blocs/metric_bloc.dart';
import 'package:visionapp/presentation/blocs/video_bloc.dart';
import 'package:visionapp/presentation/pages/main/comment_page.dart';



class PostPlayer extends StatefulWidget {
  final Post post;
  final  bool displayCategory;

  const PostPlayer({super.key, required this.post, this.displayCategory = true});

  @override
  State<PostPlayer> createState() => _PostPlayerState();
}

class _PostPlayerState extends State<PostPlayer> {
  CachedVideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  late Map<String, int> _metrics;

  @override
  void initState() {
    super.initState();
    _metricListener();
    _initializeVideoPlayerFuture = _initializeVideoPlayer();
    _initializeMetrics();
    _registerViews();
  }

  Future<void> _initializeVideoPlayer() async {
    //print("la bas");


    var fetchedFile = await VideoCacheManager().getSingleFile(widget.post
        .videoUrl);

    print(fetchedFile);

    _controller = CachedVideoPlayerController.file(fetchedFile)
      ..initialize().then((_) {
        setState(() {});
        _controller!.play();
        _controller!.addListener(_videoListener);
      });
  }

  void _metricListener() {
    context.read<MetricBloc>().add(GetPostMetric(widget.post.id));
  }

  void _videoListener() {
    if (_controller!.value.position == _controller!.value.duration) {
      context.read<VideoBloc>().add(VideoEndNotify());
    }
  }

  void _initializeMetrics() {
    _metrics = {};
    context.read<MetricBloc>().add(BindMetricReading());

  }
  _registerViews() {
    if(mounted) {
      final user = (context.read<AppUserCubit>().state as AppUserIsLoggedIn).user;
      context.read<MetricBloc>().add(AddMetricEvent(user.id!, widget.post.id,
          MetricType.views, ""));
    }
  }

  @override
  void dispose() {
    _controller!.removeListener(_videoListener);
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _buildScaffold(size);
        } else {
          return const Loader(color: AppPalette.primaryBlue, message: "Initializing"
              " videos...");
        }
      },
    );
  }

  Widget _buildScaffold(Size size) {
    return BlocListener<MetricBloc, MetricState>(
      listener: (context, state) {
        if (state is MetricReceived) {
          _updateMetrics(state.metrics, state.shouldNotify);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildVideoPlayer(),
          if (_controller!.value.isInitialized) ...[
            _buildCommentBox(),
            _buildTransparencyOverlay(size),
            _buildProfilePicture(),
            _buildMetrics(),
            if(widget.displayCategory) _buildCategories(),
          ]
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return _controller!.value.isInitialized
        ?AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CachedVideoPlayer(_controller!),
    ) : const Loader(color: AppPalette.primaryBlue,);
  }


  Widget _buildCommentBox() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black.withOpacity(0.9),
        padding: const EdgeInsets.all(8.0),
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.post.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildTransparencyOverlay(Size size) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black.withOpacity(0.2),
        padding: const EdgeInsets.all(8.0),
        height: size.height,
        child: const SizedBox(),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return widget.post.profilePic != null
        ? Positioned(
            bottom: 85,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(widget.post.profilePic!),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "@${widget.post.username}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _buildMetrics() {
    return Positioned(
      bottom: 95,
      right: 0,
      child: Container(
        width: 60,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
                onTap: () {
                  SystemSound.play(SystemSoundType.click);
                  final int userId =
                      (context.read<AppUserCubit>().state as AppUserIsLoggedIn)
                          .user
                          .id!!;
                  context.read<MetricBloc>().add(PostMetric({
                        'type': MetricType.like.value,
                        'postId': widget.post.id,
                        'userId': userId,
                        'value': ''
                      }));
                },
                child:
                    const Image(image: AssetImage('assets/images/like.png'))),
            const SizedBox(height: 3),
            _buildMetricText(MetricType.like.value),
            InkWell(
                onTap: () {
                  SystemSound.play(SystemSoundType.click);
                  final int userId =
                      (context.read<AppUserCubit>().state as AppUserIsLoggedIn)
                          .user
                          .id!!;
                  context.read<MetricBloc>().add(PostMetric({
                        'type': MetricType.dislike.value,
                        'postId': widget.post.id,
                        'userId': userId,
                        'value': ''
                      }));
                },
                child: const Image(
                    image: AssetImage('assets/images/dislike.png'))),
            const SizedBox(height: 3),
            _buildMetricText(MetricType.dislike.value),
            InkWell(onTap:(){
              SystemSound.play(SystemSoundType.click);
              _openCommentBox(context);
            }, child: const Image(image: AssetImage('assets/images/comment.png'))),
            const SizedBox(height: 3),
            _buildMetricText(MetricType.comment.value),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricText(String metricType) {
    return _metrics.containsKey(metricType)
        ? Center(
            child: Text(
              _metrics[metricType].toString(),
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          )
        : const SizedBox();
  }

  Future<void> _openCommentBox(BuildContext context) async {
    await Future.delayed(Duration.zero);
    if(context.mounted) {
      _controller!.pause();
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return  FractionallySizedBox(
              heightFactor: 0.6,
              child: CommentPage(postId: widget.post.id,),
            );
          }).whenComplete(() {
           _metricListener();
           _controller!.play();
      });
    }
  }

  _updateMetrics(List<MetricCount> metrics, bool shouldNotify) {
    for (var metric in metrics) {
      setState(() {
        _metrics[metric.type] = metric.count;
        if (shouldNotify) {
          _playNotificationOnUpdate(
              MetricTypeExtension.fromString(metric.type));
        }
      });
    }
  }

  _playNotificationOnUpdate(MetricType metricType) {
    switch (metricType) {
      case MetricType.like:
        AssetSound.playSound(AssetSoundType.liked);
        break;
      case MetricType.dislike:
        AssetSound.playSound(AssetSoundType.disliked);
        break;
      case MetricType.comment:
        AssetSound.playSound(AssetSoundType.messageReceived);
      case MetricType.views:
        AssetSound.playSound(AssetSoundType.messageReceived);
        break;
    }
  }

  Widget _buildCategories() {
    return Positioned(
      top: 44,
      left: 0,
      right: 0,
      child: Container(
        color: AppPalette.transparent,
        padding: const EdgeInsets.all(8.0),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.post.categories.map((category) {
            return Padding(
              padding: const EdgeInsets.all(2),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppPalette.darkBlue.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
