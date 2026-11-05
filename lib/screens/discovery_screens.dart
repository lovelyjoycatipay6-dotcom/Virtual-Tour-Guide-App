import 'package:flutter/material.dart';

import '../data/sample_destinations.dart';
import '../models/destination.dart';
import '../models/trip.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    required this.state,
    required this.onOpenDestination,
    super.key,
  });

  final AppState state;
  final ValueChanged<Destination> onOpenDestination;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _category = 'All';
  static const _categories = [
    'All',
    'History',
    'Nature',
    'Beaches',
    'Culture',
    'Popular',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim().toLowerCase();
    final results = sampleDestinations.where((destination) {
      final matchesQuery =
          query.isEmpty ||
          destination.name.toLowerCase().contains(query) ||
          destination.country.toLowerCase().contains(query) ||
          destination.attractions.any(
            (attraction) => attraction.name.toLowerCase().contains(query),
          );
      final matchesCategory =
          _category == 'All' || destination.category == _category;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Explore places'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: TextField(
              controller: _controller,
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search destinations or attractions',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final selected = category == _category;
                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) => setState(() => _category = category),
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: results.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No places found',
                    message:
                        'Try another destination, country or attraction name.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 24),
                    itemCount: results.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _SearchResult(
                      destination: results[index],
                      state: widget.state,
                      onTap: () => widget.onOpenDestination(results[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SearchResult extends StatelessWidget {
  const _SearchResult({
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
            height: 86,
            width: 88,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destination.country,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
                const SizedBox(height: 7),
                Text(
                  destination.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListenableBuilder(
          listenable: state,
          builder: (context, _) => IconButton(
            tooltip: state.isSaved(destination.id)
                ? 'Remove from saved'
                : 'Save destination',
            onPressed: () => _run(context, state.toggleSaved(destination.id)),
            icon: Icon(
              state.isSaved(destination.id)
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    ),
  );
}

class DestinationDetailsScreen extends StatelessWidget {
  const DestinationDetailsScreen({
    required this.state,
    required this.destination,
    super.key,
  });
  final AppState state;
  final Destination destination;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 330,
          pinned: true,
          leading: _roundIconButton(
            context,
            Icons.arrow_back_rounded,
            () => Navigator.pop(context),
          ),
          actions: [
            ListenableBuilder(
              listenable: state,
              builder: (context, _) => _roundIconButton(
                context,
                state.isSaved(destination.id)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                () => _run(context, state.toggleSaved(destination.id)),
                color: state.isSaved(destination.id)
                    ? AppColors.primary
                    : AppColors.text,
              ),
            ),
            const SizedBox(width: 10),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                DestinationImage(destination: destination, borderRadius: 0),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black26,
                        Colors.transparent,
                        Colors.black87,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 22,
                  right: 22,
                  bottom: 25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label(destination.category.toUpperCase()),
                      const SizedBox(height: 9),
                      Text(
                        destination.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.place_rounded,
                            color: Colors.white,
                            size: 17,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            destination.country,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 21, 20, 24),
          sliver: SliverList.list(
            children: [
              Text(
                destination.description,
                style: const TextStyle(
                  color: AppColors.muted,
                  height: 1.55,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 19),
              Row(
                children: [
                  Expanded(
                    child: _FactCard(
                      icon: Icons.wb_sunny_rounded,
                      title: destination.temperature,
                      subtitle: destination.weather,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: _FactCard(
                      icon: Icons.schedule_rounded,
                      title: destination.localTime,
                      subtitle: 'Local time',
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: _FactCard(
                      icon: Icons.currency_exchange_rounded,
                      title: destination.currency,
                      subtitle: 'Currency',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SectionTitle('About ${destination.name}'),
              const SizedBox(height: 7),
              const Text(
                'Discover local stories, take your time wandering, and leave room for an unexpected favorite. Use this guide to make your visit feel a little more like your own.',
                style: TextStyle(
                  color: AppColors.muted,
                  height: 1.55,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 21),
              Row(
                children: [
                  Expanded(
                    child: _InfoTile(
                      icon: Icons.calendar_month_rounded,
                      title: 'Best time to visit',
                      value: destination.bestTime,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: _InfoTile(
                      icon: Icons.place_outlined,
                      title: 'Location',
                      value: destination.address,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 23),
              SectionTitle(
                'Must-see attractions',
                action: 'View map',
                onAction: () => _openMap(context, destination),
              ),
              const SizedBox(height: 10),
              ...destination.attractions.map(
                (attraction) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _AttractionTile(attraction: attraction),
                ),
              ),
              const SizedBox(height: 8),
              AppSurface(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        'Travel tip: Keep a little local currency handy for small shops and transit.',
                        style: TextStyle(
                          color: AppColors.darkPurple,
                          height: 1.4,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () => _openMap(context, destination),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(54, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Icon(Icons.map_outlined),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PrimaryButton(
                label: 'Start My Journey',
                icon: Icons.flight_takeoff_rounded,
                onPressed: () => startPlan(context, state, destination),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _FactCard extends StatelessWidget {
  const _FactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        Icon(icon, size: 19, color: AppColors.primary),
        const SizedBox(height: 7),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.muted, fontSize: 10),
        ),
      ],
    ),
  );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => AppSurface(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 19),
        const SizedBox(height: 9),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        ),
      ],
    ),
  );
}

class _AttractionTile extends StatelessWidget {
  const _AttractionTile({required this.attraction});
  final Attraction attraction;

  @override
  Widget build(BuildContext context) => AppSurface(
    padding: const EdgeInsets.all(13),
    child: Row(
      children: [
        Text(attraction.icon, style: const TextStyle(fontSize: 25)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                attraction.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                attraction.description,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class TravelPlanScreen extends StatefulWidget {
  const TravelPlanScreen({
    required this.state,
    required this.destination,
    this.initialTrip,
    super.key,
  });
  final AppState state;
  final Destination destination;
  final Trip? initialTrip;

  @override
  State<TravelPlanScreen> createState() => _TravelPlanScreenState();
}

class _TravelPlanScreenState extends State<TravelPlanScreen> {
  late final TextEditingController _locationController;
  late DateTimeRange _dates;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final tomorrow = DateUtils.dateOnly(DateTime.now())
        .add(const Duration(days: 1));
    final trip = widget.initialTrip;
    _dates = DateTimeRange(
      start: trip?.startDate ?? tomorrow,
      end: trip?.endDate ?? tomorrow.add(const Duration(days: 3)),
    );
    _locationController = TextEditingController(
      text: trip?.startingPoint ?? 'Central, Quezon City',
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.initialTrip == null ? 'Plan your trip' : 'Edit trip'),
      backgroundColor: AppColors.background,
    ),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 30),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                DestinationImage(
                  destination: widget.destination,
                  height: 190,
                  width: double.infinity,
                  borderRadius: 20,
                ),
                Positioned(
                  left: 15,
                  bottom: 14,
                  child: _label(
                    '${widget.destination.name}, ${widget.destination.country}',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 23),
          Text(
            'When are you going?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          AppSurface(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    _dateRange(_dates.start, _dates.end),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton(
                  onPressed: _chooseDates,
                  child: const Text('Change'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Where are you starting?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _locationController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Starting address',
              hintText: 'City, neighborhood or address',
              prefixIcon: const Icon(Icons.location_on_outlined),
              suffixIcon: IconButton(
                tooltip: 'Pick a location on map',
                onPressed: _pickLocation,
                icon: const Icon(Icons.map_outlined),
              ),
            ),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Enter a starting point'
                : null,
          ),
          const SizedBox(height: 21),
          Text(
            'Your travel notes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          AppSurface(
            child: Column(
              children: [
                _ReviewRow(
                  icon: Icons.place_rounded,
                  title: 'Destination',
                  value: widget.destination.address,
                ),
                const Divider(height: 20),
                _ReviewRow(
                  icon: Icons.wb_sunny_rounded,
                  title: 'Weather snapshot',
                  value:
                      '${widget.destination.temperature}, ${widget.destination.weather}',
                ),
                const Divider(height: 20),
                _ReviewRow(
                  icon: Icons.lightbulb_outline_rounded,
                  title: 'Offline-ready guide',
                  value: 'Attractions and key travel details are saved in-app',
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          PrimaryButton(
            label: _saving
                ? 'Saving your plan...'
                : widget.initialTrip == null
                ? 'Start My Journey'
                : 'Save changes',
            icon: Icons.flight_takeoff_rounded,
            onPressed: _saving ? null : _savePlan,
          ),
        ],
      ),
    ),
  );

  Future<void> _chooseDates() async {
    final now = DateUtils.dateOnly(DateTime.now());
    final dates = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 3),
      initialDateRange: _dates.start.isBefore(now)
          ? DateTimeRange(start: now, end: now.add(const Duration(days: 3)))
          : _dates,
      builder: (context, child) => Theme(
        data: Theme.of(context)
            .copyWith(colorScheme: Theme.of(context).colorScheme),
        child: child!,
      ),
    );
    if (dates != null) setState(() => _dates = dates);
  }

  Future<void> _pickLocation() async {
    final location = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose a starting point'),
        children: [
          for (final value in const [
            'Central, Quezon City',
            'Manila City Hall, Manila',
            'Mactan-Cebu International Airport',
          ])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, value),
              child: Text(value),
            ),
        ],
      ),
    );
    if (location != null) _locationController.text = location;
  }

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final original = widget.initialTrip;
    final trip = Trip(
      id: original?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      destinationId: widget.destination.id,
      startingPoint: _locationController.text.trim(),
      startDate: _dates.start,
      endDate: _dates.end,
      status: original?.status ?? 'upcoming',
    );
    try {
      await widget.state.saveTrip(trip);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your travel plan is saved on this device.'),
        ),
      );
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save your travel plan: $error')),
      );
    }
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.icon,
    required this.title,
    required this.value,
  });
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: AppColors.primary, size: 19),
      const SizedBox(width: 11),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: AppColors.muted, fontSize: 11),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    ],
  );
}

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({
    required this.state,
    required this.trip,
    required this.destination,
    super.key,
  });
  final AppState state;
  final Trip trip;
  final Destination destination;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Trip details'),
      backgroundColor: AppColors.background,
      actions: [
        if (trip.status == 'upcoming')
          IconButton(
            tooltip: 'Edit trip',
            onPressed: () =>
                startPlan(context, state, destination, initialTrip: trip),
            icon: const Icon(Icons.edit_outlined),
          ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      children: [
        DestinationImage(
          destination: destination,
          height: 220,
          width: double.infinity,
          borderRadius: 22,
        ),
        const SizedBox(height: 20),
        Text(
          '${destination.name}, ${destination.country}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        _StatusBadge(status: trip.status),
        const SizedBox(height: 20),
        AppSurface(
          child: Column(
            children: [
              _ReviewRow(
                icon: Icons.calendar_month_rounded,
                title: 'Travel dates',
                value: _dateRange(trip.startDate, trip.endDate),
              ),
              const Divider(height: 24),
              _ReviewRow(
                icon: Icons.location_on_outlined,
                title: 'Starting point',
                value: trip.startingPoint,
              ),
              const Divider(height: 24),
              _ReviewRow(
                icon: Icons.wb_sunny_rounded,
                title: 'Weather',
                value: '${destination.temperature}, ${destination.weather}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        SectionTitle('Your guide highlights'),
        const SizedBox(height: 9),
        ...destination.attractions.map(
          (attraction) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _AttractionTile(attraction: attraction),
          ),
        ),
        if (trip.status == 'upcoming') ...[
          const SizedBox(height: 10),
          PrimaryButton(
            label: 'Mark as completed',
            icon: Icons.check_circle_outline_rounded,
            onPressed: () => _completeTrip(context),
          ),
          const SizedBox(height: 9),
          OutlinedButton.icon(
            onPressed: () => _confirmCancel(context),
            icon: const Icon(Icons.event_busy_rounded),
            label: const Text('Cancel trip'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ],
      ],
    ),
  );

  Future<void> _completeTrip(BuildContext context) async {
    try {
      await state.updateTripStatus(trip.id, 'past');
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip moved to Past trips.')),
      );
    } on Object catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update this trip: $error')),
      );
    }
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this trip?'),
        content: const Text(
          'Your plan will move to Cancelled trips. You can still view its details later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep trip'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel trip'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await state.updateTripStatus(trip.id, 'cancelled');
      if (!context.mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip moved to Cancelled trips.')),
      );
    } on Object catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not cancel this trip: $error')),
      );
    }
  }
}

class MockMapScreen extends StatelessWidget {
  const MockMapScreen({required this.destination, super.key});
  final Destination destination;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('${destination.name} map'),
      backgroundColor: AppColors.background,
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(18, 5, 18, 25),
      children: [
        Container(
          height: 340,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [Color(0xFFEDE9F8), Color(0xFFDCEFEA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: _MockMapPainter())),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.primary),
                      const SizedBox(width: 9),
                      Text(
                        destination.address,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
              for (
                var index = 0;
                index < destination.attractions.length;
                index++
              )
                Positioned(
                  left: 35.0 + ((index * 93.0) % 230),
                  top: 114.0 + ((index * 79.0) % 145),
                  child: Tooltip(
                    message: destination.attractions[index].name,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(destination.attractions[index].name),
                          content: Text(
                            destination.attractions[index].description,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkPurple.withValues(
                                alpha: .25,
                              ),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.place_rounded,
                          color: Colors.white,
                          size: 23,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.small(
                  heroTag: 'current-location',
                  onPressed: () => _showMessage(
                    context,
                    'Location permission and a live map provider are not configured.',
                  ),
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.my_location_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 19),
        SectionTitle('Nearby attractions'),
        const SizedBox(height: 9),
        ...destination.attractions.map(
          (attraction) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: _AttractionTile(attraction: attraction),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () => _showMessage(
            context,
            'Live turn-by-turn directions need a configured maps provider.',
          ),
          icon: const Icon(Icons.directions_rounded),
          label: const Text('Get directions'),
        ),
        const SizedBox(height: 6),
        const Text(
          'Map preview for demonstration. Add a Google Maps API key and location permissions to enable live maps and GPS.',
          style: TextStyle(color: AppColors.muted, fontSize: 11, height: 1.4),
        ),
      ],
    ),
  );
}

class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white.withValues(alpha: .9)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final thinRoad = Paint()
      ..color = const Color(0xFFC9D2C9)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final roads = [
      Path()
        ..moveTo(-20, size.height * .65)
        ..cubicTo(70, 180, size.width * .3, 250, size.width + 20, 95),
      Path()
        ..moveTo(size.width * .15, -20)
        ..cubicTo(120, 115, 210, 170, size.width * .55, size.height + 20),
      Path()
        ..moveTo(-10, size.height * .28)
        ..lineTo(size.width + 10, size.height * .72),
    ];
    for (final path in roads) {
      canvas.drawPath(path, road);
      canvas.drawPath(path, thinRoad);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final label = status[0].toUpperCase() + status.substring(1);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

Widget _roundIconButton(
  BuildContext context,
  IconData icon,
  VoidCallback onPressed, {
  Color color = AppColors.text,
}) => Padding(
  padding: const EdgeInsets.only(left: 10),
  child: Material(
    color: Colors.white.withValues(alpha: .94),
    shape: const CircleBorder(),
    child: IconButton(
      tooltip: icon == Icons.arrow_back_rounded ? 'Back' : 'Save destination',
      onPressed: onPressed,
      icon: Icon(icon, color: color),
    ),
  ),
);

Widget _label(String text) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 10,
      letterSpacing: .4,
    ),
  ),
);

Future<void> startPlan(
  BuildContext context,
  AppState state,
  Destination destination, {
  Trip? initialTrip,
}) async {
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => TravelPlanScreen(
        state: state,
        destination: destination,
        initialTrip: initialTrip,
      ),
    ),
  );
}

void _openMap(BuildContext context, Destination destination) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => MockMapScreen(destination: destination),
    ),
  );
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
