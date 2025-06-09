import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({super.key});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data
  final List<Map<String, dynamic>> _visitedScenes = [
    {
      'movie': 'Inception',
      'location': 'Paris, France',
      'date': 'Visited: Jun 5, 2023',
      'image': 'https://via.placeholder.com/300x200?text=Inception+Scene',
      'likes': 128,
      'isLiked': false,
    },
    {
      'movie': 'The Dark Knight',
      'location': 'Chicago, USA',
      'date': 'Visited: May 15, 2023',
      'image': 'https://via.placeholder.com/300x200?text=Dark+Knight+Scene',
      'likes': 256,
      'isLiked': true,
    },
  ];
  
  final List<Map<String, dynamic>> _wishlist = [
    {
      'movie': 'Interstellar',
      'location': 'Iceland',
      'image': 'https://via.placeholder.com/300x200?text=Interstellar+Scene',
    },
    {
      'movie': 'Harry Potter',
      'location': 'Oxford, UK',
      'image': 'https://via.placeholder.com/300x200?text=Harry+Potter+Scene',
    },
  ];
  
  final Map<String, int> _userStats = {
    'totalVisits': 15,
    'totalMovies': 8,
    'totalCountries': 6,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image with gradient overlay
                    Image.network(
                      'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.primaryColor,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://randomuser.me/api/portraits/women/44.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Movie Explorer',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '@cinemalover',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItem('Visits', _userStats['totalVisits']!),
                              _buildStatItem('Movies', _userStats['totalMovies']!),
                              _buildStatItem('Countries', _userStats['totalCountries']!),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bio Section
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Passionate about visiting real-life movie locations around the world. Sharing my cinematic journey one scene at a time! 🎬✈️',
                  style: TextStyle(fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Social Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton(
                      icon: FontAwesomeIcons.instagram,
                      color: const Color(0xFFE1306C),
                      onPressed: () => _shareOnSocial('instagram'),
                    ),
                    _buildSocialButton(
                      icon: FontAwesomeIcons.facebook,
                      color: const Color(0xFF4267B2),
                      onPressed: () => _shareOnSocial('facebook'),
                    ),
                    _buildSocialButton(
                      icon: FontAwesomeIcons.twitter,
                      color: const Color(0xFF1DA1F2),
                      onPressed: () => _shareOnSocial('twitter'),
                    ),
                    _buildSocialButton(
                      icon: Icons.share,
                      color: Colors.grey[600]!,
                      onPressed: _showShareOptions,
                    ),
                  ],
                ),
              ),
              
              // Tabs
              Container(
                margin: const EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: theme.primaryColor,
                  unselectedLabelColor: Colors.grey[600],
                  indicatorColor: theme.primaryColor,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Visited Scenes'),
                    Tab(text: 'Wishlist'),
                  ],
                ),
              ),
              
              // Tab Content
              SizedBox(
                height: 400, // Adjust height as needed
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Visited Scenes Tab
                    _buildVisitedScenesTab(),
                    // Wishlist Tab
                    _buildWishlistTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new scene visit
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add_location_alt, color: Colors.white),
      ),
    );
  }
  
  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: FaIcon(icon, size: 20, color: color),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        backgroundColor: Colors.grey[100],
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
  
  Widget _buildVisitedScenesTab() {
    if (_visitedScenes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No visited scenes yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Start exploring movie locations and check-in when you visit them!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _visitedScenes.length,
      itemBuilder: (context, index) {
        final scene = _visitedScenes[index];
        return _buildSceneCard(scene);
      },
    );
  }
  
  Widget _buildWishlistTab() {
    if (_wishlist.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Your wishlist is empty',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Save movie locations you want to visit in the future',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _wishlist.length,
      itemBuilder: (context, index) {
        final item = _wishlist[index];
        return _buildWishlistItem(item);
      },
    );
  }
  
  Widget _buildSceneCard(Map<String, dynamic> scene) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Scene Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              scene['image'],
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // Scene Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        scene['movie'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.favorite,
                            size: 16,
                            color: scene['isLiked']
                                ? Colors.red
                                : Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          scene['likes'].toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        scene['location'],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      scene['date'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share, size: 18),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, size: 18),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWishlistItem(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Movie Scene Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Movie Title and Location
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['movie'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item['location'],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
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
    );
  }
  
  void _shareOnSocial(String platform) {
    // Implement social sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing to $platform... (demo)'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  void _showShareOptions() {
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
            children: [
              const Text(
                'Share Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareOption(
                    icon: Icons.message,
                    label: 'Message',
                    onTap: () {
                      Navigator.pop(context);
                      _shareOnSocial('message');
                    },
                  ),
                  _buildShareOption(
                    icon: Icons.mail_outline,
                    label: 'Email',
                    onTap: () {
                      Navigator.pop(context);
                      _shareOnSocial('email');
                    },
                  ),
                  _buildShareOption(
                    icon: Icons.copy,
                    label: 'Copy Link',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Link copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.grey[800]),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
