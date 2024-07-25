import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visionapp/core/theme/app_palette.dart';

import 'asset_sound.dart';


void _showSnackBar(BuildContext context, String message, bool isError) {
  final snackBar = SnackBar(
    content: Text(message, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),),
    backgroundColor: isError ? Colors.red : AppPalette.primaryBlue,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void showSuccessSnackBar(BuildContext context, String message) {
  _showSnackBar(context, message, false);
}

void showErrorSnackBar(BuildContext context, String message) async  {
  if(message.isNotEmpty) {
    await AssetSound.playSound(AssetSoundType.error);
    _showSnackBar(context, message, true);
  }
}