import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/constants/constants.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/shared_prefs.dart';
import 'package:visionapp/core/utils/video_cache_manager.dart';
import 'package:visionapp/core/widgets/asset_icon.dart';
import 'package:visionapp/domain/entities/user.dart';
import 'package:visionapp/domain/enums/user_role.dart';
import 'package:visionapp/features/services/amqp_client.dart';
import 'package:visionapp/features/services/device_service.dart';
import 'package:visionapp/features/services/http_service.dart';
import 'package:visionapp/init_dependencies.dart';
import 'package:visionapp/presentation/pages/auth/login_page.dart';

class HomePage extends StatefulWidget {
  final int ?forceLoad;


  static route() => MaterialPageRoute(builder: (context) => const HomePage());

  static logout(BuildContext context) => SharedPrefs.instance.clearUser().then(
      (value) =>
      {
        BlocProvider.of<AppUserCubit>(context).logout(),
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false)
      });

  const HomePage({super.key, this.forceLoad});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User user;
  int selectedMenu = 0;


  Future<void> registerUserForMessages(int userId) async {
    final deviceService = DeviceService(HttpServiceImpl());
    final amqpClient = AmqpClient();
    final deviceId = await deviceService.registerDeviceToUser(userId);
    final sharedPrefs =  serviceLocator<SharedPrefs>();
    await sharedPrefs.save("deviceId", deviceId);
    amqpClient.setupConsumers(deviceId);
  }

  @override
  void initState() {
    final state = context.read<AppUserCubit>().state;
    if(state is AppUserIsLoggedIn) {
      user = state.user;
      final userId = user.id;
      registerUserForMessages(userId!!);
    }

    if(widget.forceLoad != null) {
      setState(() {
        selectedMenu = widget.forceLoad!;
      });

    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  //  selectedMenu = widget.forceLoad != null ? widget.forceLoad! : 0;

    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Container(
          width: double.infinity,
          height: 75,
          margin: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
          decoration: BoxDecoration(
              color: AppPalette.darkBlue,
              borderRadius: BorderRadius.circular(40)),
          child: Stack(
            children:  [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: kMainMenus[user.role]!
                    .map((menu) => Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        SystemSound.play(SystemSoundType.click);
                        setState(() {
                          selectedMenu = kMainMenus[user.role]!.indexOf(menu);
                        });
                      },
                      hoverColor: Colors.white,
                      icon: AssetIcon(
                        assetPath: menu.icon,
                        color: selectedMenu == kMainMenus[user.role]!
                            .indexOf(menu) ? menu.selected : menu.normal,
                        size: menu.size,
                      ),

                      isSelected: selectedMenu == kMainMenus[user.role]!.indexOf(menu),
                    ),
                    Text(
                      menu.label,
                      style:  TextStyle(
                          color: selectedMenu == kMainMenus[user.role]!
                              .indexOf(menu) ? menu.selected : menu.normal, fontSize: 12),
                    ),
                    const SizedBox(height: 3)
                  ],
                ))
                    .toList(),
              ),
          user.role == UserRole.newsPublisher.value ?  Center(
                  child: InkWell(child: const Image(image: AssetImage('assets/images/upload.png'),
                      height: 120, width: 120), onTap: () {
                      SystemSound.play(SystemSoundType.click);
                      setState(() {
                        selectedMenu = 2;
                      });

                  },)) : const
          SizedBox(),
            ],
          )),
      body: kPages[user.role]![selectedMenu],
    );
  }
}
