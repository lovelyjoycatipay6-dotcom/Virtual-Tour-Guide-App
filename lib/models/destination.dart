class Attraction {
  const Attraction({
    required this.name,
    required this.category,
    required this.description,
    required this.icon,
  });

  final String name;
  final String category;
  final String description;
  final String icon;
}

class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.description,
    required this.imageUrl,
    required this.temperature,
    required this.weather,
    required this.localTime,
    required this.currency,
    required this.bestTime,
    required this.attractions,
    required this.category,
    required this.address,
  });

  final String id;
  final String name;
  final String country;
  final String description;
  final String imageUrl;
  final String temperature;
  final String weather;
  final String localTime;
  final String currency;
  final String bestTime;
  final List<Attraction> attractions;
  final String category;
  final String address;
}
