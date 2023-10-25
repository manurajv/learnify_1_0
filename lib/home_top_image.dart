import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://subzfresh.com/wp-content/uploads/2022/04/apple_158989157.jpg', // Replace with your actual image URL
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
