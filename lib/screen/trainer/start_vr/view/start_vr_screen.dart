import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../controller/start_vr_cubit.dart';
import 'start_vr_body.dart';

class StartVrScreen extends StatelessWidget {
  const StartVrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartVrCubit(),
      child: const StartVrBody(),
    );
  }
}