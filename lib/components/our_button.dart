import 'package:flutter/material.dart';

class OurButton extends StatelessWidget {
  OurButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.size = 18,
  });

  final String title;
  final int size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green, // Warna tombol
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
