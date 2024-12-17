import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/not_found.json',height: MediaQuery.of(context).size.height * 0.15),
          Text('Media topilmadi.',style: Theme.of(context).textTheme.displayMedium,),
        ],
      ),
    );
  }
}
