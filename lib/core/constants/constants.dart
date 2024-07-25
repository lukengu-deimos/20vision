import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:visionapp/core/theme/app_palette.dart';
import 'package:visionapp/domain/entities/menu_item.dart';
import 'package:visionapp/domain/enums/user_role.dart';
import 'package:visionapp/presentation/pages/main/alert_page.dart';
import 'package:visionapp/presentation/pages/main/category_page.dart';
import 'package:visionapp/presentation/pages/main/profile_page.dart';
import 'package:visionapp/presentation/pages/main/recent_posts_page.dart';
import 'package:visionapp/presentation/pages/main/upload_page.dart';

Map<String, String> kQueueService = {
  'endpoint': '20vision.co.za',
  'username': '20vision-queue',
  'password': 'qejzof-'
};

String kNewsPublisherRegisterMessage = "Thank you %s for registering to "
    "20Vision. Your details are being reviewed, and you will be "
    "notified shortly so you can login and post your articles.";

String kUserSessionKey = 'user';
Map<String, List<MenuItem>> kMainMenus = {
  UserRole.appUser.value: [
    MenuItem(
        label: 'HOME',
        title: 'home',
        icon: 'assets/images/home.png',
        size: 24,
        selected: Colors.white,
        normal: AppPalette.unselectedBlue,
        showLabel: true),
    MenuItem(
        label: 'TOPICS',
        title: 'topics',
        icon: 'assets/images/export.png',
        size: 24,
        selected: Colors.white,
        normal: AppPalette.unselectedBlue,
        showLabel: true),
    MenuItem(
        label: 'PROFILE',
        title: 'profile',
        icon: 'assets/images/profile.png',
        size: 24,
        selected: Colors.white,
        normal: AppPalette.unselectedBlue,
        showLabel: true)
  ],
  UserRole.newsPublisher.value: [
    MenuItem(
        label: 'HOME',
        title: 'home',
        icon: 'assets/images/home.png',
        size: 24,
        selected: Colors.white,
        normal: AppPalette.unselectedBlue,
        showLabel: true),
    MenuItem(
        label: 'TOPICS',
        title: 'topics',
        icon: 'assets/images/export.png',
        size: 24,
        selected: Colors.white,
        normal: AppPalette.unselectedBlue,
        showLabel: true),
    MenuItem(
        label: 'UPLOAD',
        title: 'upload',
        icon: 'assets/images/upload.png',
        size: 24,
        selected: AppPalette.transparent,
        normal: AppPalette.transparent,
        showLabel: false),
    MenuItem(
        label: 'ALERT',
        title: 'alert',
        icon: 'assets/images/alert.png',
        size: 24,
        selected: Colors.white,
        normal: AppPalette.unselectedBlue,
        showLabel: true),
    MenuItem(
        label: 'PROFILE',
        title: 'profile',
        icon: 'assets/images/profile.png',
        size: 24,
        selected: Colors.white,
        normal: AppPalette.unselectedBlue,
        showLabel: true)
  ]
};

Map<String, List<Widget>> kPages = {
  UserRole.appUser.value: [
    const RecentPostsPage(),
    const CategoryPage(),
    const ProfilePage(role: UserRole.appUser,),
  ],
  UserRole.newsPublisher.value: [
    const RecentPostsPage(),
    const CategoryPage(),
    const UploadPage(),
    const AlertPage(),
    const ProfilePage(role: UserRole.newsPublisher,),
  ]
};
