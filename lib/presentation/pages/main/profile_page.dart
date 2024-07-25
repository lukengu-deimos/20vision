import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionapp/core/constants/form_icon.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/phone_utils.dart';
import 'package:visionapp/core/utils/snackbar.dart';
import 'package:visionapp/core/utils/validation_utils.dart';
import 'package:visionapp/core/widgets/app_button.dart';
import 'package:visionapp/core/widgets/attachment_button.dart';
import 'package:visionapp/core/widgets/container_with_bg.dart';
import 'package:visionapp/core/widgets/empty_attachment_button.dart';
import 'package:visionapp/core/widgets/form_textfield.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/data/models/user_model.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/enums/user_role.dart';
import 'package:visionapp/presentation/blocs/auth_bloc.dart';
import 'package:visionapp/presentation/pages/main/home_page.dart';

class ProfilePage extends StatefulWidget {
  final UserRole role;
  const ProfilePage({super.key, required this.role});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  late File? profileImage;
  late User user;

  BlocBuilder get avatar => BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      if (state is AuthFilePicked) {
        profileImage = state.file;
        return Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
                image: Image.file(state.file, fit: BoxFit.cover).image
            ),
          ),
        );
      }
      if(state is AuthSuccess) {
        return Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
                image: state.user!.profilePic != null ?  Image.network(state
                    .user!.profilePic!, fit: BoxFit
                    .contain)
                    .image : Image.asset
                  ("assets/images/ic_awesome-user-alt.png", fit: BoxFit
                    .contain).image
            ),
          ),
        );
      }
      return  Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
              image:user.profilePic != '' ?  Image.asset
                ("assets/images/ic_awesome-user-alt.png", fit: BoxFit
                  .contain).image: Image.network(user.profilePic!!,fit: BoxFit
                  .contain).image,
          ),
        ),
      );
    },
  );

  @override
  void initState() {
    profileImage = null;
    user = (context.read<AppUserCubit>().state as AppUserIsLoggedIn).user;
    _fullNameController.text = user.fullname ?? '';
    _usernameController.text = user.username ?? '';
    _phoneNumberController.text = user.mobileNumber ?? '';
    _emailAddressController.text = user.emailAddress ?? '';

    if(widget.role == UserRole.newsPublisher) {
      _bioController.text = user.bio ?? '';
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _emailAddressController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        appBar: AppBar(
          title:   RichText(
              text: const TextSpan(
                text: 'PROFILE ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: 'UPDATE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              )
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            ContainerWithBg(
                child: BlocConsumer<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if(state is AuthLoading) {
                      return const Center(child:Loader(message: "Please wait while processing"));
                    }
                    return  Padding(padding: const EdgeInsets.all(20),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(padding: const EdgeInsets.only(left: 20,
                                          right:20),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children:  <Widget>[
                                              InkWell(
                                                onTap:() {
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
                                                                              context.read<AuthBloc>().add(AuthPickFile(ImageSource.camera));


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
                                                                              context.read<AuthBloc>().add(AuthPickFile(ImageSource.gallery));
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


                                                },
                                                child:  avatar,
                                              ),
                                              const SizedBox(width: 20),
                                              const Text('Upload Profile Picture', style:
                                              TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal)
                                              )
                                            ]
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      FormTextField(
                                        label: 'Full Name',
                                        prefixIcon: FormIcon.user,
                                        controller: _fullNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your fullname';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      FormTextField(
                                        label: 'Username',
                                        controller: _usernameController,
                                        prefixIcon: FormIcon.user,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your username';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      FormTextField(
                                        label: 'Phone Number',
                                        controller: _phoneNumberController,
                                        keyboardType: TextInputType.phone,
                                        prefixIcon: FormIcon.phone,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your cellphone number';
                                          }
                                          if(!startsWithAnyCountryCode(value)){
                                            return 'Country code missing(eg:+27)';
                                          }
                                          if(!isValidPhoneNumber(value)){
                                            return 'Please enter a valid cellphone number';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                      FormTextField(
                                        label: 'Email Address',
                                        controller: _emailAddressController,
                                        keyboardType: TextInputType.emailAddress,
                                        prefixIcon: FormIcon.email,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email address';
                                          }

                                          if(!isValidEmail(value)){
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                      ),
                                      widget.role == UserRole.newsPublisher ?
                                      const SizedBox(height: 15) :   const
                                      SizedBox(height: 75),
                                      /* FormTextField(
                                    label: 'Password',
                                    obscureText: true,
                                    controller: _passwordController,
                                    prefixIcon: FormIcon.lock,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if(value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),*/
                                      if(widget.role == UserRole.newsPublisher) FormTextField(
                                        label: 'Experience / Bio',
                                        controller: _bioController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 4,
                                        prefixIcon: FormIcon.fingerPrint,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Experience/Bio';
                                          }
                                          return null;
                                        },
                                      ),
                                      if(widget.role == UserRole.newsPublisher) const
                                      SizedBox(height: 15),
                                      AppButton(
                                        backgroundColor: AppPalette.iconColor,
                                        color: Colors.white,
                                        title: 'UPDATE PROFILE',
                                        onPressed: () {
                                          SystemSound.play(SystemSoundType.click);
                                          if (_formKey.currentState!.validate()) {
                                            if (user.profilePic == '' && profileImage == null) {
                                              showErrorSnackBar(context, 'Please select a profile picture');
                                            } else {
                                              user = (user as UserModel).copyWith(
                                                fullname: _fullNameController.text,
                                                username: _usernameController.text,
                                                mobileNumber: _phoneNumberController.text,
                                                emailAddress: _emailAddressController.text,
                                                bio: _bioController.text,

                                              );
                                              context.read<AuthBloc>().add(AuthUpdateUser(user:user,
                                                  profilePic: profileImage));
                                            }

                                          }
                                        },

                                      ),
                                    ],
                                  ),
                                )
                            ))

                          ],
                        ));
                  },
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      showErrorSnackBar(context, state.message);
                    }
                    if (state is AuthSuccess) {
                      showSuccessSnackBar(context, 'Profile updated successfully');
                    }
                  },
                )
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.9),
                padding: const EdgeInsets.all(8.0),
                height: 25,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Padding(padding: const EdgeInsets.all(20), child: AppButton(
                backgroundColor: AppPalette.red,
                color: Colors.white,
                title: 'LOGOUT',
                onPressed: () {
                  SystemSound.play(SystemSoundType.click);
                  HomePage.logout(context);
                },

              ),),
            )
          ],
        )
        );
  }
}

