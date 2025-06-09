import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Mock data for movie locations
  final List<Map<String, dynamic>> _locations = [
    {
      'title': 'The Dark Knight',
      'location': 'Chicago, IL',
      'image': 'https://images.unsplash.com/photo-1531259736756-6caccf485f81?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
      'distance': '2.5 km',
      'rating': 4.8,
      'year': 2008,
      'lat': 41.8781,
      'lng': -87.6298,
    },
    {
      'title': 'Spider-Man: No Way Home',
      'location': 'New York, NY',
      'image': 'https://images.unsplash.com/photo-1635805737707-575885ab0820?ixlib=rb-4.0.3&auto=format&fit=crop&w=1374&q=80',
      'distance': '5.1 km',
      'rating': 4.7,
      'year': 2021,
      'lat': 40.7128,
      'lng': -74.0060,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Map Placeholder with Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.primaryColor.withOpacity(0.1),
                  theme.scaffoldBackgroundColor,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 80,
                    color: theme.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Interactive Map',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore movie locations near you',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Top Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search locations...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Sheet with Locations
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Handle
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nearby Locations',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_locations.length} places',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Location List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _locations.length,
                      itemBuilder: (context, index) {
                        final location = _locations[index];
                        return _buildLocationCard(context, location);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Floating Action Button for Current Location
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.4 + 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Will be used for current location
              },
              backgroundColor: Colors.white,
              elevation: 4,
              child: Icon(
                Icons.my_location,
                color: theme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLocationCard(BuildContext context, Map<String, dynamic> location) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate to location details
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: location['image'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            // Location Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location['title'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: theme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location['location'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: theme.primaryColor,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                location['rating'].toString(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Distance
                        Text(
                          '• ${location['distance']} •',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                        // Year
                        Text(
                          ' ${location['year']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Navigation Icon
            Padding(
              padding: const EdgeInsets.only(top: 12, right: 12),
              child: Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
