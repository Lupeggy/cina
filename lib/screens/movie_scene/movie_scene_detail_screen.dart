import 'package:flutter/material.dart';
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
  late final TabController _tabController;
  bool isMapExpanded = false;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  // Static location data
  final Map<String, dynamic> _locationData = {
    'address': '123 Movie Street, Hollywood, CA 90210',
    'coordinates': '34.0522° N, 118.2437° W',
    'city': 'Los Angeles',
    'country': 'United States',
  };

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
        curve: Curves.easeInOut,
      ),
    );
    
    // Start the animation
    _animationController.forward();
    
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchMaps() async {
    // Use a generic location since we don't have coordinates
    const String address = 'Hollywood+Sign,Los+Angeles,CA';
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');
    
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      if (kDebugMode) {
        print('Could not launch $googleMapsUrl');
      }
      // Show a snackbar if maps can't be launched
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open maps')),
        );
      }
    }
  }

  Widget _buildInfoRow(IconData icon, String text, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSceneCard(BuildContext context, Map<String, dynamic> scene) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate card width based on screen size
    final cardWidth = screenWidth * 0.5; // 50% of screen width for more compact cards
    final imageHeight = cardWidth * 0.75; // 75% of card width for image
    
    return SizedBox(
      width: cardWidth,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // Navigate to scene details
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min, // Make the card take minimum height
            children: [
              // Image with fixed aspect ratio
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: scene['image'] ?? '',
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: imageHeight,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: imageHeight,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              // Content with less padding
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scene['title'] ?? 'Unknown',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      scene['location'] ?? 'Unknown Location',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 14,
                          color: Colors.amber[600],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${scene['rating'] ?? '0.0'}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          scene['distance'] ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                          ),
                        ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate height based on card width (50% of screen width * 0.75 for image + content height)
        final screenWidth = constraints.maxWidth;
        final cardHeight = (screenWidth * 0.5 * 0.75) + 70; // Reduced content height
        
        return SizedBox(
          height: cardHeight + 8, // Reduced padding
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemCount: _nearbyScenes.length,
            itemBuilder: (context, index) {
              return _buildSceneCard(context, _nearbyScenes[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildMapTab() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMapExpanded = !isMapExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceVariant,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Static map image placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.blueGrey[100],
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 64,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Map View',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
            // Location details at bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location Details',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLocationDetail(Icons.location_on, widget.scene['location'] ?? 'Unknown Location'),
                  const SizedBox(height: 4),
                  _buildLocationDetail(Icons.movie, 'Featured in: ${widget.scene['movie'] ?? 'Unknown Movie'}'),
                ],
              ),
            ),
            // Directions button
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                onPressed: _launchMaps,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.directions, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLocationDetail(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final title = widget.scene['title']?.toString() ?? 'Movie Scene';
    final imageUrl = widget.scene['image']?.toString() ?? '';
    final location = widget.scene['location']?.toString() ?? 'Unknown Location';
    final description = widget.scene['description']?.toString() ?? 'No description available.';
    final year = widget.scene['year']?.toString() ?? '';
    final rating = (widget.scene['rating'] as num?)?.toDouble() ?? 0.0;
    final director = widget.scene['director']?.toString() ?? 'Unknown';
    final cast = widget.scene['cast']?.toString() ?? 'Unknown';

    try {
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
                    setState(() {
                      isSaved = !isSaved;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isSaved ? 'Added to saved' : 'Removed from saved'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
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
                    Share.share('Check out this movie scene: $title at $location');
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
                      'Movie: ${widget.scene['movie'] ?? 'Unknown'}',
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
                    _buildNearbyScenes(),
                  ],
                ),
              ),
              // Location Tab
              _buildMapTab(),
              // Scenes Tab
              _buildNearbyScenes(),
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
