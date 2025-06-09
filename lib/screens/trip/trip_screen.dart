import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cina/core/theme/app_colors.dart';
import 'package:cina/core/theme/app_theme.dart';
import 'dart:math';

class BoardList {
  String id;
  String title;
  List<BoardItem> items;

  BoardList({
    required this.id,
    required this.title,
    this.items = const [],
  });
}

class BoardItem {
  final String id;
  String title;
  String subtitle;
  String progress;

  BoardItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
  });
}

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _showNewTripDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Trip'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Trip Name',
                hintText: 'e.g., Summer Vacation 2023',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Destination',
                hintText: 'Where are you going?',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      // Show date picker
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );
                      // Handle selected date
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text('to', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      // Show date picker
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );
                      // Handle selected date
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle create trip
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Create Trip', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
        ),
        title: const Text(
          'My Trips',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                _showNewTripDialog(context);
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                });
              },
              tabs: const [
                Tab(
                  text: 'Board',
                  height: 36,
                ),
                Tab(
                  text: 'Calendar',
                  height: 36,
                ),
              ],
              indicatorColor: Colors.white,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.0,
                  color: Colors.white,
                ),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.0,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 180),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: const [
            _BoardView(),
            _CalendarView(),
          ],
        ),
      ),
    );
  }
}

class _CalendarView extends StatefulWidget {
  const _CalendarView();

  @override
  State<_CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<_CalendarView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  Map<DateTime, List<Map<String, dynamic>>> _events = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadEvents();
  }

  void _loadEvents() {
    // Mock events - in a real app, this would come from a database
    final today = DateTime.now();
    setState(() {
      _events = {
        today: [
          {
            'title': 'Visit Central Park',
            'time': '10:00 AM',
            'location': 'New York, NY',
            'color': Colors.blue,
          },
        ],
        today.add(const Duration(days: 1)): [
          {
            'title': 'Empire State Building',
            'time': '02:30 PM',
            'location': 'New York, NY',
            'color': Colors.orange,
          },
        ],
        today.add(const Duration(days: 3)): [
          {
            'title': 'Broadway Show',
            'time': '07:00 PM',
            'location': 'New York, NY',
            'color': Colors.purple,
          },
        ],
      };
    });
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Calendar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.primary),
              rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
              formatButtonDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              formatButtonTextStyle: const TextStyle(color: Colors.white),
            ),
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(fontSize: 14, color: Colors.black87),
              weekendTextStyle: const TextStyle(color: Colors.black87),
              outsideTextStyle: TextStyle(color: Colors.grey[400]),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
              todayTextStyle: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
              markerSize: 4.0,
              markerMargin: const EdgeInsets.symmetric(horizontal: 1.0),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final dayEvents = _getEventsForDay(date);
                if (dayEvents.isEmpty) return null;
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dayEvents.first['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Selected Day Events
        Text(
          '${_selectedDay?.day} ${_getMonthName(_selectedDay?.month ?? DateTime.now().month)} ${_selectedDay?.year}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ..._buildEventList(),
        if (_getEventsForDay(_selectedDay ?? DateTime.now()).isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                Icon(
                  Icons.event_available_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No events scheduled',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  List<Widget> _buildEventList() {
    final events = _getEventsForDay(_selectedDay ?? DateTime.now());
    if (events.isEmpty) return [];
    
    return List<Widget>.generate(events.length, (index) {
      final event = events[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: _buildEventItem(
          title: event['title'],
          time: event['time'],
          location: event['location'],
          color: event['color'],
        ),
      );
    });
  }

  Widget _buildEventItem({
    required String title,
    required String time,
    required String location,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(time, style: AppTheme.bodySmall),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(location, style: AppTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {
              // Show options
            },
          ),
        ],
      ),
    );
  }
}

class _BoardView extends StatefulWidget {
  const _BoardView();

  @override
  State<_BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<_BoardView> {
  final List<BoardList> _boardLists = [
    BoardList(
      id: '1',
      title: 'To Visit',
      items: [
        BoardItem(
          id: '1',
          title: 'Central Park',
          subtitle: 'From: Home Alone 2',
          progress: '0/3 locations',
        ),
        BoardItem(
          id: '2',
          title: 'Empire State Building',
          subtitle: 'From: Sleepless in Seattle',
          progress: '0/2 locations',
        ),
      ],
    ),
    BoardList(
      id: '2',
      title: 'Booked',
      items: [
        BoardItem(
          id: '3',
          title: 'The Plaza Hotel',
          subtitle: 'From: Home Alone 2',
          progress: '1/1 location',
        ),
      ],
    ),
    BoardList(
      id: '3',
      title: 'Completed',
      items: [
        BoardItem(
          id: '4',
          title: 'Times Square',
          subtitle: 'From: Vanilla Sky',
          progress: '3/3 locations',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and add button
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Movie Scenes Board',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: _showAddNewListDialog,
                ),
              ],
            ),
          ),
          
          // Board lists
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _boardLists.length + 1, // +1 for the "Add List" button
              itemBuilder: (context, index) {
                if (index == _boardLists.length) {
                  return _buildAddListButton();
                }
                return _buildBoardList(_boardLists[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardList(BoardList list) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // List header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  list.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  '${list.items.length} items',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit List'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete List'),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      _deleteList(list.id);
                    } else if (value == 'edit') {
                      _editListTitle(list);
                    }
                  },
                ),
              ],
            ),
          ),
          
          // List items
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ReorderableListView.builder(
                itemCount: list.items.length,
                itemBuilder: (context, index) {
                  final item = list.items[index];
                  return _buildBoardItem(item, list);
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = list.items.removeAt(oldIndex);
                    list.items.insert(newIndex, item);
                  });
                },
              ),
            ),
          ),
          
          // Add item button
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              onPressed: () => _showAddNewItemDialog(list.id),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add a card'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardItem(BoardItem item, BoardList list) {
    return Card(
      key: ValueKey(item.id),
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        title: Text(item.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.subtitle, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: _calculateProgress(item.progress),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                _calculateProgress(item.progress) == 1.0 
                    ? Colors.green 
                    : Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.progress,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
            const PopupMenuItem(
              value: 'move',
              child: Text('Move to...'),
            ),
          ],
          onSelected: (value) {
            if (value == 'delete') {
              _deleteItem(list.id, item.id);
            } else if (value == 'edit') {
              _editItem(list, item);
            } else if (value == 'move') {
              _showMoveDialog(list.id, item);
            }
          },
        ),
      ),
    );
  }

  Widget _buildAddListButton() {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: TextButton.icon(
        onPressed: _showAddNewListDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add another list'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey[700],
          backgroundColor: Colors.grey[100],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  double _calculateProgress(String progress) {
    try {
      final parts = progress.split('/');
      if (parts.length == 2) {
        final current = int.tryParse(parts[0]) ?? 0;
        final total = int.tryParse(parts[1]) ?? 1;
        return total > 0 ? current / total : 0.0;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  void _showAddNewListDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New List'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'List Title',
            hintText: 'e.g., Wishlist',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _boardLists.add(
                    BoardList(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: controller.text.trim(),
                      items: [],
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editListTitle(BoardList list) {
    final controller = TextEditingController(text: list.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit List Title'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'List Title',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  list.title = controller.text.trim();
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteList(String listId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete List'),
        content: const Text('Are you sure you want to delete this list and all its items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _boardLists.removeWhere((list) => list.id == listId);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddNewItemDialog(String listId) {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final progressController = TextEditingController(text: '0/1');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Central Park',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                  hintText: 'e.g., From: Home Alone 2',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: progressController,
                decoration: const InputDecoration(
                  labelText: 'Progress (e.g., 1/3)',
                  hintText: 'e.g., 1/3',
                ),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  final list = _boardLists.firstWhere((list) => list.id == listId);
                  list.items.add(
                    BoardItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text.trim(),
                      subtitle: subtitleController.text.trim(),
                      progress: progressController.text.trim(),
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editItem(BoardList list, BoardItem item) {
    final titleController = TextEditingController(text: item.title);
    final subtitleController = TextEditingController(text: item.subtitle);
    final progressController = TextEditingController(text: item.progress);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: progressController,
                decoration: const InputDecoration(
                  labelText: 'Progress (e.g., 1/3)',
                ),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                setState(() {
                  final itemIndex = list.items.indexWhere((i) => i.id == item.id);
                  if (itemIndex != -1) {
                    list.items[itemIndex] = BoardItem(
                      id: item.id,
                      title: titleController.text.trim(),
                      subtitle: subtitleController.text.trim(),
                      progress: progressController.text.trim(),
                    );
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(String listId, String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final list = _boardLists.firstWhere((list) => list.id == listId);
                list.items.removeWhere((item) => item.id == itemId);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showMoveDialog(String currentListId, BoardItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move to List'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _boardLists.length,
            itemBuilder: (context, index) {
              final list = _boardLists[index];
              if (list.id == currentListId) {
                return const SizedBox.shrink();
              }
              return ListTile(
                title: Text(list.title),
                onTap: () {
                  _moveItem(currentListId, list.id, item);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _moveItem(String fromListId, String toListId, BoardItem item) {
    setState(() {
      // Remove from current list
      final fromList = _boardLists.firstWhere((list) => list.id == fromListId);
      fromList.items.removeWhere((i) => i.id == item.id);
      
      // Add to new list
      final toList = _boardLists.firstWhere((list) => list.id == toListId);
      toList.items.add(item);
    });
  }
}
