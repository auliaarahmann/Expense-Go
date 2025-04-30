// lib/features/trip/presentation/pages/trip_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensego/features/trip/domain/entities/trip_entity.dart';
import 'package:expensego/features/trip/presentation/blocs/trip_bloc.dart';
import 'package:expensego/features/trip/presentation/blocs/trip_event.dart';
import 'package:expensego/features/trip/presentation/blocs/trip_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TripPage extends StatelessWidget {
  const TripPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TripBloc>().add(LoadTrips());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<TripBloc, TripState>(
        builder: (context, state) {
          if (state is TripLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TripLoaded) {
            if (state.trips.isEmpty) {
              return const Center(
                child: Text('Belum ada data.', style: TextStyle(fontSize: 16)),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                final trip = state.trips[index];

                final formattedBudget = NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp',
                  decimalDigits: 0,
                ).format(trip.budget.abs());

                final formattedstartDate = DateFormat(
                  'dd MMMM - HH:mm',
                ).format(trip.startDate.toLocal());

                final formattedendDate = DateFormat(
                  'dd MMMM - HH:mm',
                ).format(trip.endDate.toLocal());

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Slidable(
                    key: ValueKey(trip.id),

                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.40,
                      children: [
                        const SizedBox(width: 5),
                        SlidableAction(
                          onPressed:
                              (_) =>
                                  _showAddTripBottomSheet(context, trip: trip),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          // label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (_) => _showDeleteDialog(context, trip),
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          // label: 'Delete',
                        ),
                      ],
                    ),

                    child: GestureDetector(
                      onTap: () => _showAddTripBottomSheet(context, trip: trip),
                      child: Row(
                        children: [
                          CircleAvatar(backgroundColor: Colors.indigo),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trip.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  formattedBudget,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formattedstartDate,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                formattedendDate,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is TripError) {
            return Center(
              child: Text(state.message, style: const TextStyle(fontSize: 16)),
            );
          }
          return const Center(
            child: Text(
              'No trip data available',
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTripBottomSheet(context),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, TripEntity trip) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 8),
              const Text('Delete Trip'),
            ],
          ),
          content: RichText(
            text: TextSpan(
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.black87),
              children: [
                const TextSpan(text: 'Are you sure you want to delete '),
                TextSpan(
                  text: trip.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const TextSpan(text: "? This action can't be undone."),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.cancel, color: Colors.grey),
              label: const Text('No, Back', selectionColor: Colors.black),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton.icon(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text(
                'Sure, delete.',
                style: TextStyle(color: Colors.red),
              ),

              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // ignore: use_build_context_synchronously
      context.read<TripBloc>().add(DeleteTripRequested(trip));
    }
  }

  void _showAddTripBottomSheet(BuildContext context, {TripEntity? trip}) {
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: trip?.name ?? '');
    final budgetController = TextEditingController(
      text: trip != null ? trip.budget.toStringAsFixed(0) : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trip == null ? 'Tambah Trip' : 'Edit Trip',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Trip',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Beri nama trip anda!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: budgetController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Anggaran',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Tentukan anggaran untuk trip ini!';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Masukkan angka yang valid';
                            }
                            if (double.tryParse(value)! <= 0) {
                              return 'Jumlah harus lebih dari 0';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;
                              if (currentUser == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("You must be logged in."),
                                  ),
                                );
                                return;
                              }

                              if (!formKey.currentState!.validate()) {
                                // jika form tidak valid, hentikan proses
                                return;
                              }

                              final double budgetAmount =
                                  double.tryParse(budgetController.text) ?? 0;

                              final newTrip = TripEntity(
                                id:
                                    trip?.id ??
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                name: nameController.text,
                                budget: budgetAmount,
                                userId: currentUser.uid,
                                startDate: trip?.startDate ?? DateTime.now(),
                                endDate: trip?.endDate ?? DateTime.now(),
                                isFlexible: true,
                                createdAt: trip?.createdAt ?? DateTime.now(),
                                // updatedAt: DateTime.now(),
                              );

                              if (trip == null) {
                                context.read<TripBloc>().add(
                                  AddTripRequested(newTrip),
                                );
                              } else {
                                context.read<TripBloc>().add(
                                  UpdateTripRequested(newTrip),
                                );
                              }

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(trip == null ? 'SAVE' : 'UPDATE'),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
