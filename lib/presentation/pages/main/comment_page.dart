import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/asset_sound.dart';
import 'package:visionapp/domain/entities/comment.dart';
import 'package:visionapp/domain/enums/metric_type.dart';
import 'package:visionapp/presentation/blocs/comment_bloc.dart';
import 'package:visionapp/presentation/blocs/metric_bloc.dart';

class CommentPage extends StatefulWidget {
  final int postId;


  const CommentPage({super.key, required this.postId});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _editingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<Comment> comments;
  final FocusNode _focusNode = FocusNode();

  BlocBuilder<CommentBloc, CommentState> get commentCount => BlocBuilder<CommentBloc, CommentState>(
    builder: (context, state) {
      print("fetched state: $state");
      if (state is CommentListFetched) {
        print(state.comments.length);
        return Text(
          "${state.comments.length} Comments",
          style: const TextStyle(
            color: AppPalette.darkBlue,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        );
      }
      return const SizedBox();
    },
  );

  @override
  void initState() {
    comments = [];
    context.read<CommentBloc>().add(FetchComment(postId: widget.postId));
    context.read<CommentBloc>().add(SubscribeToQueue());
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    _focusNode.dispose();
    super.dispose();

  }
  void _handleSubmitted(String value) {
    // Perform any action on submission
    print("Submitted value: $value");
    if (_editingController.text.isNotEmpty) {
      AssetSound.playSound(AssetSoundType.messageSend);
      final int? userId =
          (context.read<AppUserCubit>().state as AppUserIsLoggedIn)
              .user
              .id;
      context.read<MetricBloc>().add(PostMetric({
        'type': MetricType.comment.value,
        'postId': widget.postId,
        'userId': userId,
        'value': value
      }));
      setState(() {
        _editingController.text = "";
      });
    }
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
  }

  void _handleEditingComplete() {
    // Perform any action when editing is complete
    print("Editing complete");
    FocusScope.of(context).unfocus(); // Dismiss the keyboard
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.transparent,
      bottomNavigationBar:Container(
        height: 90,
        decoration: const BoxDecoration(
          color: AppPalette.unselectedBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppPalette.lightGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _editingController,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: _handleEditingComplete,
                    onSubmitted: _handleSubmitted,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Add a comment...",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  color: AppPalette.darkBlue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IconButton(
                    iconSize: 24,
                    disabledColor: Colors.grey,
                    icon: const Icon(
                      Icons.send,
                      color: AppPalette.white,
                    ),
                    onPressed: () {
                      if (_editingController.text.isNotEmpty) {
                        AssetSound.playSound(AssetSoundType.messageSend);
                        final int? userId =
                            (context.read<AppUserCubit>().state as AppUserIsLoggedIn)
                                .user
                                .id;
                        context.read<MetricBloc>().add(PostMetric({
                          'type': MetricType.comment.value,
                          'postId': widget.postId,
                          'userId': userId,
                          'value': _editingController.text
                        }));
                        setState(() {
                          _editingController.text = "";
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppPalette.lightGray.withOpacity(0.4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Reactions",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppPalette.darkBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    const Spacer(flex: 2,),
                    CircleAvatar(
                      radius: 20, // Adjust size as needed
                      backgroundColor: AppPalette.red,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          // Your onPressed function here
                          Navigator.of(context).pop();
                        },
                      ),// Button background color
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppPalette.darkBlue,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Row(
                  children: [
                    commentCount,
                    const SizedBox(width: 10),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppPalette.darkBlue,
                width: double.infinity,
              ),
              Expanded(
                child: BlocListener<CommentBloc, CommentState>(
                  listener: (context, state) {
                    if (state is CommentListFetched) {
                      setState(() {
                        comments = state.comments;
                      });
                      if(state.shouldNotify) {
                        AssetSound.playSound(AssetSoundType.messageReceived);
                        _editingController.text = "";
                      }

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                          _scrollController.position.minScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final Comment comment = comments[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppPalette.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppPalette.darkBlue,
                                    ),
                                    child: Center(
                                      child: comment.profilePic != "" ? CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(comment
                                              .profilePic!)):
                                      Text(
                                        comment.username.substring(0, 1).toUpperCase(),
                                        style: const TextStyle(
                                          color: AppPalette.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.username,
                                          style: const TextStyle(
                                            color: AppPalette.darkBlue,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          comment.value,
                                          style: const TextStyle(
                                            color: AppPalette.darkBlue,
                                            fontSize: 12,
                                          ),
                                          maxLines: null,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
