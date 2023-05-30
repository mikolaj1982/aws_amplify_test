import 'package:aws_amplify_test/features/trip/controller/trips_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AddTripBottomSheet extends HookConsumerWidget {
  final formGlobalKey = GlobalKey<FormState>();

  AddTripBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripNameController = useTextEditingController();
    final destinationController = useTextEditingController();
    final startDateController = useTextEditingController();
    final endDateController = useTextEditingController();
    return Form(
      key: formGlobalKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: tripNameController,
              decoration: const InputDecoration(
                labelText: 'Trip Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter trip name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: 'Destination',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter destination';
                }
                return null;
              },
            ),
            TextFormField(
              controller: startDateController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                labelText: 'Start Date',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter start date';
                }
                return null;
              },
              onTap: () async {
                if (startDateController.text.isNotEmpty) {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

                    startDateController.text = formattedDate;
                  }
                }
              },
            ),
            TextFormField(
              controller: endDateController,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                labelText: 'End Date',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter end date';
                }
                return null;
              },
              onTap: () async {
                if (startDateController.text.isNotEmpty) {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.parse(startDateController.text),
                      firstDate: DateTime.parse(startDateController.text),
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

                    endDateController.text = formattedDate;
                  }
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formGlobalKey.currentState!.validate()) {
                  ref.read(tripsListControllerProvider).add(
                        name: tripNameController.text,
                        destination: destinationController.text,
                        startDate: startDateController.text,
                        endDate: endDateController.text,
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Trip'),
            ),
          ],
        ),
      ),
    );
  }
}
