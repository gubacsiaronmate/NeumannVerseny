import 'package:flutter/material.dart';

class PageContent extends StatelessWidget {
  final String content;

  const PageContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(content),
          const SizedBox(height: 1000),
          const Text('test'),
        ],
      ),
    );
  }
}
