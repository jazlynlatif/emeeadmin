import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationMap extends StatelessWidget {
  final double lat;
  final double long;
  const LocationMap({
    super.key,
    required this.lat,
    required this.long
  });

  @override
  Widget build(BuildContext context) {
    final MapController _mapController = MapController();
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: FlutterMap(
        mapController: _mapController,
        options : MapOptions(
          initialCenter: LatLng(lat, long),
          initialZoom: 18,
        ),
        children : [
          TileLayer(
            urlTemplate: 'https://api.maptiler.com/maps/base-v4/{z}/{x}/{y}.png?key=P40e2FSbT2joZsUYelmi',
            userAgentPackageName: 'com.example.emee',
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                '© MapTiler © OpenStreetMap contributors',
                // onTap: () => launchUrl(
                //   Uri.parse('https://www.maptiler.com/copyright/'),
                // ),
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, long),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ]
      ),
    );
  }
}