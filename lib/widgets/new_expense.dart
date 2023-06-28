import 'package:expense/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? selectedDate;
  Category _selectedCategory = Category.leisure;

  void _openDatePicker() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context, initialDate: now, firstDate: first, lastDate: now);
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void _saveExpense() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountisInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty == null ||
        amountisInvalid ||
        selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid input"),
                content: const Text("One or more of your inputs in invalid"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("ok"))
                ],
              ));
      return;
    }
    widget.addExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      child: Column(
        children: [
          TextField(
            maxLength: 50,
            controller: _titleController,
            decoration: const InputDecoration(label: Text("Enter Text")),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      label: Text("Amount"), prefixText: '\$'),
                  controller: _amountController,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      selectedDate == null
                          ? "No date selected"
                          : formatter.format(selectedDate!),
                    ),
                    IconButton(
                      onPressed: _openDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  }),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: _saveExpense, child: const Text("Save Expense"))
            ],
          )
        ],
      ),
    );
  }
}
