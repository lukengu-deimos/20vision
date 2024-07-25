import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/constants/form_icon.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/asset_sound.dart';
import 'package:visionapp/core/utils/phone_utils.dart';
import 'package:visionapp/core/utils/snackbar.dart';
import 'package:visionapp/core/utils/validation_utils.dart';
import 'package:visionapp/core/widgets/app_button.dart';
import 'package:visionapp/core/widgets/app_top_bar.dart';
import 'package:visionapp/core/widgets/container_with_bg.dart';
import 'package:visionapp/core/widgets/form_textfield.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/core/widgets/rounded_corner_container.dart';
import 'package:visionapp/domain/enums/user_role.dart';
import 'package:visionapp/presentation/blocs/auth_bloc.dart';
import 'package:visionapp/presentation/pages/main/home_page.dart';


class RegisterPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const RegisterPage());
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();


  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
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
                child: BlocConsumer<AuthBloc,AuthState>(
                  builder: (context,state) {
                    if(state is AuthLoading){
                      return const Loader(message: "Please wait while processing");
                    }
                    return Padding(padding: const EdgeInsets.all(0), child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 60),
                        RichText(
                            text: const TextSpan(
                              text: 'USER ',
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
                        const SizedBox(height: 20),
                        Padding(padding: const EdgeInsets.only(left: 54, right:
                        54, top:20), child:
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
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
                                controller: _passwordController,
                                obscureText: true,
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
                                controller: _emailController,
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
                              const SizedBox(height: 25),
                              AppButton(
                                backgroundColor: AppPalette.iconColor,
                                color: Colors.white,
                                title: 'REGISTER',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    SystemSound.play(SystemSoundType.click);
                                    context.read<AuthBloc>().add(
                                        AuthSignUp(
                                            fullname: _fullNameController.text,
                                            username: _usernameController.text,
                                            mobileNumber: _phoneNumberController.text,
                                            password: _passwordController.text,
                                            emailAddress: _emailController.text,
                                            active: true,
                                            role: UserRole.appUser.value
                                        )
                                    );
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
                        ))
                      ],
                    ));
                  },
                  listener: (context, state){
                    if(state is AuthFailure){
                      showErrorSnackBar(context, state.message);
                    }
                    if(state is AuthSuccess) {
                      context.read<AppUserCubit>().updateUser(state.user);
                      AssetSound.playSound(AssetSoundType.success).then((_){});
                      Navigator.pushAndRemoveUntil(context,HomePage.route(),
                              (route) => false);
                    }
                  },
                )
            ))

          ],
        )
      )
    );
  }
}