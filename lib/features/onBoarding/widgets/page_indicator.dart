import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/onBoarding/cubit/onBoarding_cubit.dart';
import 'package:todo/features/onBoarding/cubit/onBoarding_states.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/size_config.dart';

class PageIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingStates>(
      builder: (context, state){
        final OnBoardingCubit cubit = OnBoardingCubit.get(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cubit.index == 0 ? _buildStar() :  _buildCircle(),
            SizedBox(width: 1* widthMultiplier,),
            cubit.index == 1 ? _buildStar() :  _buildCircle(),
            SizedBox(width: 1* widthMultiplier,),
            cubit.index == 2 ? _buildStar() :  _buildCircle(),
          ],
        );
      },
    );
  }

  Icon _buildStar() => Icon(Icons.star, color: mainColor, size: 7 * imageSizeMultiplier,);

  Container _buildCircle() {
    return Container(
        height: 4 * imageSizeMultiplier,
        width: 4 * imageSizeMultiplier,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mainColor.withOpacity(0.3),
        ),
      );
  }
}
