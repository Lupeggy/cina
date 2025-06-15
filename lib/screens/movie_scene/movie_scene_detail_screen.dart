import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cina/core/constants/app_colors.dart';
import 'package:cina/core/constants/app_typography.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:share_plus/share_plus.dart';

// Mock data for nearby movie scenes
final List<Map<String, dynamic>> _nearbyScenes = [
  {
    'title': 'The Dark Knight Rises',
    'movie': 'The Dark Knight Rises',
    'location': 'Wall Street, New York',
    'image': 'https://picsum.photos/600/400?random=10',
    'distance': '0.8 km',
    'rating': 4.7,
  },
  {
    'title': 'Spider-Man: Homecoming',
    'movie': 'Spider-Man: Homecoming',
    'location': 'Queens, New York',
    'image': 'https://picsum.photos/600/400?random=11',
    'distance': '1.2 km',
    'rating': 4.5,
  },
  {
    'title': 'The Devil Wears Prada',
    'movie': 'The Devil Wears Prada',
    'location': '5th Avenue, New York',
    'image': 'https://picsum.photos/600/400?random=12',
    'distance': '1.5 km',
    'rating': 4.3,
  },
];

class MovieSceneDetailScreen extends StatefulWidget {
  final Map<String, dynamic> scene;

  const MovieSceneDetailScreen({super.key, required this.scene});

  @override
  State<MovieSceneDetailScreen> createState() => _MovieSceneDetailScreenState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _MovieSceneDetailScreenState extends State<MovieSceneDetailScreen> with TickerProviderStateMixin {
  bool isSaved = false;
  bool _isLoading = true;
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;
  late final TabController _tabController;
  bool isMapExpanded = false;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize tab controller
    _tabController = TabController(length: 3, vsync: this);
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    // Initialize fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    // Initialize with default location first
    _selectedLocation = const LatLng(40.7128, -74.0060); // Default to New York
    
    // Start the animation
    _animationController.forward();
    
    // Initialize data after a small delay to ensure the UI is built
    Future.delayed(const Duration(milliseconds: 100), _initializeData);
  }

  Future<void> _initializeData() async {
    try {
      if (kDebugMode) {
        debugPrint('Received scene data: ${widget.scene.toString()}');
      }
      
      // Parse location from scene data
      if (widget.scene['location'] != null) {
        // This is a simplified example - in a real app, you would want to geocode the address
        // For now, we'll just use a default location
        _selectedLocation = const LatLng(40.7128, -74.0060); // Default to New York
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _addMarker();
            setState(() {
              _isLoading = false;
            });
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error initializing data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Dispose controllers in reverse order of initialization
    _tabController.dispose();
    _animationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _addMarker() {
    try {
      if (_selectedLocation == null) return;

      final marker = Marker(
        markerId: const MarkerId('scene_location'),
        position: _selectedLocation!,
        infoWindow: InfoWindow(
          title: widget.scene['title']?.toString() ?? 'Movie Scene',
          snippet: widget.scene['location']?.toString() ?? 'Filming Location',
        ),
      );

      if (mounted) {
        setState(() {
          _markers.clear();
          _markers.add(marker);
        });
      }
    } catch (e) {
      debugPrint('Error adding marker: $e');
    }
  }

  void _toggleMapSize() {
    setState(() {
      isMapExpanded = !isMapExpanded;
    });
  }

  Future<void> _launchMaps() async {
    if (_selectedLocation == null) return;
    
    final url = 'https://www.google.com/maps/search/?api=1&query=${_selectedLocation!.latitude},${_selectedLocation!.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch maps')),
        );
      }
    }
  }

  Widget _buildInfoRow(IconData icon, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
            if (onTap != null) const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSceneCard(BuildContext context, Map<String, dynamic> scene) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 200, // Fixed height for the card
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieSceneDetailScreen(scene: scene),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Prevent vertical expansion
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: scene['image'] ?? '',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scene['title'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scene['movie'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            scene['location'] ?? 'Unknown Location',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (scene['distance'] != null) ...[
                          const Icon(
                            Icons.directions_walk,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            scene['distance'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNearbyScenes() {
    if (_nearbyScenes.isEmpty) {
      return const Center(
        child: Text('No nearby scenes found'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _nearbyScenes.length,
      itemBuilder: (context, index) {
        return _buildSceneCard(context, _nearbyScenes[index]);
      },
    );
  }

  Widget _buildLocationTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 300, // Fixed height for the map
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _selectedLocation == null
                  ? const Center(child: CircularProgressIndicator())
                  : Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _selectedLocation!,
                            zoom: 14.0,
                          ),
                          markers: _markers,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            if (!_controller.isCompleted) {
                              _controller.complete(controller);
                            }
                            _mapController = controller;
                            // Add a small delay to ensure the map is fully loaded
                            Future.delayed(const Duration(milliseconds: 500), () {
                              if (mounted && _selectedLocation != null) {
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(_selectedLocation!, 14.0),
                                );
                              }
                            });
                          },
                          onCameraMove: (position) {
                            // Keep track of the current position
                            if (mounted) {
                              setState(() {
                                _selectedLocation = position.target;
                              });
                            }
                          },
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: FloatingActionButton(
                            heroTag: 'location_fab_${_selectedLocation?.latitude ?? 'null'}_${_selectedLocation?.longitude ?? 'null'}_${DateTime.now().millisecondsSinceEpoch}',
                            mini: true,
                            onPressed: _launchMaps,
                            child: const Icon(Icons.directions, size: 20),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          // Rest of the location tab content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.scene['location']?.toString() ?? 'Location not available',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions, size: 20),
                    label: const Text('Get Directions'),
                    onPressed: _launchMaps,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    try {
      final title = widget.scene['title']?.toString() ?? 'Movie Scene';
      final imageUrl = widget.scene['image']?.toString() ?? '';
      final location = widget.scene['location']?.toString() ?? 'Unknown Location';
      final description = widget.scene['description']?.toString() ?? 'No description available.';
      final year = widget.scene['year']?.toString() ?? '';
      final director = widget.scene['director']?.toString() ?? 'Unknown';
      final cast = widget.scene['cast']?.toString() ?? 'Unknown';
      final rating = (widget.scene['rating'] as num?)?.toDouble() ?? 0.0;

      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: size.height * 0.4,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? theme.primaryColor : Colors.white,
                    ),
                  ),
                  onPressed: () {
                    try {
                      setState(() {
                        isSaved = !isSaved;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isSaved ? 'Added to saved' : 'Removed from saved'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    } catch (e) {
                      debugPrint('Error in bookmark action: $e');
                    }
                  },
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.share, color: Colors.white, size: 20),
                  ),
                  onPressed: () {
                    try {
                      Share.share('Check out this movie scene: $title at $location');
                    } catch (e) {
                      debugPrint('Error sharing: $e');
                    }
                  },
                ),
              ],
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: theme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: theme.primaryColor,
                  tabs: const [
                    Tab(text: 'Details'),
                    Tab(text: 'Location'),
                    Tab(text: 'Scenes'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              // Details Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    _buildInfoRow(
                      Icons.movie,
                      'Movie: ${widget.scene['movie'] ?? 'Unknown'}' ,
                    ),
                    _buildInfoRow(
                      Icons.person,
                      'Director: $director',
                    ),
                    _buildInfoRow(
                      Icons.people,
                      'Cast: $cast',
                    ),
                    if (year.isNotEmpty)
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Year: $year',
                      ),
                    _buildInfoRow(
                      Icons.star,
                      'Rating: ${rating.toStringAsFixed(1)}/5.0',
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Nearby Scenes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _nearbyScenes.length,
                        itemBuilder: (context, index) {
                          final scene = _nearbyScenes[index];
                          return SizedBox(
                            width: 300,
                            child: _buildSceneCard(context, scene),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Location Tab
              _buildLocationTab(),
              // Scenes Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: _buildNearbyScenes(),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error in MovieSceneDetailScreen build: $e');
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text('An error occurred while loading this scene.'),
        ),
      );
    }
  }
}
