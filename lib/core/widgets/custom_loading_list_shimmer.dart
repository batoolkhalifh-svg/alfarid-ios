
import 'package:flutter/material.dart';
import '../utils/size.dart';
import 'custom_loading_shimmer_container.dart';

class CustomItemListShimmer extends StatelessWidget {
  const CustomItemListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.only(top: height*.02),
      child: CustomLoadingShimmerContainer(
        hgt: height*.2,
        wdt: width*0.44,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             CustomLoadingShimmerContainer(wdt: width*0.45, hgt: height*0.1,),
            SizedBox(height: height*.01,),
            Row(
              children: [
                CustomLoadingShimmerContainer(hgt: height*.02, wdt: width*.2,),
                const Spacer(),
                CustomLoadingShimmerContainer(hgt: height*.02, wdt: width*.06,),
              ],
            ),
            SizedBox(height: height*.01,),
            CustomLoadingShimmerContainer(hgt: height*.02, wdt: width*.25,),
            SizedBox(height: height*.01,),
            Row(
              children: [
                CustomLoadingShimmerContainer(hgt: height*.02, wdt: width*.1),
                SizedBox(width: width*.01,),
                CustomLoadingShimmerContainer(hgt: height*.02, wdt: width*.15,),
                Icon(Icons.star,color: Colors.black.withOpacity(.04),size: 20,)
              ],
            ),

          ],
        ),
      ),
    );
  }
}
