import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jummi/constants.dart';
import 'package:jummi/size_config.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    required this.many,
    required this.markers,
    required this.title,
    super.key,
  });
  final bool many;
  final List<Map<String, String>> markers;
  final String title;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(
              double.parse(widget.markers[0]['latitude']!),
              double.parse(widget.markers[0]['longitude']!),
            ),
            zoom: 12,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.sanlysowda',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(
                    double.parse(widget.markers[0]['latitude']!),
                    double.parse(widget.markers[0]['longitude']!),
                  ),
                  builder: (context) => Icon(
                    Icons.location_pin,
                    color: kPrimaryColor,
                    size: SizeConfig.screenWidth * 0.08,
                  ),
                ),
              ],
            ),
          ],
        ),
        // body: FlutterMap(
        //   mapController: _mapController,
        //   options: MapOptions(
        //     center: LatLng(
        //       double.parse(widget.markers[0]["latitude"]!),
        //       double.parse(widget.markers[0]["longitude"]!),
        //     ),
        //     zoom: 14,
        //   ),
        //   children: [
        //     TileLayer(
        //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        //       userAgentPackageName: 'com.example.flutter_map_example',
        //     ),
        //     MarkerLayer(
        //       markers: [
        //         for (var i = 0; i < widget.markers.length; i++)
        //           Marker(
        //             point: LatLng(
        //               double.parse(widget.markers[i]["latitude"]!),
        //               double.parse(widget.markers[i]["latitude"]!),
        //             ),
        //             width: 80,
        //             height: 80,
        //             builder: (context) => Image.asset(
        //               'assets/images/no-image.png',
        //               width: 80,
        //             ),
        //           ),
        //       ],
        //     ),
        //     // MarkerLayer(
        //     //   markers: _getMarkers(widget.markers),
        //     // ),
        //   ],
        // ),
      ),
    );
  }
}
