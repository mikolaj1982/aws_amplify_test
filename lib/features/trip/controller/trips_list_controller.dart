import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:aws_amplify_test/features/trip/data/trips_repository.dart';
import 'package:aws_amplify_test/models/Trip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tripsListControllerProvider =
    Provider<TripsListController>((ref) => TripsListController(ref));

class TripsListController {
  TripsListController(this.ref);

  final Ref ref;

  Future<void> add({
    required String name,
    required String destination,
    required String startDate,
    required String endDate,
  }) async {
    Trip trip = Trip(
      tripName: name,
      destination: destination,
      startDate: TemporalDate(DateTime.parse(startDate)),
      endDate: TemporalDate(DateTime.parse(endDate)),
    );

    final tripsRepository = ref.read(tripsRepositoryProvider);
    await tripsRepository.add(trip);
  }

  void delete(Trip trip) {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    tripsRepository.delete(trip);
  }
}
