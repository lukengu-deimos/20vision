import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:visionapp/core/constants/form_icon.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/asset_sound.dart';
import 'package:visionapp/core/utils/snackbar.dart';
import 'package:visionapp/core/widgets/app_button.dart';
import 'package:visionapp/core/widgets/asset_icon.dart';
import 'package:visionapp/core/widgets/attachment_button.dart';
import 'package:visionapp/core/widgets/container_with_bg.dart';
import 'package:visionapp/core/widgets/empty_attachment_button.dart';
import 'package:visionapp/core/widgets/form_textfield.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/domain/entities/category.dart';
import 'package:visionapp/presentation/blocs/auth_bloc.dart';
import 'package:visionapp/presentation/blocs/category_bloc.dart';
import 'package:visionapp/presentation/blocs/post_bloc.dart';
import 'package:visionapp/presentation/pages/main/home_page.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();

}

class _UploadPageState extends State<UploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late List<Category> categories;
  final List<int> selected = [];
  late File? videoFile;
  final int maxDurationInSeconds = 180;
  VideoPlayerController? _controller;


  @override
  void initState() {
    categories = [];
    videoFile = null;
    context.read<CategoryBloc>().add(FetchCategory());
    final bloc = BlocProvider.of<CategoryBloc>(context);
    bloc.stream.listen((state) {
      if (state is CategoryListFetched) {
        setState(() {
          categories = state.categories;
        });
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  RichText(
            text: const TextSpan(
              text: 'UPLOAD ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: 'STORY',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.normal),
                ),
              ],
            )
        )
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ContainerWithBg(child: BlocConsumer<PostBloc, PostState>(
            builder:(context, state) {
              if(state is PostLoading){
                return const  Loader(message: "Uploading...");
              }
              if(state is PostCreated){
                AssetSound.playSound(AssetSoundType.success).then((_){});
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 50),
                        const SizedBox(height: 10),
                        const Text("Story uploaded successfully", style:
                        TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        )),
                        const SizedBox(height: 10),
                        AppButton(
                          backgroundColor: AppPalette.iconColor,
                          color: Colors.white,
                          title: 'OK',
                          onPressed: () {
                            SystemSound.play(SystemSoundType.click);
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => const HomePage(forceLoad: 0,)), (route) => false);
                          },
                        )
                      ],
                    ),

                ));
              }
              return SingleChildScrollView(child:Column(
                children: [
                  IconButton(onPressed: () {
                    SystemSound.play(SystemSoundType.click);
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => Wrap(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left:10, right:10, bottom: 10),
                              child: Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      height: 134,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 15),
                                      decoration: BoxDecoration(
                                        color: AppPalette.primaryBlue,
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child:Wrap(
                                          children: [
                                            AttachmentButton(
                                              name:
                                              "CAMERA",
                                              icon: const Icon(Icons.camera),
                                              onTap: () {
                                                SystemSound.play(SystemSoundType.click);
                                                // profileController.getCoverImageFromCamera();
                                                //pickImage(ImageSource.camera);
                                                context.read<PostBloc>().add
                                                  (PostPickFile(ImageSource
                                                    .camera));


                                                Navigator.pop(context);
                                              },
                                            ),
                                            const EmptyAttachmentButton(),
                                            AttachmentButton(
                                              name:
                                              "GALLERY",
                                              icon: const Icon(Icons.image),
                                              onTap: () {
                                                SystemSound.play(SystemSoundType.click);
                                                //pickImage(ImageSource.gallery);
                                                context.read<PostBloc>().add
                                                  (PostPickFile(ImageSource
                                                    .gallery));
                                                Navigator.pop(context);
                                              },
                                            )
                                          ]
                                      )
                                  ),
                                  AppButton (
                                    onPressed: (){
                                      SystemSound.play(SystemSoundType.click);
                                      Navigator.pop(context);

                                    },
                                    backgroundColor: AppPalette.primaryBlue,
                                    color:AppPalette.white,
                                    title: "CANCEL",
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                    );

                  }, icon: const AssetIcon(assetPath: 'assets'
                      '/images/icon-file-upload.png', size: 90)),
                  const SizedBox(height: 2),
                  Text(videoFile != null ? "File Selected": "No video "
                      "selected" , style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14
                  )),
                  const SizedBox(height: 20),
                  Padding(padding: const EdgeInsets.only(left: 20, right:
                  20, top:20), child:
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FormTextField(
                          label: 'Title',
                          prefixIcon: FormIcon.edit,
                          textInputAction: TextInputAction.next,
                          controller: _titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        FormTextField(
                          label: 'Description',
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.next,
                          maxLines: 4,
                          prefixIcon: FormIcon.editNib,
                          maxLength: 250,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),
                        buildCategoryGrid(categories),
                        const SizedBox(height: 25),
                        AppButton(
                          backgroundColor: AppPalette.iconColor,
                          color: Colors.white,
                          title: 'SUBMIT',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              SystemSound.play(SystemSoundType.click);
                              if(videoFile == null) {
                                showErrorSnackBar(context, 'Please select a video file');
                              } else if(selected.isEmpty) {
                                showErrorSnackBar(context, 'Please select at least one category');
                              } else {
                              context.read<PostBloc>().add(CreatePostEvent(
                                  title: _titleController.text,
                                  body: _descriptionController.text,
                                  categories: selected,
                                  videoFile: videoFile!,
                                  userId: (context
                                      .read<AppUserCubit>()
                                      .state
                                  as AppUserIsLoggedIn).user.id!
                              ));
                            }

                            }
                          },

                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ))
                ],
              ));
            },
            listener: (context,state){
              if(state is PostFilePicked){
                _controller = VideoPlayerController.file(state.file!)
                  ..initialize().then((_) {
                    final duration = _controller!.value.duration;
                      if (duration.inSeconds > maxDurationInSeconds) {
                        showErrorSnackBar(context, 'Video duration should not exceed $maxDurationInSeconds seconds');
                        setState(() {
                          videoFile = null;
                        });


                      } else {
                        setState(() {
                          videoFile = state.file;
                        });
                      }
                  });
              }
              if(state is PostError) {
                showErrorSnackBar(context, state.message);
              }
            },
          )),
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
        ]
      )
    );
  }

  Widget buildCategoryGrid(List<Category> categories) {
    List<Widget> rows = [];
    for (int i = 0; i < categories.length; i += 3) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < 3; j++) {
        if (i + j < categories.length) {
          rowChildren.add(
            Expanded(
              child: InkWell(
                onTap: (){
                  SystemSound.play(SystemSoundType.click);
                  setState(() {
                    if(!selected.contains(categories[i + j].id)) {
                      selected.add(categories[i + j].id);
                    } else {
                      selected.remove(categories[i + j].id);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: selected.contains(categories[i + j].id) ?
                    AppPalette.red : AppPalette.darkBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      categories[i + j].name.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          rowChildren.add(Expanded(child: Container())); // Add an empty container to keep the row structure
        }
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      ));
    }
    return Column(
      children: rows,
    );
  }
}