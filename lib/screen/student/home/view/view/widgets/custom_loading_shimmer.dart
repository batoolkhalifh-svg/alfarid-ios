import 'package:flutter/material.dart';

import '../../../../../../core/utils/size.dart';
import '../../../../../../core/widgets/custom_loading_list_shimmer.dart';
import '../../../../../../core/widgets/custom_loading_shimmer_container.dart';


class HomeLoadingShimmer extends StatelessWidget {
  const HomeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 1,
            (context, index) => Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Column(
            children: [
              Row(
                children: [
                  CustomLoadingShimmerContainer(
                    hgt: height * .025,
                    wdt: width * .15,
                  ),
                  const Spacer(),
                  CustomLoadingShimmerContainer(
                    hgt: height * .015,
                    wdt: width * .08,
                  ),
                ],
              ),
              Row(
                children: List.generate(
                   4, (index) =>  Padding(
                      padding:  EdgeInsets.all(width*0.021),
                      child: CustomLoadingShimmerContainer(hgt: height * .05, wdt: width * .18,),
                    ),
              ),),
              Row(
                  children: List.generate(
                    2,
                        (index) => Padding(
                          padding:  EdgeInsetsDirectional.only(end: width*0.02),
                          child: const CustomItemListShimmer(),
                        ),
                  )),
              SizedBox(height: height*0.01,),
              Row(
                children: [
                  CustomLoadingShimmerContainer(
                    hgt: height * .025,
                    wdt: width * .15,
                  ),
                  const Spacer(),
                  CustomLoadingShimmerContainer(
                    hgt: height * .015,
                    wdt: width * .08,
                  ),
                ],
              ),
              Row(
                  children: List.generate(
                    2,
                        (index) => Padding(
                      padding:  EdgeInsetsDirectional.only(end: width*0.02),
                      child: const CustomItemListShimmer(),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}