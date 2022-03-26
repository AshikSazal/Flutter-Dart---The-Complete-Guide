import 'package:flutter/foundation.dart';

class Transaction {
  final String id; // unique id // final mean runtime constant
  final String title;
  final double amount;
  final DateTime date;

  Transaction(
      {required this.id,
      required this.title,
      required this.amount,
      required this.date});
}
