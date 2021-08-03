import 'package:flutter/material.dart';
import 'package:todo/utils/size_config.dart';

class NoTasks extends StatelessWidget {
  const NoTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/no_tasks.png",
        height: 90 * imageSizeMultiplier,
        width: 100 * imageSizeMultiplier);
  }
}
