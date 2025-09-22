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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Sayı tuşları
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 2, // Daha uzun dikdörtgen tuşlar
            children: [
              ...List.generate(9, (index) => _numberButton("${index + 1}")),
              _numberButton("."),
              _numberButton("0"),
              _deleteButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _numberButton(String number) {
    return ElevatedButton(
      onPressed: () => widget.onNumberEntered(number),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black45,
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        number,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _deleteButton() {
    return ElevatedButton(
      onPressed: widget.onDelete,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Icon(Icons.delete_outline, size: 28, color: Colors.white),
    );
  }
}
