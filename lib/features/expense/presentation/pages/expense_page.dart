// lib/features/expense/presentation/pages/expense_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensego/features/expense/domain/entities/expense_entity.dart';
import 'package:expensego/features/expense/presentation/blocs/expense_bloc.dart';
import 'package:expensego/features/expense/presentation/blocs/expense_event.dart';
import 'package:expensego/features/expense/presentation/blocs/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ExpenseBloc>().add(LoadExpenses());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpenseLoaded) {
            if (state.expenses.isEmpty) {
              return const Center(
                child: Text(
                  'No transactions yet.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final expense = state.expenses[index];
                final icon = _getCategoryIcon(expense.category);
                final isIncome = expense.amount > 0;
                final amountColor =
                    isIncome
                        ? Colors.indigo
                        : (expense.amount < 0 ? Colors.red : Colors.grey[600]);

                final amountPrefix =
                    isIncome ? '-' : (expense.amount < 0 ? '+' : '');

                final formattedAmount = NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp',
                  decimalDigits: 0,
                ).format(expense.amount.abs());

                final formattedDate = DateFormat(
                  'dd MMMM - HH:mm',
                ).format(expense.createdAt.toLocal());

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Slidable(
                    key: ValueKey(expense.id),

                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.40,
                      children: [
                        const SizedBox(width: 5),
                        SlidableAction(
                          onPressed:
                              (_) => _showAddExpenseBottomSheet(
                                context,
                                expense: expense,
                              ),
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          // label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: (_) => _showDeleteDialog(context, expense),
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          // label: 'Delete',
                        ),
                      ],
                    ),

                    child: GestureDetector(
                      onTap:
                          () => _showAddExpenseBottomSheet(
                            context,
                            expense: expense,
                          ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.indigo,
                            child: Icon(icon, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expense.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  formattedDate,
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
                                '$amountPrefix$formattedAmount',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: amountColor,
                                ),
                              ),
                              Text(
                                expense.category,
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
          } else if (state is ExpenseError) {
            return Center(
              child: Text(state.message, style: const TextStyle(fontSize: 16)),
            );
          }
          return const Center(
            child: Text(
              'No transaction data available',
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExpenseBottomSheet(context),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    ExpenseEntity expense,
  ) async {
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
              const Text('Delete Transaction'),
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
                  text: expense.title,
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
      context.read<ExpenseBloc>().add(DeleteExpenseRequested(expense));
    }
  }

  void _showAddExpenseBottomSheet(
    BuildContext context, {
    ExpenseEntity? expense,
  }) {
    final _formKey = GlobalKey<FormState>();

    final titleController = TextEditingController(text: expense?.title ?? '');
    final amountController = TextEditingController(
      text: expense != null ? expense.amount.toStringAsFixed(0) : '',
    );
    String selectedCategory = expense?.category ?? 'General';

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
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              expense == null
                                  ? 'Add New Transaction'
                                  : 'Edit Transaction',
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
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!;
                            });
                          },
                          items:
                              ['General', 'Food', 'Transport', 'Shopping']
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ),
                                  )
                                  .toList(),
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Title wajib diisi';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Amount wajib diisi';
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

                              if (!_formKey.currentState!.validate()) {
                                // jika form tidak valid, hentikan proses
                                return;
                              }

                              final double amount =
                                  double.tryParse(amountController.text) ?? 0;

                              final newExpense = ExpenseEntity(
                                id:
                                    expense?.id ??
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                title: titleController.text,
                                amount: amount,
                                category: selectedCategory,
                                createdAt: expense?.createdAt ?? DateTime.now(),
                                userId: currentUser.uid,
                              );

                              if (expense == null) {
                                context.read<ExpenseBloc>().add(
                                  AddExpenseRequested(newExpense),
                                );
                              } else {
                                context.read<ExpenseBloc>().add(
                                  UpdateExpenseRequested(newExpense),
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
                            child: Text(expense == null ? 'SAVE' : 'UPDATE'),
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

IconData _getCategoryIcon(String category) {
  switch (category) {
    case 'Food':
      return Icons.restaurant;
    case 'Transport':
      return Icons.directions_car;
    case 'Shopping':
      return Icons.shopping_bag;
    default:
      return Icons.category;
  }
}
