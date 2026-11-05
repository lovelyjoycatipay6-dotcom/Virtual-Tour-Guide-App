import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_destinations.dart';
import '../models/trip.dart';

class AppState extends ChangeNotifier {
  AppState._(this._preferences)
      : _savedIds = <String>{},
        _trips = <Trip>[],
        name = 'Alex Morgan',
        email = 'alex.morgan@email.com',
        language = 'English',
        currency = 'PHP (₱)',
        notificationsEnabled = true;

  final SharedPreferences _preferences;
  final Set<String> _savedIds;
  final List<Trip> _trips;
  String name;
  String email;
  String language;
  String currency;
  bool notificationsEnabled;

  static Future<AppState> load() async {
    final preferences = await SharedPreferences.getInstance();
    final savedIds = preferences.getStringList('saved_destination_ids') ?? [];
    final rawTrips = preferences.getString('trips');
    final trips = rawTrips == null
        ? <Trip>[]
        : (jsonDecode(rawTrips) as List<dynamic>)
            .map((item) => Trip.fromJson(item as Map<String, dynamic>))
            .toList();
    return AppState._(preferences)
      .._savedIds.addAll(savedIds.where(
        (id) => sampleDestinations.any((destination) => destination.id == id),
      ))
      .._trips.addAll(trips)
      ..name = preferences.getString('profile_name') ?? 'Alex Morgan'
      ..email = preferences.getString('profile_email') ?? 'alex.morgan@email.com'
      ..language = preferences.getString('language') ?? 'English'
      ..currency = preferences.getString('currency') ?? 'PHP (₱)'
      ..notificationsEnabled =
          preferences.getBool('notifications_enabled') ?? true;
  }

  Set<String> get savedIds => Set.unmodifiable(_savedIds);
  List<Trip> get trips => List.unmodifiable(_trips);

  bool isSaved(String destinationId) => _savedIds.contains(destinationId);

  Future<void> toggleSaved(String destinationId) async {
    if (!_savedIds.add(destinationId)) _savedIds.remove(destinationId);
    await _writeStringList('saved_destination_ids', _savedIds.toList());
    notifyListeners();
  }

  Future<void> saveTrip(Trip trip) async {
    final index = _trips.indexWhere((item) => item.id == trip.id);
    if (index == -1) {
      _trips.add(trip);
    } else {
      _trips[index] = trip;
    }
    await _persistTrips();
    notifyListeners();
  }

  Future<void> updateTripStatus(String id, String status) async {
    final index = _trips.indexWhere((trip) => trip.id == id);
    if (index == -1) return;
    _trips[index] = _trips[index].copyWith(status: status);
    await _persistTrips();
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    _ensureWritten(await _preferences.setString('profile_name', name));
    _ensureWritten(await _preferences.setString('profile_email', email));
    this.name = name;
    this.email = email;
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _ensureWritten(await _preferences.setString('language', value));
    language = value;
    notifyListeners();
  }

  Future<void> setCurrency(String value) async {
    _ensureWritten(await _preferences.setString('currency', value));
    currency = value;
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _ensureWritten(
      await _preferences.setBool('notifications_enabled', value),
    );
    notificationsEnabled = value;
    notifyListeners();
  }

  Future<void> _persistTrips() async {
    final encoded = jsonEncode(_trips.map((trip) => trip.toJson()).toList());
    _ensureWritten(await _preferences.setString('trips', encoded));
  }

  Future<void> _writeStringList(String key, List<String> values) async {
    _ensureWritten(await _preferences.setStringList(key, values));
  }

  void _ensureWritten(bool written) {
    if (!written) throw StateError('Could not save your changes on this device.');
  }
}
