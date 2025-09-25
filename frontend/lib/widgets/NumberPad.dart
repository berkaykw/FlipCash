import 'package:flutter/material.dart';

class SimpleNumberPad extends StatefulWidget {
  final String amount;
  final void Function(String) onNumberEntered;
  final VoidCallback onDelete;
  final String currencyAmount;

  const SimpleNumberPad({
    super.key,
    required this.amount,
    required this.onNumberEntered,
    required this.onDelete,
    required this.currencyAmount,
  });

  @override
  State<SimpleNumberPad> createState() => _SimpleNumberPadState();
}

class _SimpleNumberPadState extends State<SimpleNumberPad> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 2,
            children: [
              ...List.generate(9, (index) => _numberButton("${index + 1}", isDark)),
              _numberButton(".", isDark),
              _numberButton("0", isDark),
              _deleteButton(isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _numberButton(String number, bool isDark) {
    return ElevatedButton(
      onPressed: () => widget.onNumberEntered(number),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.black87 : Colors.black,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        number,
        style: TextStyle(
          fontSize: 20,
          color: isDark ? Colors.white : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _deleteButton(bool isDark) {
    return ElevatedButton(
      onPressed: widget.onDelete,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.red[400] : Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Icon(Icons.delete_outline, size: 28, color: Colors.white),
    );
  }
}
