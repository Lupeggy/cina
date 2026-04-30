import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../movie_scene/movie_scene_detail_screen.dart';

// ---------------------------------------------------------------------------
// Data model — replace with Supabase fetch in Phase 2
// ---------------------------------------------------------------------------
class MovieLocation {
  final String id;
  final String title;
  final String movie;
  final String location;
  final String imageUrl;
  final double rating;
  final int year;
  final String director;
  final String description;
  final String address;
  final List<String> cast;
  final LatLng coords;

  const MovieLocation({
    required this.id,
    required this.title,
    required this.movie,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.year,
    required this.director,
    required this.description,
    required this.address,
    required this.cast,
    required this.coords,
  });
}

const List<MovieLocation> _mockLocations = [
  MovieLocation(
    id: '1',
    title: 'Batpod Chase',
    movie: 'The Dark Knight',
    location: 'Chicago, IL',
    imageUrl: 'https://images.unsplash.com/photo-1531259736756-6caccf485f81?w=600&q=80',
    rating: 4.8,
    year: 2008,
    director: 'Christopher Nolan',
    description: 'The iconic Batpod chase scene was filmed along LaSalle Street in the heart of Chicago\'s Loop district. Nolan chose Chicago for its brutalist architecture which doubled as Gotham City.',
    address: '200 N LaSalle St, Chicago, IL 60601',
    cast: ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart', 'Michael Caine'],
    coords: LatLng(41.8858, -87.6318),
  ),
  MovieLocation(
    id: '2',
    title: 'Mirror Dimension Fight',
    movie: 'Doctor Strange',
    location: 'New York, NY',
    imageUrl: 'https://images.unsplash.com/photo-1534430480872-3498386e7856?w=600&q=80',
    rating: 4.5,
    year: 2016,
    director: 'Scott Derrickson',
    description: 'The Sanctum Sanctorum exterior was shot at the historic 177A Bleecker Street in Greenwich Village. Fans gather here daily to recreate the iconic door scenes.',
    address: '177A Bleecker St, New York, NY 10012',
    cast: ['Benedict Cumberbatch', 'Tilda Swinton', 'Rachel McAdams'],
    coords: LatLng(40.7302, -74.0007),
  ),
  MovieLocation(
    id: '3',
    title: 'Dream Café',
    movie: 'Inception',
    location: 'Paris, France',
    imageUrl: 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?w=600&q=80',
    rating: 4.9,
    year: 2010,
    director: 'Christopher Nolan',
    description: 'The famous café scene where Ariadne first bends reality was filmed at the Pont de Bir-Hakeim bridge, one of Paris\'s most cinematic locations.',
    address: 'Pont de Bir-Hakeim, 75015 Paris, France',
    cast: ['Leonardo DiCaprio', 'Elliot Page', 'Joseph Gordon-Levitt'],
    coords: LatLng(48.8538, 2.2900),
  ),
  MovieLocation(
    id: '4',
    title: 'Final Battle',
    movie: 'The Avengers',
    location: 'Cleveland, OH',
    imageUrl: 'https://images.unsplash.com/photo-1569025743873-ea3a9ade89f9?w=600&q=80',
    rating: 4.6,
    year: 2012,
    director: 'Joss Whedon',
    description: 'Cleveland\'s East 9th Street was transformed into the battle-scarred streets of New York for the climactic Chitauri invasion.',
    address: 'E 9th St, Cleveland, OH 44114',
    cast: ['Robert Downey Jr.', 'Chris Evans', 'Scarlett Johansson'],
    coords: LatLng(41.4993, -81.6944),
  ),
  MovieLocation(
    id: '5',
    title: 'Spider-Man Rooftop',
    movie: 'Spider-Man: No Way Home',
    location: 'Atlanta, GA',
    imageUrl: 'https://images.unsplash.com/photo-1575917649705-5b59aaa12e6b?w=600&q=80',
    rating: 4.7,
    year: 2021,
    director: 'Jon Watts',
    description: 'Several key rooftop scenes were filmed at Pinewood Atlanta Studios. The surrounding cityscape was used for many exterior shots.',
    address: '461 Sandy Creek Rd, Fayetteville, GA 30214',
    cast: ['Tom Holland', 'Zendaya', 'Benedict Cumberbatch', 'Tobey Maguire'],
    coords: LatLng(33.4484, -84.4341),
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  LatLng? _userLocation;
  MovieLocation? _selectedLocation;
  bool _isLocating = false;

  static const LatLng _defaultCenter = LatLng(40.7128, -74.0060);
  static const double _defaultZoom = 4.5;

  @override
  void initState() {
    super.initState();
    _tryGetLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  Future<void> _tryGetLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      if (!mounted) return;
      setState(() => _userLocation = LatLng(pos.latitude, pos.longitude));
    } catch (_) {}
  }

  Future<void> _goToMyLocation() async {
    setState(() => _isLocating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Location permission denied. Enable it in Settings.'),
            behavior: SnackBarBehavior.floating,
          ));
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      if (!mounted) return;
      setState(() => _userLocation = LatLng(pos.latitude, pos.longitude));
      _animatedMove(LatLng(pos.latitude, pos.longitude), 12);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not get location: $e'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _animatedMove(LatLng dest, double zoom) {
    final camera = _mapController.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: dest.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: dest.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: zoom);
    final controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    final animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.addListener(() {
      _mapController.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
      );
    });
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });
    controller.forward();
  }

  void _onMarkerTap(MovieLocation loc) {
    setState(() => _selectedLocation = loc);
    _animatedMove(loc.coords, 14);
    _sheetController.animateTo(0.38,
        duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
  }

  void _openDetail(MovieLocation loc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieSceneDetailScreen(scene: {
          'title': loc.title,
          'movie': loc.movie,
          'location': loc.location,
          'image': loc.imageUrl,
          'distance': _distanceLabel(loc.coords),
          'rating': loc.rating,
          'year': loc.year.toString(),
          'description': loc.description,
          'address': loc.address,
          'duration': 'N/A',
          'director': loc.director,
          'cast': loc.cast,
        }),
      ),
    );
  }

  String _distanceLabel(LatLng coords) {
    if (_userLocation == null) return 'N/A';
    final metres = const Distance().as(LengthUnit.Meter, _userLocation!, coords);
    if (metres < 1000) return '${metres.round()} m';
    return '${(metres / 1000).toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _defaultCenter,
              initialZoom: _defaultZoom,
              minZoom: 2,
              maxZoom: 18,
              onTap: (_, __) {
                setState(() => _selectedLocation = null);
                _sheetController.animateTo(0.22,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: isDark
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.cina',
                retinaMode: MediaQuery.devicePixelRatioOf(context) > 1.0,
              ),
              if (_userLocation != null)
                MarkerLayer(markers: [
                  Marker(
                    point: _userLocation!,
                    width: 20,
                    height: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2)
                        ],
                      ),
                    ),
                  ),
                ]),
              MarkerLayer(
                markers: _mockLocations.map((loc) {
                  final isSelected = _selectedLocation?.id == loc.id;
                  return Marker(
                    point: loc.coords,
                    width: isSelected ? 52 : 44,
                    height: isSelected ? 52 : 44,
                    child: GestureDetector(
                      onTap: () => _onMarkerTap(loc),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? theme.primaryColor : Colors.white,
                          border: Border.all(
                              color: theme.primaryColor,
                              width: isSelected ? 3 : 2),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor
                                  .withOpacity(isSelected ? 0.5 : 0.2),
                              blurRadius: isSelected ? 12 : 6,
                              spreadRadius: isSelected ? 2 : 0,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: loc.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: theme.primaryColor.withOpacity(0.1),
                              child: Icon(Icons.movie,
                                  size: 20, color: theme.primaryColor),
                            ),
                            errorWidget: (_, __, ___) =>
                                Icon(Icons.movie, size: 20, color: theme.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // ── Search bar ──────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Row(children: [
                const SizedBox(width: 16),
                Icon(Icons.search, color: Colors.grey[500], size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search movie scenes, cities…',
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.tune_rounded,
                      size: 18, color: theme.primaryColor),
                ),
              ]),
            ),
          ),

          // ── Location FAB ────────────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: MediaQuery.of(context).size.height * 0.30,
            child: FloatingActionButton.small(
              heroTag: 'location_fab',
              onPressed: _goToMyLocation,
              backgroundColor: theme.colorScheme.surface,
              elevation: 4,
              child: _isLocating
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: theme.primaryColor))
                  : Icon(Icons.my_location_rounded, color: theme.primaryColor),
            ),
          ),

          // ── Bottom sheet ────────────────────────────────────────────────
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.22,
            minChildSize: 0.12,
            maxChildSize: 0.75,
            snap: true,
            snapSizes: const [0.12, 0.22, 0.38, 0.75],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 20,
                        offset: const Offset(0, -4))
                  ],
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedLocation != null
                                  ? _selectedLocation!.movie
                                  : 'Filming Locations',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_mockLocations.length} spots',
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 8)),
                    if (_selectedLocation != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: _SelectedCard(
                            loc: _selectedLocation!,
                            distance:
                                _distanceLabel(_selectedLocation!.coords),
                            onTap: () => _openDetail(_selectedLocation!),
                          ),
                        ),
                      ),
                    if (_selectedLocation != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                          child: Text(
                            'All locations',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.grey[500],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final loc = _mockLocations[index];
                          return _LocationListTile(
                            loc: loc,
                            isSelected: _selectedLocation?.id == loc.id,
                            distance: _distanceLabel(loc.coords),
                            onTap: () => _onMarkerTap(loc),
                            onDetailTap: () => _openDetail(loc),
                          );
                        },
                        childCount: _mockLocations.length,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Selected card
// ---------------------------------------------------------------------------
class _SelectedCard extends StatelessWidget {
  const _SelectedCard(
      {required this.loc, required this.distance, required this.onTap});
  final MovieLocation loc;
  final String distance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: theme.primaryColor.withOpacity(0.3), width: 1.5),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(14)),
              child: CachedNetworkImage(
                  imageUrl: loc.imageUrl,
                  width: 110,
                  height: 90,
                  fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        loc.movie,
                        style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(loc.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.location_on_outlined,
                          size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(loc.location,
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.star_rounded,
                          size: 13, color: Colors.amber[600]),
                      const SizedBox(width: 3),
                      Text(loc.rating.toString(),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text(distance,
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 11)),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios_rounded,
                          size: 12, color: Colors.grey[400]),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// List tile
// ---------------------------------------------------------------------------
class _LocationListTile extends StatelessWidget {
  const _LocationListTile({
    required this.loc,
    required this.isSelected,
    required this.distance,
    required this.onTap,
    required this.onDetailTap,
  });
  final MovieLocation loc;
  final bool isSelected;
  final String distance;
  final VoidCallback onTap;
  final VoidCallback onDetailTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: theme.primaryColor.withOpacity(0.2))
              : null,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: loc.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: Colors.grey[200], width: 60, height: 60),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.movie, size: 28),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isSelected ? theme.primaryColor : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(loc.movie,
                      style:
                          TextStyle(color: Colors.grey[500], fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.star_rounded,
                        size: 12, color: Colors.amber[600]),
                    const SizedBox(width: 2),
                    Text(loc.rating.toString(),
                        style: const TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Icon(Icons.location_on_outlined,
                        size: 11, color: Colors.grey[400]),
                    const SizedBox(width: 2),
                    Text(distance,
                        style: TextStyle(
                            color: Colors.grey[400], fontSize: 11)),
                  ]),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDetailTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: theme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
