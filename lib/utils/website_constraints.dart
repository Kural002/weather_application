import 'package:flutter/material.dart';

class WebsiteConstraints {
  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }
  
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }
}