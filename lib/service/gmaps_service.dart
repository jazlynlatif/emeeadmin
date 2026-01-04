import 'package:url_launcher/url_launcher.dart';

Future<void> openLocation(double lat, double lang) async {
  final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lang');

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch Google Maps');
  }
}
