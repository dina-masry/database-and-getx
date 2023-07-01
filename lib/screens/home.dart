import 'package:database/Getx/notes_getx_controller.dart';
import 'package:database/prefs/shared_pref_controller.dart';
import 'package:database/process_response.dart';
import 'package:database/screens/Note_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:database/extensions/context_extensions.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 NoteGetXController controller = Get.put<NoteGetXController>(NoteGetXController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                _showLogoutConfirmDialog(context);
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoteScreen()));
              },
              icon: const Icon(Icons.note_add_outlined))
        ],
      ),
      body: Obx((){
            if (controller.notes.isNotEmpty) {
              return ListView.builder(
                  itemCount: controller.notes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: ()  {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NoteScreen(
                                  note: controller.notes[index],
                                )));

                      },
                      leading: const Icon(Icons.note),
                      title: Text(controller.notes[index].title),
                      subtitle: Text(controller.notes[index].info),
                      trailing: IconButton(
                          onPressed: ()  {
                            _delete(index);
                          },
                          icon: const Icon(Icons.delete)),
                    );
                  });
            } else {
              return Center(
                child: Text(
                  'No Data',
                  style: GoogleFonts.cairo(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade400
                  ),
                ),
              );
            }
      }),
      // body: GetX<NoteGetXController>(
      //   init: NoteGetXController(),
      //     global: true,
      //     builder: (NoteGetXController controller){
      //       if(controller.loading.isTrue){
      //         return Center(child: CircularProgressIndicator());
      //       }else
      //           if (controller.notes.isNotEmpty) {
      //             return ListView.builder(
      //                 itemCount: controller.notes.length,
      //                 itemBuilder: (context, index) {
      //                   return ListTile(
      //                     onTap: ()  {
      //                       Navigator.push(
      //                           context,
      //                           MaterialPageRoute(
      //                               builder: (context) => NoteScreen(
      //                                 note: controller.notes[index],
      //                               )));
      //
      //                     },
      //                     leading: const Icon(Icons.note),
      //                     title: Text(controller.notes[index].title),
      //                     subtitle: Text(controller.notes[index].info),
      //                     trailing: IconButton(
      //                         onPressed: ()  {
      //                           _delete(index);
      //                         },
      //                         icon: const Icon(Icons.delete)),
      //                   );
      //                 });
      //           } else {
      //             return Center(
      //               child: Text(
      //                 'No Data',
      //                 style: GoogleFonts.cairo(
      //                   fontSize: 25.sp,
      //                   fontWeight: FontWeight.bold,
      //                   color: Colors.grey.shade400
      //                 ),
      //               ),
      //             );
      //           }
      //         },
      // ),

      // body: GetBuilder<NoteGetXController>(
      //    init: NoteGetXController(),
      //   global: true,
      //   builder: (NoteGetXController controller){
      //     if (controller.notes.isNotEmpty) {
      //       return ListView.builder(
      //           itemCount: controller.notes.length,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               onTap: ()  {
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => NoteScreen(
      //                           note: controller.notes[index],
      //                         )));
      //
      //               },
      //               leading: const Icon(Icons.note),
      //               title: Text(controller.notes[index].title),
      //               subtitle: Text(controller.notes[index].info),
      //               trailing: IconButton(
      //                   onPressed: ()  {
      //                     _delete(index);
      //                   },
      //                   icon: const Icon(Icons.delete)),
      //             );
      //           });
      //     } else {
      //       return Center(
      //         child: Text(
      //           'No Data',
      //           style: GoogleFonts.cairo(
      //             fontSize: 25.sp,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.grey.shade400
      //           ),
      //         ),
      //       );
      //     }
      //   },
      // ),
    );
  }
  void _delete(int index)async{

    // ProcessResponse processResponse =
    //     await Provider.of<NoteProvider>(context,
    //     listen: false)
    //     .delete(index);
    ProcessResponse processResponse = await NoteGetXController.to.delete(index);
    if (processResponse.success) {
      context.showSnackBar(
          message: processResponse.message,
          error: !processResponse.success);
    }
  }

  void _showLogoutConfirmDialog(BuildContext context) async {
    bool? result = await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(width: 1.w, color: Colors.pink.shade200)),
            backgroundColor: Colors.pink.shade100,
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure?'),
            titleTextStyle: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
            contentTextStyle: GoogleFonts.cairo(
              fontSize: 15.sp,
              fontWeight: FontWeight.w300,
              height: 1.0,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.cairo(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () {
                    SharedPrefController().clear();
                    Navigator.pop(context, true);
                    Navigator.pushReplacementNamed(context, '/Login');
                  },
                  child: Text(
                    'Confirm',
                    style: GoogleFonts.cairo(color: Colors.blue),
                  ))
            ],
          );
        }

        );
    if (result ?? false) {
      bool cleared = await SharedPrefController().clear();
      if (cleared) {
        Get.delete<NoteGetXController>();
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    }
  }

}
