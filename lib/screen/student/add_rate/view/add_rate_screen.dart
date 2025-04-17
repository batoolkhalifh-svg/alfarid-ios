import 'package:flutter/material.dart';

import 'widgets/add_rate_body.dart';

class AddRateScreen extends StatelessWidget {
  final int id;
  const AddRateScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return  AddRateBody(id: id,);
  }
}
