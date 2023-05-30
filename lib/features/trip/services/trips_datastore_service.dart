import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:aws_amplify_test/models/Trip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripsDataStoreServiceProvider = Provider<TripDataStoreService>((ref) {
  return TripDataStoreService();
});

class TripDataStoreService {
  Future<void> addTrip(Trip trip) async {
    try {
      await Amplify.DataStore.save(trip);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteTrip(Trip trip) async {
    try {
      return Amplify.DataStore.delete(trip);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Stream<List<Trip>> listenToPastTrips() {
    try {
      return Amplify.DataStore.observeQuery(
        Trip.classType,
      ).map((event) => event.items);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() {
    return Amplify.Auth.signOut();
  }
}
