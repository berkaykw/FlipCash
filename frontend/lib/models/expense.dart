class Expense {
  final double amount;
  final String description;
  final String currency;

  Expense({
    required this.amount,
    required this.description,
    required this.currency,
  });

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'description': description,
        'currency': currency,
      };

  factory Expense.fromMap(Map<String, dynamic> map) => Expense(
        amount: map['amount'],
        description: map['description'],
        currency: map['currency'],
      );
}
