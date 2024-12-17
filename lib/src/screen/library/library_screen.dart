import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Library', style: Theme.of(context).textTheme.displayMedium),
      ),
      body: Center(
        child: Text(
          'Your Music Library',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
    );
  }
}
