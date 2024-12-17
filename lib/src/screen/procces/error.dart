import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/error.json',height: MediaQuery.of(context).size.height * 0.15),
          Text('Nimadir hato ketdi.',style: Theme.of(context).textTheme.displayMedium,),
        ],
      ),
    );
  }
}
