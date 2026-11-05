import 'package:flutter/material.dart';

import '../data/sample_destinations.dart';
import '../models/destination.dart';
import '../models/trip.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'discovery_screens.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.state, required this.onLogout, super.key});
  final AppState state;
  final VoidCallback onLogout;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _tab = 0;

  void _openDestination(Destination destination) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DestinationDetailsScreen(
          state: widget.state,
          destination: destination,
        ),
      ),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SearchScreen(
          state: widget.state,
          onOpenDestination: _openDestination,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/travel-world.png', fit: BoxFit.cover),
        const ColoredBox(color: Color(0xDDF7F4FF)),
        SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _tab,
            children: [
              HomeScreen(
                state: widget.state,
                onSearch: _openSearch,
                onOpenDestination: _openDestination,
                onSelectTab: (tab) => setState(() => _tab = tab),
              ),
              SearchScreen(
                state: widget.state,
                onOpenDestination: _openDestination,
              ),
              SavedScreen(
                state: widget.state,
                onOpenDestination: _openDestination,
                onExplore: () => setState(() => _tab = 0),
              ),
              TripsScreen(
                state: widget.state,
                onOpenDestination: _openDestination,
              ),
              ProfileScreen(state: widget.state, onLogout: widget.onLogout),
            ],
          ),
        ),
      ],
    ),
    bottomNavigationBar: ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) => NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        height: 72,
        backgroundColor: Colors.white.withValues(alpha: .97),
        indicatorColor: AppColors.primary.withValues(alpha: .12),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage_rounded),
            label: 'Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.state,
    required this.onSearch,
    required this.onOpenDestination,
    required this.onSelectTab,
    super.key,
  });

  final AppState state;
  final VoidCallback onSearch;
  final ValueChanged<Destination> onOpenDestination;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) => CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Container(
                  height: 43,
                  width: 43,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.lightPurple],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.explore_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 11),
                const Text(
                  'YGUIDE',
                  style: TextStyle(
                    color: AppColors.darkPurple,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Saved destinations',
                  onPressed: () => onSelectTab(2),
                  icon: const Icon(Icons.favorite_border_rounded),
                ),
                CircleAvatar(
                  radius: 19,
                  backgroundColor: AppColors.primary.withValues(alpha: .12),
                  child: Text(
                    state.name.isEmpty ? 'Y' : state.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${state.name.split(' ').first} 👋',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Where do you want to explore?',
                  style: TextStyle(color: AppColors.muted, fontSize: 15),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: onSearch,
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, color: AppColors.muted),
                        SizedBox(width: 11),
                        Text(
                          'Search places, cities...',
                          style: TextStyle(color: AppColors.muted),
                        ),
                        Spacer(),
                        Icon(Icons.tune_rounded, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                _HeroCard(
                  onTap: () => onOpenDestination(sampleDestinations[0]),
                ),
                const SizedBox(height: 27),
                SectionTitle(
                  'Popular destinations',
                  action: 'See all',
                  onAction: onSearch,
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 230,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              scrollDirection: Axis.horizontal,
              itemCount: sampleDestinations.length,
              separatorBuilder: (_, _) => const SizedBox(width: 13),
              itemBuilder: (context, index) => _DestinationCard(
                destination: sampleDestinations[index],
                state: state,
                onTap: () => onOpenDestination(sampleDestinations[index]),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  'Made for your next trip',
                  action: 'Plan now',
                  onAction: () => onOpenDestination(sampleDestinations[0]),
                ),
                const SizedBox(height: 12),
                AppSurface(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your next story starts here',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Save a place or build your first itinerary.',
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(24),
    child: Container(
      height: 194,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.darkPurple,
            AppColors.primary,
            AppColors.lightPurple,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -25,
            child: Icon(
              Icons.public_rounded,
              size: 190,
              color: Colors.white.withValues(alpha: .1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'YOUR TRAVEL COMPANION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Explore the world,\nyour way.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.08,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Text(
                      'Discover your next destination',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const Spacer(),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.primary,
                        size: 19,
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

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.destination,
    required this.state,
    required this.onTap,
  });

  final Destination destination;
  final AppState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 164,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              DestinationImage(
                destination: destination,
                height: 143,
                width: 164,
                borderRadius: 19,
              ),
              Positioned(
                top: 9,
                right: 9,
                child: _FavoriteButton(destination: destination, state: state),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            destination.name,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 13,
                color: AppColors.primary,
              ),
              const SizedBox(width: 3),
              Text(
                destination.country,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.destination, required this.state});
  final Destination destination;
  final AppState state;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) => Material(
      color: Colors.white.withValues(alpha: .94),
      shape: const CircleBorder(),
      child: IconButton(
        visualDensity: VisualDensity.compact,
        tooltip: state.isSaved(destination.id)
            ? 'Remove from saved'
            : 'Save destination',
        onPressed: () => _run(context, state.toggleSaved(destination.id)),
        icon: Icon(
          state.isSaved(destination.id)
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          color: state.isSaved(destination.id)
              ? AppColors.primary
              : AppColors.text,
          size: 19,
        ),
      ),
    ),
  );
}

class SavedScreen extends StatelessWidget {
  const SavedScreen({
    required this.state,
    required this.onOpenDestination,
    required this.onExplore,
    super.key,
  });

  final AppState state;
  final ValueChanged<Destination> onOpenDestination;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) {
      final destinations = sampleDestinations
          .where((destination) => state.isSaved(destination.id))
          .toList();
      return SafeArea(
        child: Column(
          children: [
            const _PageHeader(
              title: 'Saved places',
              subtitle: 'Your travel wishlist',
            ),
            Expanded(
              child: destinations.isEmpty
                  ? EmptyState(
                      icon: Icons.favorite_border_rounded,
                      title: 'No saved places yet',
                      message: 'Keep the places that inspire you close. Tap the heart on any destination to save it.',
                      action: 'Explore destinations',
                      onAction: onExplore,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 6, 20, 24),
                      itemCount: destinations.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 13),
                      itemBuilder: (context, index) {
                        final destination = destinations[index];
                        return _SavedDestinationTile(
                          destination: destination,
                          state: state,
                          onTap: () => onOpenDestination(destination),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}

class _SavedDestinationTile extends StatelessWidget {
  const _SavedDestinationTile({
    required this.destination,
    required this.state,
    required this.onTap,
  });
  final Destination destination;
  final AppState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppSurface(
    padding: const EdgeInsets.all(10),
    child: Row(
      children: [
        InkWell(
          onTap: onTap,
          child: DestinationImage(
            destination: destination,
            height: 94,
            width: 96,
            borderRadius: 14,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destination.country,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    const Icon(
                      Icons.wb_sunny_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${destination.temperature} · ${destination.weather}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        IconButton(
          tooltip: 'Remove from saved',
          onPressed: () => _run(context, state.toggleSaved(destination.id)),
          icon: const Icon(Icons.favorite_rounded, color: AppColors.primary),
        ),
      ],
    ),
  );
}

class TripsScreen extends StatefulWidget {
  const TripsScreen({
    required this.state,
    required this.onOpenDestination,
    super.key,
  });

  final AppState state;
  final ValueChanged<Destination> onOpenDestination;

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  int _selectedTab = 0;
  static const _statuses = ['upcoming', 'past', 'cancelled'];

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.state,
    builder: (context, _) {
      final trips =
          widget.state.trips
              .where((trip) => trip.status == _statuses[_selectedTab])
              .toList()
            ..sort((a, b) => a.startDate.compareTo(b.startDate));
      return SafeArea(
        child: Column(
          children: [
            const _PageHeader(
              title: 'My trips',
              subtitle: 'All your plans, in one place',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 14),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7FA),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    _tripTab('Upcoming', 0),
                    _tripTab('Past', 1),
                    _tripTab('Cancelled', 2),
                  ],
                ),
              ),
            ),
            Expanded(
              child: trips.isEmpty
                  ? EmptyState(
                      icon: Icons.luggage_outlined,
                      title: _selectedTab == 0
                          ? 'Your next trip is waiting'
                          : 'Nothing here yet',
                      message: _selectedTab == 0
                          ? 'Plan a getaway and your itinerary will show up here.'
                          : 'Trips in this category will appear here.',
                      action: _selectedTab == 0 ? 'Start a travel plan' : null,
                      onAction: _selectedTab == 0
                          ? () => startPlan(
                              context,
                              widget.state,
                              sampleDestinations.first,
                            )
                          : null,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
                      itemCount: trips.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 13),
                      itemBuilder: (context, index) => _TripCard(
                        trip: trips[index],
                        state: widget.state,
                        onOpenDestination: widget.onOpenDestination,
                      ),
                    ),
            ),
          ],
        ),
      );
    },
  );

  Widget _tripTab(String title, int index) => Expanded(
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: _selectedTab == index ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: _selectedTab == index
              ? [
                  BoxShadow(
                    color: AppColors.darkPurple.withValues(alpha: .07),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: _selectedTab == index
                ? AppColors.darkPurple
                : AppColors.muted,
            fontWeight: _selectedTab == index
                ? FontWeight.w800
                : FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    ),
  );
}

class _TripCard extends StatelessWidget {
  const _TripCard({
    required this.trip,
    required this.state,
    required this.onOpenDestination,
  });
  final Trip trip;
  final AppState state;
  final ValueChanged<Destination> onOpenDestination;

  @override
  Widget build(BuildContext context) {
    final destination = sampleDestinations.firstWhere(
      (item) => item.id == trip.destinationId,
      orElse: () => sampleDestinations.first,
    );
    return AppSurface(
      padding: const EdgeInsets.all(11),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TripDetailsScreen(
              state: state,
              trip: trip,
              destination: destination,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DestinationImage(
                  destination: destination,
                  height: 100,
                  width: 102,
                  borderRadius: 14,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${destination.name}, ${destination.country}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        _dateRange(trip.startDate, trip.endDate),
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _StatusBadge(status: trip.status),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
              ],
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    trip.startingPoint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => onOpenDestination(destination),
                  child: const Text('Explore'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final label = status[0].toUpperCase() + status.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: status == 'cancelled'
            ? const Color(0xFFFFEEEE)
            : AppColors.primary.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: status == 'cancelled'
              ? Colors.red.shade700
              : AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.state, required this.onLogout, super.key});
  final AppState state;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) => SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          const _PageHeader(
            title: 'My profile',
            subtitle: 'Make every journey your own',
            padded: false,
          ),
          const SizedBox(height: 17),
          AppSurface(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.primary.withValues(alpha: .12),
                  child: Text(
                    state.name.isEmpty ? 'Y' : state.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.email,
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit profile',
                  onPressed: () => _editProfile(context, state),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'PREFERENCES',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          AppSurface(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _ProfileSetting(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: state.language,
                  onTap: () => _chooseValue(
                    context,
                    title: 'Choose language',
                    values: const ['English', 'Filipino', '日本語', '한국어'],
                    selected: state.language,
                    onSelected: state.setLanguage,
                  ),
                ),
                const Divider(height: 1, indent: 55),
                _ProfileSetting(
                  icon: Icons.currency_exchange_rounded,
                  title: 'Currency',
                  subtitle: state.currency,
                  onTap: () => _chooseValue(
                    context,
                    title: 'Choose currency',
                    values: const ['PHP (₱)', 'USD (\$)', 'EUR (€)', 'JPY (¥)'],
                    selected: state.currency,
                    onSelected: state.setCurrency,
                  ),
                ),
                const Divider(height: 1, indent: 55),
                SwitchListTile(
                  value: state.notificationsEnabled,
                  activeTrackColor: AppColors.primary,
                  secondary: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.primary,
                  ),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Trip reminders and updates'),
                  onChanged: (value) =>
                      _run(context, state.setNotificationsEnabled(value)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'ABOUT',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          AppSurface(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                _ProfileSetting(
                  icon: Icons.support_agent_rounded,
                  title: 'Help & support',
                  onTap: () => _infoDialog(
                    context,
                    'Help & support',
                    'For this demo, trip details and travel guides are stored on your device. Connect a support service when you add a backend.',
                  ),
                ),
                const Divider(height: 1, indent: 55),
                _ProfileSetting(
                  icon: Icons.info_outline_rounded,
                  title: 'About YGUIDE',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _infoDialog(
                    context,
                    'About YGUIDE',
                    'Your thoughtful companion for discovering new places and planning your next journey.',
                  ),
                ),
                const Divider(height: 1, indent: 55),
                _ProfileSetting(
                  icon: Icons.logout_rounded,
                  title: 'Log out',
                  onTap: () => _confirmLogout(context, onLogout),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _confirmLogout(BuildContext context, VoidCallback onLogout) async {
  final shouldLogout =
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Log out?'),
          content: const Text('You will return to the YGUIDE sign-in screen.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Log out'),
            ),
          ],
        ),
      ) ??
      false;
  if (shouldLogout) onLogout();
}

class _ProfileSetting extends StatelessWidget {
  const _ProfileSetting({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Icon(icon, color: AppColors.primary),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
    ),
    subtitle: subtitle == null
        ? null
        : Text(subtitle!, style: const TextStyle(fontSize: 12)),
    trailing: const Icon(Icons.chevron_right_rounded, size: 19),
  );
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.subtitle,
    this.padded = true,
  });

  final String title;
  final String subtitle;
  final bool padded;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padded
        ? const EdgeInsets.fromLTRB(21, 17, 21, 16)
        : EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.muted, fontSize: 13),
        ),
      ],
    ),
  );
}

Future<void> _editProfile(BuildContext context, AppState state) async {
  final nameController = TextEditingController(text: state.name);
  final emailController = TextEditingController(text: state.email);
  final formKey = GlobalKey<FormState>();
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit profile'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full name'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter your name'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email address'),
              validator: (value) =>
                  value == null ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())
                  ? 'Enter a valid email'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            Navigator.pop(context);
            _run(
              context,
              state.updateProfile(
                name: nameController.text.trim(),
                email: emailController.text.trim(),
              ),
            );
          },
          child: const Text('Save changes'),
        ),
      ],
    ),
  );
  nameController.dispose();
  emailController.dispose();
}

Future<void> _chooseValue(
  BuildContext context, {
  required String title,
  required List<String> values,
  required String selected,
  required Future<void> Function(String) onSelected,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
          ),
          ...values.map(
            (value) => ListTile(
              title: Text(value),
              trailing: value == selected
                  ? const Icon(Icons.check_rounded, color: AppColors.primary)
                  : null,
              onTap: () {
                Navigator.pop(context);
                _run(context, onSelected(value));
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

void _infoDialog(BuildContext context, String title, String message) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}

void _run(BuildContext context, Future<void> action) {
  action.catchError((Object error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not save your changes: $error')),
    );
  });
}

String _dateRange(DateTime start, DateTime end) {
  String date(DateTime value) => '${_month(value.month)} ${value.day}';
  return '${date(start)} – ${date(end)}, ${start.year}';
}

String _month(int number) => const [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
][number - 1];
