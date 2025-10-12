import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingViewModel extends ChangeNotifier {
  Future<void> callSupport() async {
  final phoneuri = Uri.parse('tel:+970595541004');
   await launchUrl(phoneuri , mode: LaunchMode.externalApplication) ; 
  }
}
