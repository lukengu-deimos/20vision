import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/constants/form_icon.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/snackbar.dart';
import 'package:visionapp/core/widgets/app_button.dart';
import 'package:visionapp/core/widgets/container_with_bg.dart';
import 'package:visionapp/core/widgets/form_textfield.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/core/widgets/rounded_corner_container.dart';
import 'package:visionapp/presentation/blocs/auth_bloc.dart';
import 'package:visionapp/presentation/pages/auth/journalist_signup_page.dart';
import 'package:visionapp/presentation/pages/auth/register_page.dart';
import 'package:visionapp/presentation/pages/auth/reset_password_page.dart';

import '../main/home_page.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                                  text: 'LOGIN OR ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: 'REGISTER',
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
                                            label: 'Username',
                                            prefixIcon: FormIcon.user,
                                            controller: _usernameController,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your username';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 15),
                                          FormTextField(
                                            label: 'Password',
                                            controller: _passwordController,
                                            prefixIcon: FormIcon.lock,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _isPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isPasswordVisible =
                                                      !_isPasswordVisible;
                                                });
                                              },
                                            ),
                                            obscureText: !_isPasswordVisible,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter your password';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 15),
                                          AppButton(
                                            backgroundColor: Colors.white,
                                            color: AppPalette.red,
                                            title: 'LOGIN',
                                            onPressed: () {
                                              SystemSound.play(
                                                  SystemSoundType.click);
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context.read<AuthBloc>().add(
                                                    AuthUserSignIn(
                                                        username:
                                                            _usernameController
                                                                .text,
                                                        password:
                                                            _passwordController
                                                                .text));
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 25),
                                          AppButton(
                                              onPressed: () {
                                                SystemSound.play(
                                                    SystemSoundType.click);
                                                Navigator.push(context,
                                                    RegisterPage.route());
                                              },
                                              backgroundColor: AppPalette.clear,
                                              color: Colors.white,
                                              title: "REGISTER AN ACCOUNT"),
                                          const SizedBox(height: 5),
                                          InkWell(
                                            onTap: () {
                                              SystemSound.play(
                                                  SystemSoundType.click);
                                              Navigator.push(context,
                                                  ResetPasswordPage.route());
                                            },
                                            child: RichText(
                                                text: const TextSpan(
                                              text: 'Forgot your password? ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              children: [
                                                TextSpan(
                                                  text: 'Please reset it here',
                                                  style: TextStyle(
                                                      color: AppPalette.orange,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            )),
                                          ),
                                          const SizedBox(height: 50),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                            Positioned(
                                bottom: 40,
                                right: 0,
                                left: 0,
                                child:InkWell(
                                  onTap: () {
                                    SystemSound.play(SystemSoundType.click);
                                    Navigator.push(context, JournalistSignupPage.route());
                                  },
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Journalist? Click here to sign up",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppPalette.orange,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ),
                                ))
                          ],
                        ));
                  },
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      showErrorSnackBar(context, state.message);
                    }
                    if (state is AuthSuccess) {
                      Navigator.pushAndRemoveUntil(
                          context, HomePage.route(), (route) => false);
                    }
                  },
                )))
      ],
    )));
  }
}
