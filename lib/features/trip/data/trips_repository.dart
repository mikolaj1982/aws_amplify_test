import 'package:aws_amplify_test/features/trip/services/trips_datastore_service.dart';
import 'package:aws_amplify_test/models/Trip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  final tripsDataStoreService = ref.watch(tripsDataStoreServiceProvider);
  return TripsRepository(tripsDataStoreService);
});

final tripsListStreamProvider = StreamProvider.autoDispose<List<Trip>>((ref) {
  final tripsDataStoreService = ref.watch(tripsDataStoreServiceProvider);
  return tripsDataStoreService.listenToPastTrips();
});

class TripsRepository{
  TripsRepository(this.tripsDataStoreService);
  final TripDataStoreService tripsDataStoreService;

  Future<void> add(Trip trip) async{
    await tripsDataStoreService.addTrip(trip);
  }

  Future<void> delete(Trip trip) {
    return tripsDataStoreService.deleteTrip(trip);
  }

  Future<void> signOut() {
    return tripsDataStoreService.signOut();
  }
}