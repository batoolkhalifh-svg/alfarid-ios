import 'package:alfarid/core/local/app_cached.dart';
import 'package:alfarid/core/local/cache_helper.dart';
import 'package:alfarid/core/utils/my_navigate.dart';
import 'package:alfarid/core/widgets/custom_network_img.dart';
import 'package:alfarid/screen/student/cart/view/cart_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/notification/view/notification_screen.dart';
import '../../../../search/view/search_screen.dart';
import '../../controller/home_cubit.dart';
import '../../controller/home_states.dart';

class CustomHomeHeader extends StatelessWidget {
  const CustomHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      floating: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          final name =
              CacheHelper.getData(key: AppCached.name) ?? '';

          return Stack(
            children: [
              /// 🔵 الخلفية
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0089A6),
                      Color(0xFF004A59),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),

              /// 🧱 المحتوى
              SafeArea(
                child: SingleChildScrollView(
                  physics:
                  const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        /// 🔝 الصف العلوي
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "👋 مرحبا $name",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),

                            /// 🔔 إشعارات
                            _circleIcon(
                              icon: Icons
                                  .notifications_none,
                              onTap: () {
                                navigateTo(
                                  widget:
                                  const NotificationScreen(),
                                );
                              },
                            ),

                            const SizedBox(width: 10),

                            /// 🛒 السلة
                            _circleIcon(
                              icon: Icons
                                  .shopping_cart_outlined,
                              onTap: () {
                                navigateTo(
                                  widget:
                                  const CartScreen(),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        /// 🔍 البحث
                        GestureDetector(
                          onTap: () {
                            navigateTo(
                              widget:
                              const SearchScreen(),
                            );
                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(
                                  16),
                              boxShadow: const [
                                BoxShadow(
                                  color:
                                  Colors.black12,
                                  blurRadius: 10,
                                  offset:
                                  Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "ماذا تبحث عن؟",
                                  style: TextStyle(
                                    color:
                                    Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🎞️ البانر
                        if (state
                        is LoadingHomeState)
                          Container(
                            height: 100,
                            decoration:
                            BoxDecoration(
                              color:
                              Colors.white24,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                  16),
                            ),
                          )
                        else if (cubit
                            .bannersModel !=
                            null)
                          ClipRRect(
                            borderRadius:
                            BorderRadius
                                .circular(16),
                            child:
                            CarouselSlider(
                              items: cubit
                                  .bannersModel!
                                  .data!
                                  .banners!
                                  .map(
                                    (e) =>
                                    CustomNetworkImg(
                                      img:
                                      e.image!,
                                      fit: BoxFit
                                          .cover,
                                      width: double
                                          .infinity,
                                    ),
                              )
                                  .toList(),
                              options:
                              CarouselOptions(
                                height: 100,
                                viewportFraction:
                                1,
                                autoPlay: true,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔘 أيقونة دائرية
  Widget _circleIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor:
        Colors.white.withOpacity(0.2),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}