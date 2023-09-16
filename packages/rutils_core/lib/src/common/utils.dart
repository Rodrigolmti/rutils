import 'package:url_launcher/url_launcher.dart';

/// Try to launch an url in the default browser or the configured
/// app if possible. This function uses the package [url_launcher]
/// so you need to setup the native configuration.
Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

/// Try to open a chat in the whatsapp if possible.
/// This function uses the package [url_launcher]
/// so you need to setup the native configuration.
Future<void> openWhatsApp(String whatsappNumber, String message) async {
  final whatsappUrl = 'whatsapp://send?phone=${whatsappNumber}text=$message';

  if (await canLaunch(whatsappUrl)) {
    await launch(whatsappUrl);
  }
}
