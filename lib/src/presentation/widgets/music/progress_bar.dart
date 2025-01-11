import 'package:flutter/material.dart';
class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 14,
            ),
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor:
            theme.colorScheme.primary.withOpacity(0.2),
            thumbColor: theme.colorScheme.primary,
            overlayColor:
            theme.colorScheme.primary.withOpacity(0.2),
          ),
          child: Slider(
            value: 0.7,
            onChanged: (value) {},
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2:30',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withOpacity(0.7),
                ),
              ),
              Text(
                '3:45',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface
                      .withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}