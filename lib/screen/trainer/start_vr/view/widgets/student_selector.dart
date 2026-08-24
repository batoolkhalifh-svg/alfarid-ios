import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/start_vr_cubit.dart';
import '../../controller/start_vr_states.dart';
import '../../model/student_model.dart';


class StudentSelector extends StatelessWidget {
  const StudentSelector({super.key});


  @override
  Widget build(BuildContext context) {

    final cubit = StartVrCubit.get(context);

    return BlocBuilder<StartVrCubit, StartVrStates>(
      builder: (context, state) {


        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "👨‍🎓 الطلاب",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10.h),


            InkWell(
              onTap: () async {

                if(cubit.studentsModel == null){

                  await cubit.fetchStudents();

                }


                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.r),
                    ),
                  ),

                  builder: (_) {

                    return BlocProvider.value(
                      value: cubit,

                      child: StudentBottomSheet(
                        students: cubit.studentsModel?.data ?? [],
                      ),
                    );

                  },

                );

              },


              child: Container(

                width: double.infinity,

                padding: EdgeInsets.all(16.w),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),

                child: Row(
                  children: [

                    Expanded(
                      child: Text(
                        cubit.selectedStudent.isEmpty
                            ? "اختر الطلاب"
                            : "تم اختيار ${cubit.selectedStudent.length} طالب",
                      ),
                    ),


                    const Icon(
                      Icons.keyboard_arrow_down,
                    )

                  ],
                ),
              ),
            ),


          ],
        );
      },
    );
  }
}




class StudentBottomSheet extends StatefulWidget {

  final List<DataS> students;

  const StudentBottomSheet({
    super.key,
    required this.students,
  });


  @override
  State<StudentBottomSheet> createState() =>
      _StudentBottomSheetState();

}



class _StudentBottomSheetState extends State<StudentBottomSheet> {


  List<DataS> selected = [];


  @override
  Widget build(BuildContext context) {


    return SizedBox(

      height: MediaQuery.of(context).size.height * .75,

      child: Column(

        children: [


          Padding(
            padding: EdgeInsets.all(20.w),

            child: Text(
              "اختيار الطلاب",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),



          Expanded(

            child: ListView.builder(

              itemCount: widget.students.length,


              itemBuilder: (context,index){


                final student = widget.students[index];


                final isSelected =
                selected.contains(student);



                return CheckboxListTile(

                  value: isSelected,


                  title: Text(
                    student.name ?? "",
                  ),


                  onChanged: (value){


                    setState(() {

                      if(value == true){

                        selected.add(student);

                      }else{

                        selected.remove(student);

                      }

                    });


                  },


                );

              },


            ),

          ),



          Padding(

            padding: EdgeInsets.all(20.w),

            child: SizedBox(

              width: double.infinity,

              height: 50.h,


              child: ElevatedButton(

                onPressed: (){


                  StartVrCubit.get(context)
                      .addSelectedList(selected);


                  Navigator.pop(context);


                },


                child: const Text(
                  "تأكيد الاختيار",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ),

            ),

          )


        ],

      ),

    );

  }

}