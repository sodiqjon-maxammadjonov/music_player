import 'package:flutter/material.dart';
class ControlsWidget extends StatelessWidget {
  const ControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.shuffle_rounded),
          iconSize: 24,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.skip_previous_rounded),
          iconSize: 40,
        ),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary
                    .withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.pause_rounded),
            iconSize: 40,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.skip_next_rounded),
          iconSize: 40,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.repeat_rounded),
          iconSize: 24,
        ),
      ],
    );
  }
}