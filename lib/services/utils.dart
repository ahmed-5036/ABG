import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Utils {
  Utils._();

  static Future<void> launchInBrowser(String? url,
      {LaunchMode? urlMode}) async {
    if (url == null) return;
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrl(
          Uri.parse(url),
          mode: urlMode ?? LaunchMode.platformDefault,
        );
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> launchWhatsappBrowser(String whatsapp) async {
    if (await canLaunchUrlString("tel:$whatsapp")) {
      await launchUrlString("https://wa.me/$whatsapp",
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $whatsapp';
    }
  }

  static Future<void> sendEmail(String? toEmail,
      {String subject = "", String message = ""}) async {
    if (toEmail == null) return;
    final String emailLaunchUri =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';
    if (await canLaunchUrlString(emailLaunchUri.toString())) {
      await launchUrlString(
        emailLaunchUri.toString(),
      );
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }

  static Future<void> callPhone(
    String? phone,
  ) async {
    if (await canLaunchUrlString("tel:$phone")) {
      await launchUrlString(
        "tel:$phone",
      );
    } else {
      throw 'Could not launch $phone';
    }
  }
}
