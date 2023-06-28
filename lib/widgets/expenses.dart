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
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(
              addExpense: addExpense,
            ));
  }

  void addExpense(Expense expense) {
    setState(() {
      expensesList.add(expense);
    });
  }

  void removeExpense(Expense expense) {
    final expenseIndex = expensesList.indexOf(expense);
    setState(() {
      expensesList.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Expense Deleted"),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          setState(() {
            expensesList.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text(
        "No expense to display at the moment",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
    if (expensesList.isNotEmpty) {
      mainContent = Column(
        children: [
          const Text("Title"),
          Expanded(
            child: ExpensesList(
              expenses: expensesList,
              onRemoveExpense: removeExpense,
            ),
          ),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Flutter Expense Tracker"), actions: [
          IconButton(onPressed: openOverlay, icon: const Icon(Icons.add))
        ]),
        body: mainContent);
  }
}
