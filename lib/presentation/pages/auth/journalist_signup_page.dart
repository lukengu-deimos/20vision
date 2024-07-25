import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionapp/core/constants/constants.dart';
import 'package:visionapp/core/constants/form_icon.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/asset_sound.dart';
import 'package:visionapp/core/utils/phone_utils.dart';
import 'package:visionapp/core/utils/snackbar.dart';
import 'package:visionapp/core/utils/validation_utils.dart';
import 'package:visionapp/core/widgets/app_button.dart';
import 'package:visionapp/core/widgets/app_top_bar.dart';
import 'package:visionapp/core/widgets/attachment_button.dart';
import 'package:visionapp/core/widgets/container_with_bg.dart';
import 'package:visionapp/core/widgets/empty_attachment_button.dart';
import 'package:visionapp/core/widgets/form_textfield.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/core/widgets/rounded_corner_container.dart';
import 'package:visionapp/domain/enums/user_role.dart';
import 'package:visionapp/presentation/blocs/auth_bloc.dart';
import 'package:visionapp/presentation/pages/auth/login_page.dart';


class JournalistSignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const JournalistSignupPage());
  const JournalistSignupPage({super.key});

  @override
  State<JournalistSignupPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<JournalistSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  late File ?profileImage;

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
        return  Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
                image: Image.asset
                  ("assets/images/ic_awesome-user-alt.png", fit: BoxFit.contain).image
            ),
          ),
        );
      },
  );


  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _emailAddressController.dispose();

  }
  @override
  void initState() {
    profileImage = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Scaffold(
      appBar: const AppTopBar(),
      body: ContainerWithBg(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  <Widget> [
            const Image(image: AssetImage('assets/images/logo.png')),
            const SizedBox(height: 10),
            Expanded(child: RoundedCornerContainer(
                height: size.height * 0.7,
                child: BlocConsumer<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if(state is AuthLoading) {
                      return const Loader(message: 'Please wait while '
                          'processing',);
                    }
                    if(state is AuthNewsPublisherRegistered) {
                      print("I am reaching here");
                      AssetSound.playSound(AssetSoundType.success).then((_){});

                      final welcomeMessage = kNewsPublisherRegisterMessage
                          .replaceAll("%s", state.user!.fullname!);

                      return Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text( welcomeMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                          ),

                        ),
                      );
                    }
                    return Padding(padding: const EdgeInsets.all(0),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 60),
                            RichText(
                                text: const TextSpan(
                                  text: 'JOURNALIST ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: 'REGISTRATION',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                )
                            ),
                            const SizedBox(height: 15),
                            Expanded(child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SizedBox(
                                    height: size.height * 0.7,
                                    child:  Padding(padding: const EdgeInsets.only(left: 54, right:
                                    54, top:20), child:
                                    Form(
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
                                          const SizedBox(height: 15),
                                          FormTextField(
                                            label: 'Email Address',
                                            controller: _emailAddressController,
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
                                          const SizedBox(height: 15),
                                          FormTextField(
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
                                          const SizedBox(height: 15),
                                          AppButton(
                                            backgroundColor: AppPalette.iconColor,
                                            color: Colors.white,
                                            title: 'REGISTER',
                                            onPressed: () {
                                              SystemSound.play(SystemSoundType.click);
                                              if (_formKey.currentState!.validate()) {
                                                if (profileImage == null) {
                                                  showErrorSnackBar(context, 'Please select a profile picture');
                                                } else {
                                                  context.read<AuthBloc>().add(
                                                      AuthSignUp(
                                                          fullname: _fullNameController.text,
                                                          username: _usernameController.text,
                                                          mobileNumber: _phoneNumberController.text,
                                                          password: _passwordController.text,
                                                          emailAddress: _emailAddressController.text,
                                                          bio: _bioController
                                                              .text,
                                                          role: UserRole.newsPublisher.value,
                                                          profilePic: profileImage,
                                                          active: false
                                                      )
                                                  );
                                                }

                                              }
                                            },

                                          ),
                                          const SizedBox(height: 25),
                                          InkWell(
                                            onTap: () {

                                            },
                                            child: RichText(
                                                text: const TextSpan(
                                                  text: 'By registering you agree to the App ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.normal),
                                                  children: [
                                                    TextSpan(
                                                      text: 'terms & conditions',
                                                      style: TextStyle(
                                                          color: AppPalette.orange,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                            ),

                                          ),


                                        ],
                                      ),
                                    ),
                                    )
                                )
                            ))

                          ],
                        ));
                  },
                  listener: (context, state){
                    if(state is AuthFailure){
                      showErrorSnackBar(context, state.message);
                    }
                    if(state is AuthNewsPublisherRegistered){
                      Future.delayed(const Duration(seconds: 12), () {
                        Navigator.pushReplacement(context, LoginPage.route());
                      });
                    }
                  },
                )
            ),
            )

          ],
        )
      )
    );
  }
}