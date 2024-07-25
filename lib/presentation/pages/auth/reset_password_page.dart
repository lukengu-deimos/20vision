import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/constants/form_icon.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/asset_sound.dart';
import 'package:visionapp/core/utils/snackbar.dart';
import 'package:visionapp/core/utils/validation_utils.dart';
import 'package:visionapp/core/widgets/app_button.dart';
import 'package:visionapp/core/widgets/container_with_bg.dart';
import 'package:visionapp/core/widgets/form_textfield.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/core/widgets/rounded_corner_container.dart';
import 'package:visionapp/presentation/blocs/auth_bloc.dart';
import 'package:visionapp/presentation/pages/main/home_page.dart';

import 'login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ResetPasswordPage());

  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPage();
}
class _ResetPasswordPage extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: ContainerWithBg(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 100),
                const Image(image: AssetImage('assets/images/logo.png')),
                const SizedBox(height: 10),
                Expanded(
                    child: RoundedCornerContainer(
                        height: size.height * 0.7,
                        child: BlocConsumer<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const Loader();
                            }
                            if(state is AuthPasswordSuccess){
                              AssetSound.playSound(AssetSoundType.success).then((_){});
                              return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.check_circle, color: Colors.green, size: 50),
                                        const SizedBox(height: 10),
                                        const Text("Please check your mailbox"
                                            " for a reset password link ",
                                            textAlign: TextAlign.center,
                                            style:
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
                                            context.read<AuthBloc>().add
                                              (AuthUserReset());
                                            SystemSound.play(SystemSoundType.click);
                                            Navigator.pushAndRemoveUntil
                                              (context, LoginPage.route(), (route) => false);
                                          },
                                        )
                                      ],
                                    ),

                                  ));
                            }
                            return Padding(
                                padding: const EdgeInsets.all(0),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        const SizedBox(height: 60),
                                        RichText(
                                            text: const TextSpan(
                                              text: 'RESET ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                              children: [
                                                TextSpan(
                                                  text: 'PASSWORD',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                              ],
                                            )),
                                        const SizedBox(height: 20),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 54, right: 54, top: 20),
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                children: <Widget>[
                                                  FormTextField(
                                                    label: 'Email',
                                                    controller: _emailController,
                                                    prefixIcon: FormIcon.email,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter your email address';
                                                      }
                                                      if(!isValidEmail(value)) {
                                                        return 'Please enter a valid email address';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const SizedBox(height: 15),
                                                  AppButton(
                                                    backgroundColor: Colors.white,
                                                    color: AppPalette.red,
                                                    title: 'SEND',
                                                    onPressed: () {
                                                      SystemSound.play(
                                                          SystemSoundType.click);
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        context
                                                            .read<AuthBloc>()
                                                            .add
                                                          (AuthResetPassword
                                                          (emailAddress:
                                                        _emailController.text));
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ],
                                ));
                          },
                          listener: (context, state) {
                            if (state is AuthFailure) {
                              showErrorSnackBar(context, state.message);
                            }
                            if (state is AuthPasswordSuccess) {

                            }
                          },
                        )))
              ],
            )));
  }
  
}
