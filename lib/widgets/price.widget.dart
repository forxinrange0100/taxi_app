import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  final int price;
  const PriceWidget({super.key, required this.price});

  String formatPrice(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text("\$ ${formatPrice(price)} CLP");
  }
}
