import 'package:flutter/material.dart';
import 'package:flip_cash/models/expense.dart';
import 'package:flip_cash/utils/expense_storage.dart';

class MyExpensesScreen extends StatefulWidget {
  final String countryName;
  final String baseCurrency;
  final List<Expense> expensesList;

  const MyExpensesScreen({
    super.key,
    required this.countryName,
    required this.baseCurrency,
    required this.expensesList,
  });

  @override
  State<MyExpensesScreen> createState() => _MyExpensesScreenState();
}

class _MyExpensesScreenState extends State<MyExpensesScreen> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final loaded = await ExpenseStorage.loadExpenses(widget.countryName, widget.baseCurrency);
    setState(() {
      _expenses = loaded;
    });
  }

  Future<void> _removeExpense(int index) async {
  _expenses.removeAt(index);
  await ExpenseStorage.saveExpenses(widget.countryName, widget.baseCurrency, _expenses);
  setState(() {});
}


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(  
      appBar: AppBar(title: Text("My Expenses",style: TextStyle(fontWeight: FontWeight.bold),), backgroundColor: Colors.transparent),
      body: _expenses.isEmpty
          ? Center(child: Text("There are no expenses yet.",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),))
          : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (context, index) {
                final e = _expenses[index];
                return Card(
                  color: isDark ? Colors.black87 : Colors.black87,
                  child: ListTile(
                    leading: Icon(Icons.adjust_sharp, color: isDark ? Colors.white : Colors.white,),
                    title: Text(e.description, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.white,
                      )),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${e.amount.toStringAsFixed(2)} ${e.currency}",
                            style: TextStyle(fontSize: 16, 
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.white,
                            )),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _removeExpense(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
