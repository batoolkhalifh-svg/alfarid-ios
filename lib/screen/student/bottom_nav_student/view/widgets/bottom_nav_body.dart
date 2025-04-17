import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/base_state.dart';
import '../../controller/bottom_nav_cubit.dart';
import 'bottom_nav_list_items.dart';


class BottomNavBody extends StatelessWidget {
  const BottomNavBody({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, BaseStates>(
        builder: (context, state) {
          final cubit = BottomNavCubit.get(context);
          return Scaffold(
              body: cubit.pages[cubit.currentIndex],
              bottomNavigationBar: const CustomBottomNavListItems());
        },
      ),
    );
  }
}