import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

Future<void> openWhatsApp(String whatsappNumber) async {
  final whatsappUrl =
      'whatsapp://send?phone=${whatsappNumber}text=Olá,tudo bem ?';

  if (await canLaunch(whatsappUrl)) {
    await launch(whatsappUrl);
  }
}
