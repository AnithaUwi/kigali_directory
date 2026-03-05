import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/listing_provider.dart';
import '../../models/category.dart';
import '../listings/listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  MapController? _mapController;

  // Kigali coordinates
  static const LatLng _kigaliCenter = LatLng(-1.9441, 30.0619);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Map'),
        elevation: 4,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 40,
              child: GestureDetector(
                onTap: () {
                  _showLegend(context);
                },
                child: Tooltip(
                  message: 'Legend',
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ListingProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: _kigaliCenter,
                  initialZoom: 12,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: provider.listings.map((listing) {
                      return Marker(
                        point: LatLng(listing.latitude, listing.longitude),
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ListingDetailScreen(listing: listing),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getMarkerColor(listing.category.displayName),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getMarkerColor(listing.category.displayName)
                                      .withOpacity(0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFF1E88E5),
                  onPressed: () {
                    _mapController?.move(_kigaliCenter, 12);
                  },
                  tooltip: 'Center map',
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLegend(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildLegendItem(
                Colors.red,
                'Hospital',
                Icons.local_hospital,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Colors.blue,
                'Police',
                Icons.local_police,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Colors.orange,
                'Restaurant',
                Icons.restaurant,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Colors.green,
                'Park',
                Icons.park,
              ),
              const SizedBox(height: 12),
              _buildLegendItem(
                Colors.purple,
                'Other Services',
                Icons.location_on,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(Color color, String label, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Color _getMarkerColor(String category) {
    if (category.contains('Hospital')) return Colors.red;
    if (category.contains('Police')) return Colors.blue;
    if (category.contains('Restaurant') || category.contains('Café')) return Colors.orange;
    if (category.contains('Park')) return Colors.green;
    return Colors.purple;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
