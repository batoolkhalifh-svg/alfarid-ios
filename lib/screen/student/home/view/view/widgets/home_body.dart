import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/custom_error.dart';
import '../../controller/home_cubit.dart';
import '../../controller/home_states.dart';
import 'custom_home_header.dart';
import 'custom_loading_shimmer.dart';
import 'home_lists.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (context) => HomeCubit()..fetchHomeReq(),
          child: BlocBuilder<HomeCubit,HomeStates>(
          builder: (context, state) {
          final cubit = HomeCubit.get(context);
           return SafeArea(
             child:
             state is ErrorHomeState?CustomError(title: state.msg, onPressed: (){cubit.fetchHomeReq();}):
             CustomScrollView(
               controller: cubit.scrollController,
               slivers:  [
                 const CustomHomeHeader(),
                 state is LoadingHomeState?
                 const HomeLoadingShimmer()
                     :  HomeLists()
               ],
             ),
           );})),
    );
  }
}
