import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/onBoarding/cubit/onBoarding_states.dart';

class OnBoardingCubit extends Cubit<OnBoardingStates>{
  OnBoardingCubit() : super(OnBoardingInitialState());

 static OnBoardingCubit get(BuildContext context) => BlocProvider.of(context);

  int index = 0 ;
  onPageChange(int newIndex){
    index = newIndex;
   if(newIndex == 0){
     emit(OnBoardingFirstState());
   } else if(newIndex == 1){
     emit(OnBoardingSecondState());
   } else if(newIndex == 2){
     emit(OnBoardingThirdState());
   }
  }
}