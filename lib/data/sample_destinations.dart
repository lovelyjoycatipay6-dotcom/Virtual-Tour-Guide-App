import '../models/destination.dart';

const sampleDestinations = <Destination>[
  Destination(
    id: 'tokyo',
    name: 'Tokyo',
    country: 'Japan',
    description:
        'A city of contrasts, where peaceful temples meet neon-lit streets and world-class food.',
    imageUrl:
        'https://images.unsplash.com/photo-1513407030348-c983a97b98d8?auto=format&fit=crop&w=1200&q=85',
    temperature: '24°C',
    weather: 'Partly cloudy',
    localTime: '10:35 AM',
    currency: 'JPY ¥',
    bestTime: 'March – May',
    category: 'Culture',
    address: 'Tokyo, Japan',
    attractions: [
      Attraction(
        name: 'Shibuya Crossing',
        category: 'City landmark',
        description: 'Feel the energy at one of the world’s busiest crossings.',
        icon: '🚦',
      ),
      Attraction(
        name: 'Senso-ji Temple',
        category: 'Historic place',
        description: 'Explore Tokyo’s oldest temple in historic Asakusa.',
        icon: '⛩️',
      ),
      Attraction(
        name: 'Tokyo Tower',
        category: 'Viewpoint',
        description: 'Take in panoramic views across the city.',
        icon: '🗼',
      ),
    ],
  ),
  Destination(
    id: 'paris',
    name: 'Paris',
    country: 'France',
    description:
        'Art, architecture and cafe culture come together in the City of Light.',
    imageUrl:
        'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?auto=format&fit=crop&w=1200&q=85',
    temperature: '19°C',
    weather: 'Light breeze',
    localTime: '3:35 AM',
    currency: 'EUR €',
    bestTime: 'April – June',
    category: 'Popular',
    address: 'Paris, France',
    attractions: [
      Attraction(
        name: 'Eiffel Tower',
        category: 'City landmark',
        description: 'See the city from its most iconic landmark.',
        icon: '🗼',
      ),
      Attraction(
        name: 'Louvre Museum',
        category: 'Museum',
        description: 'Discover centuries of art and culture.',
        icon: '🖼️',
      ),
      Attraction(
        name: 'Montmartre',
        category: 'Neighborhood',
        description: 'Wander charming lanes and artist squares.',
        icon: '🎨',
      ),
    ],
  ),
  Destination(
    id: 'cebu',
    name: 'Cebu',
    country: 'Philippines',
    description:
        'Find turquoise waters, island adventures and warm Cebuano hospitality.',
    imageUrl:
        'https://images.unsplash.com/photo-1518509562904-e7ef99cdcc86?auto=format&fit=crop&w=1200&q=85',
    temperature: '30°C',
    weather: 'Sunny',
    localTime: '9:35 AM',
    currency: 'PHP ₱',
    bestTime: 'December – May',
    category: 'Beaches',
    address: 'Cebu, Philippines',
    attractions: [
      Attraction(
        name: 'Kawasan Falls',
        category: 'Nature',
        description: 'Swim in clear blue pools beneath tropical waterfalls.',
        icon: '💧',
      ),
      Attraction(
        name: 'Magellan’s Cross',
        category: 'Historic place',
        description: 'Visit a landmark from Cebu’s early history.',
        icon: '✝️',
      ),
      Attraction(
        name: 'Mactan Island',
        category: 'Beach',
        description: 'Enjoy island beaches and snorkeling.',
        icon: '🏝️',
      ),
    ],
  ),
  Destination(
    id: 'rome',
    name: 'Rome',
    country: 'Italy',
    description:
        'Walk through layers of history, lively piazzas and unforgettable cuisine.',
    imageUrl:
        'https://images.unsplash.com/photo-1552832230-c0197dd311b5?auto=format&fit=crop&w=1200&q=85',
    temperature: '22°C',
    weather: 'Mostly sunny',
    localTime: '3:35 AM',
    currency: 'EUR €',
    bestTime: 'April – June',
    category: 'History',
    address: 'Rome, Italy',
    attractions: [
      Attraction(
        name: 'Colosseum',
        category: 'Historic place',
        description: 'Step into the story of ancient Rome.',
        icon: '🏛️',
      ),
      Attraction(
        name: 'Trevi Fountain',
        category: 'City landmark',
        description: 'Visit the ornate fountain in the heart of Rome.',
        icon: '⛲',
      ),
      Attraction(
        name: 'Villa Borghese',
        category: 'Nature',
        description: 'Take a relaxing walk through the city gardens.',
        icon: '🌳',
      ),
    ],
  ),
  Destination(
    id: 'bali',
    name: 'Bali',
    country: 'Indonesia',
    description:
        'A restorative island escape filled with lush landscapes and vibrant traditions.',
    imageUrl:
        'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1200&q=85',
    temperature: '29°C',
    weather: 'Tropical',
    localTime: '9:35 AM',
    currency: 'IDR Rp',
    bestTime: 'May – September',
    category: 'Beaches',
    address: 'Bali, Indonesia',
    attractions: [
      Attraction(
        name: 'Uluwatu Temple',
        category: 'Cultural attraction',
        description: 'Watch the sunset from a clifftop temple.',
        icon: '🛕',
      ),
      Attraction(
        name: 'Tegallalang Rice Terraces',
        category: 'Nature',
        description: 'Walk among Bali’s famous green rice fields.',
        icon: '🌾',
      ),
      Attraction(
        name: 'Sanur Beach',
        category: 'Beach',
        description: 'Enjoy calm waters and a relaxed seaside promenade.',
        icon: '🌊',
      ),
    ],
  ),
  Destination(
    id: 'seoul',
    name: 'Seoul',
    country: 'South Korea',
    description:
        'A dynamic capital with historic palaces, creative neighborhoods and late-night eats.',
    imageUrl:
        'https://images.unsplash.com/photo-1517154421773-0529f29ea451?auto=format&fit=crop&w=1200&q=85',
    temperature: '21°C',
    weather: 'Clear',
    localTime: '10:35 AM',
    currency: 'KRW ₩',
    bestTime: 'September – November',
    category: 'Culture',
    address: 'Seoul, South Korea',
    attractions: [
      Attraction(
        name: 'Gyeongbokgung Palace',
        category: 'Historic place',
        description: 'Explore Korea’s grand royal palace.',
        icon: '🏯',
      ),
      Attraction(
        name: 'N Seoul Tower',
        category: 'Viewpoint',
        description: 'See Seoul from above at Namsan.',
        icon: '🌆',
      ),
      Attraction(
        name: 'Bukchon Hanok Village',
        category: 'Cultural attraction',
        description: 'Walk historic lanes lined with traditional homes.',
        icon: '🏘️',
      ),
    ],
  ),
];
