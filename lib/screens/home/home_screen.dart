import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../search/search_screen.dart';
import '../post/post_screen.dart';
import '../profile/profile_screen.dart';
import '../trip/trip_screen.dart';

// Content filter enum
enum ContentFilter {
  all,
  topRated,
  action,
  trending,
  newReleases,
}

// Helper class for filter chip data
class FilterChipData {
  final String label;
  final IconData icon;

  const FilterChipData(this.label, this.icon);
}

// Mock data for movie scenes
final List<Map<String, dynamic>> _movieScenes = [
  {
    'title': 'The Dark Knight',
    'movie': 'The Dark Knight',
    'location': 'Chicago, IL',
    'image': 'https://images.unsplash.com/photo-1531259736756-6caccf485f81?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
    'distance': '2.5 km',
    'rating': 4.8,
    'year': 2008,
  },
  {
    'title': 'Spider-Man: No Way Home',
    'movie': 'Spider-Man: No Way Home',
    'location': 'New York, NY',
    'image': 'https://images.unsplash.com/photo-1635805737707-575885ab0820?ixlib=rb-4.0.3&auto=format&fit=crop&w=1374&q=80',
    'distance': '5.1 km',
    'rating': 4.7,
    'year': 2021,
  },
  {
    'title': 'Inception',
    'movie': 'Inception',
    'location': 'Los Angeles, CA',
    'image': 'https://images.unsplash.com/photo-1620640695378-5fde49ab7528?ixlib=rb-4.0.3&auto=format&fit=crop&w=1469&q=80',
    'distance': '3.2 km',
    'rating': 4.6,
    'year': 2010,
  },
  {
    'title': 'The Avengers',
    'movie': 'The Avengers',
    'location': 'Cleveland, OH',
    'image': 'https://images.unsplash.com/photo-1534447677768-be436bb09401?ixlib=rb-4.0.3&auto=format&fit=crop&w=1494&q=80',
    'distance': '7.8 km',
    'rating': 4.5,
    'year': 2012,
  },
];

// Mock data for fun trips
final List<Map<String, dynamic>> _funTrips = [
  {
    'title': 'Marvel Cinematic Tour',
    'scenes': 8,
    'duration': '2 days',
    'image': 'https://images.unsplash.com/photo-1630000415219-495422827e2b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
  },
  {
    'title': 'Nolan\'s Filming Spots',
    'scenes': 5,
    'duration': '1 day',
    'image': 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80',
  },
];



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// App Constants
const double kHorizontalPadding = 16.0;
const double kVerticalPadding = 12.0;

class _HomeScreenState extends State<HomeScreen> {
  ContentFilter _selectedFilter = ContentFilter.all;
  final ScrollController _scrollController = ScrollController();
  
  // Mock user data
  final String userName = 'Movie Explorer';
  final String userLocation = 'New York, NY';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Build hero section with greeting and location
  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.08),
            Theme.of(context).primaryColor.withOpacity(0.02),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.3,
              ),
              children: [
                const TextSpan(text: 'Welcome back, '),
                TextSpan(
                  text: '$userName!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Near $userLocation',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 20),
          _buildAIRecommendationCard(),
        ],
      ),
    );
  }

  // Build AI recommendation card
  Widget _buildAIRecommendationCard() {
    return GestureDetector(
      onTap: () {
        // Navigate to personalized recommendations
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.movie_creation_outlined, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personalized for you',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on your recent activity',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  // Build filter chips for quick actions
  Widget _buildFilterChips() {
    final filters = [
      const FilterChipData('All', Icons.explore_outlined),
      const FilterChipData('Top Rated', Icons.star_border_rounded),
      const FilterChipData('Action', Icons.movie_filter_outlined),
      const FilterChipData('Trending', Icons.trending_up_rounded),
      const FilterChipData('New', Icons.new_releases_outlined),
    ];

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter.index == index;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = ContentFilter.values[index];
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3))
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter.icon,
                    size: 16,
                    color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    filter.label,
                    style: TextStyle(
                      color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Colors.grey[800],
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Build section header with title and see all button
  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'See all',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Build list of nearby movie scenes
  Widget _buildMovieScenesList() {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: _movieScenes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final scene = _movieScenes[index];
          return _buildMovieSceneCard(scene);
        },
      ),
    );
  }

  // Build individual movie scene card
  Widget _buildMovieSceneCard(Map<String, dynamic> scene) {
    return GestureDetector(
      onTap: () {
        // Navigate to scene details
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                // Image
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(scene['image'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient overlay
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                // Distance badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on_outlined, size: 12, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 2),
                        Text(
                          '${scene['distance']} mi',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          scene['title'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 14, color: Colors.amber[600]),
                          const SizedBox(width: 2),
                          Text(
                            scene['rating'].toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Movie title
                  Text(
                    scene['movie'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          scene['location'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  // Build list of fun trips
  Widget _buildFunTripsList() {
    // Mock data for fun trips
    final funTrips = [
      {
        'title': 'Marvel Movie Tour',
        'scenes': 8,
        'duration': '4h 30m',
        'imageUrl': 'https://example.com/marvel-tour.jpg',
      },
      {
        'title': 'Romantic NYC',
        'scenes': 5,
        'duration': '3h 15m',
        'imageUrl': 'https://example.com/romantic-nyc.jpg',
      },
      {
        'title': 'Classic Movie Spots',
        'scenes': 6,
        'duration': '5h',
        'imageUrl': 'https://example.com/classic-movies.jpg',
      },
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: funTrips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final trip = funTrips[index];
          return _buildFunTripCard(trip);
        },
      ),
    );
  }

  // Build individual fun trip card
  Widget _buildFunTripCard(Map<String, dynamic> trip) {
    return GestureDetector(
      onTap: () {
        // Navigate to trip details
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                trip['imageUrl'] as String,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
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
            // Content
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip['title'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTripInfo(Icons.movie_outlined, '${trip['scenes']} scenes'),
                        const SizedBox(width: 16),
                        _buildTripInfo(Icons.access_time_rounded, trip['duration'] as String),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build trip info row
  Widget _buildTripInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Build AI-powered trip planning section
  Widget _buildAITripPlanningSection() {
    return GestureDetector(
      onTap: () {
        // Navigate to AI trip planning
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Plan Your Perfect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const Text(
                    'Movie Trip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Let AI create a personalized itinerary based on your favorite movies',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Start Planning',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Image/Icon
            const SizedBox(width: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_motion_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }



  // Build bottom search bar
  Widget _buildBottomSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          // Navigate to search screen
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[500], size: 20),
              const SizedBox(width: 12),
              Text(
                'Search for movie scenes...',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Home Page
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 100.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0.5,
                  title: const Text('Cina', 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  centerTitle: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.black87, size: 24),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 4),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: RefreshIndicator(
              onRefresh: () async {
                // Handle refresh
                await Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Personalized Hero Section
                    _buildHeroSection(),
                    
                    // 2. Quick Action Buttons
                    _buildFilterChips(),
                    
                    // 3. Nearby Movie Scenes Section
                    _buildSectionHeader(
                      'Nearby Movie Scenes', 
                      onSeeAll: () {}
                    ),
                    _buildMovieScenesList(),
                    
                    // 4. Fun Trips Section
                    _buildSectionHeader(
                      'Popular Movie Trips',
                      onSeeAll: () {}
                    ),
                    _buildFunTripsList(),
                    
                    // 5. AI-Powered Trip Planning
                    _buildAITripPlanningSection(),
                    
                    const SizedBox(height: 100), // Extra space for bottom navigation
                  ],
                ),
              ),
            ),
          ),
          // Search Screen
          const SearchScreen(),
          // Post Screen
          const PostScreen(),
          // Trip Screen
          const TripScreen(),
          // Profile Screen
          const ProfileScreen(),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            activeIcon: Icon(Icons.add_box),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel_outlined),
            activeIcon: Icon(Icons.card_travel),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
