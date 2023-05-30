import 'package:aws_amplify_test/common/navigation/router/routes.dart';
import 'package:aws_amplify_test/common/utils/colors.dart' as constants;
import 'package:aws_amplify_test/features/trip/controller/trips_list_controller.dart';
import 'package:aws_amplify_test/features/trip/data/trips_repository.dart';
import 'package:aws_amplify_test/features/trip/ui/trips_list/add_trip_bottomsheet.dart';
import 'package:aws_amplify_test/models/Trip.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TripsListPage extends HookConsumerWidget {
  const TripsListPage({super.key});

  void showAddTripDialog(BuildContext context) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        elevation: 5,
        builder: (context) {
          return AddTripBottomSheet();
        },
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Trip>> tripsListValue = ref.watch(tripsListStreamProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Amplify Trips Planner'),
        backgroundColor: const Color(constants.primaryColorDark),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(tripsRepositoryProvider).signOut();
              goToAuthScreen(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTripDialog(context);
        },
        backgroundColor: const Color(constants.primaryColorDark),
        child: const Icon(Icons.add),
      ),
      body: tripsListValue.when(
        data: (tripsList) {
          return ListView.builder(
            itemCount: tripsList.length,
            itemBuilder: (context, index) {
              final trip = tripsList[index];
              return ListTile(
                title: Text(trip.tripName),
                subtitle: Text(trip.destination),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    ref.read(tripsListControllerProvider).delete(trip);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
      ),
    );
  }

  void goToAuthScreen(BuildContext context) {
    context.goNamed(
      AppRoute.home.name,
    );
  }
}
