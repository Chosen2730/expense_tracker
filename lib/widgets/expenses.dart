import 'package:expense/models/expense.dart';
import 'package:expense/widgets/epenses_list.dart';
import 'package:expense/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> expensesList = [
    Expense(
        title: "Flutter Course",
        amount: 19.45,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Grocery",
        amount: 32.45,
        date: DateTime.now(),
        category: Category.food),
  ];

  void openOverlay() {
    showModalBottomSheet(
        context: context, builder: (ctx) => const NewExpense());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Expense Tracker"), actions: [
        IconButton(onPressed: openOverlay, icon: const Icon(Icons.add))
      ]),
      body: Column(
        children: [
          const Text("Title"),
          Expanded(child: ExpensesList(expenses: expensesList))
        ],
      ),
    );
  }
}
