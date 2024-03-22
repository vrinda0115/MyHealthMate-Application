

import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String name;

  const DetailsPage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Center(
        child: Text('Details for: $name'),
      ),
    );
  }
}

