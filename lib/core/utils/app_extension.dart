import 'package:flutter/material.dart';

extension GradientExtension on Widget {
  Widget withGradient(List<Color> colors,
      {Alignment begin = Alignment.topLeft,
      Alignment end = Alignment.bottomRight}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
        ),
      ),
      child: this,
    );
  }
}

// use this extension like this
// Text("Hello World").withGradient([Colors.blue, Colors.purple]),
// Image.asset("assets/image.png").withGradient([Colors.blue, Colors.purple]),
// Container().withGradient([Colors.blue, Colors.purple]),
// Card().withGradient([Colors.blue, Colors.purple]),
