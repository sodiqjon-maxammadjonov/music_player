import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import '../../util/constants/const_value.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/not_found.json', height: 200),
          const Text(ConstValue.noMedia)
        ],
      ),
    );
  }
}
