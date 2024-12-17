import 'package:flutter/material.dart';

class LibraryDesign extends StatefulWidget {
  const LibraryDesign({super.key});

  @override
  State<LibraryDesign> createState() => _LibraryDesignState();
}

class _LibraryDesignState extends State<LibraryDesign> {
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
    );;
  }
}
