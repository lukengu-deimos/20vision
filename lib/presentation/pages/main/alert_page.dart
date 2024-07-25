import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:visionapp/core/cubits/app_user_cubit.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/core/utils/date_utils.dart';
import 'package:visionapp/core/utils/snackbar.dart';
import 'package:visionapp/core/widgets/container_with_bg.dart';
import 'package:visionapp/core/widgets/loader.dart';
import 'package:visionapp/domain/usecases/alert/delete_alert.dart';
import 'package:visionapp/presentation/blocs/alert_bloc.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {

  @override
  void initState() {
    context.read<AlertBloc>().add(FetchAlerts());


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final userId = (context.read<AppUserCubit>().state as AppUserIsLoggedIn)
        .user.id;

    return Scaffold(
      appBar: AppBar(
        title:  RichText(
            text: const TextSpan(
              text: 'ALERT',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: '',
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
            child:  Padding(padding: const EdgeInsets.all(20),
                child:BlocConsumer<AlertBloc, AlertState>(builder:
                    (context, state){
                  if(state is AlertFetchSuccess) {
                    if(state.notifications.isEmpty) {
                      return const Center(
                        child: Text("No alerts found", style: TextStyle(
                          color: AppPalette.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),),
                      );
                    }
                    return ListView.builder(itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete, size: 20,),
                                    onPressed: () {
                                      SystemSound.play(SystemSoundType.click);
                                      context.read<AlertBloc>().add
                                        (DeleteAlertEvent(state
                                          .notifications[index]
                                          .notificationId, userId!));
                                    },
                                    color: AppPalette.red,
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.all(10), child:Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(state.notifications[index].title,
                                      style: const TextStyle(fontSize: 17,
                                          fontWeight: FontWeight.bold),),

                                    Text(
                                      state.notifications[index].body,
                                      style: const TextStyle(
                                        color: AppPalette.darkBlue,
                                        fontSize: 12,
                                      ),
                                      maxLines: null,
                                      overflow: TextOverflow.visible,
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(formatTimestampForAlert(state
                                          .notifications[index]
                                          .createdAt), style: const TextStyle(
                                          color: Colors.grey, fontSize: 11)
                                      ),)
                                  ],
                                ))
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      );
                    }, itemCount: state.notifications.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                    );
                  }
                  if(state is AlertLoading) {
                    return const Loader(message: "Please wait...",);
                  }
                  return const SizedBox();
                }, listener: (context,state){
                  if(state is AlertFetchFailure) {
                   showErrorSnackBar(context, state.message);
                  }

                },))),
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
      floatingActionButton: Padding(padding: const EdgeInsets.only(bottom: 20)
          , child:
      FloatingActionButton(
          onPressed: () => context.read<AlertBloc>().add(UpdateAlertEvent
            (userId!)),
          tooltip: 'Refresh List',
          backgroundColor: AppPalette.unselectedBlue,
          foregroundColor: AppPalette.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.refresh)
      ))
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert Dialog'),
        content: const Text('This is an alert dialog.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}