import 'package:flutter/material.dart';

class TopImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://firebasestorage.googleapis.com/v0/b/learnify-1-0.appspot.com/o/app_launch.jpg?alt=media&token=d24828d4-0cc2-467b-a8d3-16d1e90bc3b0&_gl=1*3qcc35*_ga*NjU3NjE4Mzk5LjE2OTczMDY3OTY.*_ga_CW55HF8NVT*MTY5ODQwMDUyOS4yMi4xLjE2OTg0MDEwNTIuNDIuMC4w', // Replace with your actual image URL
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
