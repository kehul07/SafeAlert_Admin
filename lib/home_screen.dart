// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:safe_alert_admin/notification_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'Utils.dart';
//
// class HomeScreen extends StatefulWidget {
//   String cityName;
//    HomeScreen({super.key ,  required this.cityName});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
// int sos_unseenNotificationCount = 0;
// int report_unseenNotificationCount = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _getSOSUnseenNotificationCount();
//     _getReportUnseenNotificationCount();
//   }
//
//   void _getSOSUnseenNotificationCount() {
//     FirebaseFirestore.instance
//         .collection("Emergency_Notifications")
//         .where('city', isEqualTo: widget.cityName) // Filter by city
//         .where('seen', isEqualTo: false) // Filter only unseen notifications
//         .snapshots()
//         .listen((snapshot) {
//       setState(() {
//         sos_unseenNotificationCount = snapshot.docs.length; // Update unseen count
//       });
//     });
//   }
//
// void _getReportUnseenNotificationCount() {
//   FirebaseFirestore.instance
//       .collection("Report_Notifications")
//       .where('city', isEqualTo: widget.cityName) // Filter by city
//       .where('seen', isEqualTo: false) // Filter only unseen notifications
//       .snapshots()
//       .listen((snapshot) {
//     setState(() {
//       report_unseenNotificationCount = snapshot.docs.length; // Update unseen count
//     });
//   });
// }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Container(
//         padding:const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//            const SizedBox(height: 70,),
//             Container(
//               margin:const EdgeInsets.symmetric(horizontal: 20),
//               width: double.infinity,
//               height: 60,
//               child: ElevatedButton.icon(onPressed: (){
//                 Utils.navigateWithSlideTransitionWithPush(
//                   context: context,
//                   screen:NotificationScreen(cityName: widget.cityName),
//                   begin: const Offset(1, 0),
//                   end: Offset.zero,
//                 );
//               }, label:const Text("SOS Notifications",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.yellow.shade700,
//                 foregroundColor: Colors.black
//               ),),
//             ),
//             SizedBox(height: 30,),
//             Container(
//               margin:const EdgeInsets.symmetric(horizontal: 20),
//               width: double.infinity,
//               height: 60,
//               child: ElevatedButton.icon(onPressed: (){
//                 Utils.navigateWithSlideTransitionWithPush(
//                   context: context,
//                   screen:NotificationScreen(cityName: widget.cityName),
//                   begin: const Offset(1, 0),
//                   end: Offset.zero,
//                 );
//               }, label:const Text("Report Notifications",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.yellow.shade700,
//                     foregroundColor: Colors.black
//                 ),),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safe_alert_admin/admin_login.dart';
import 'package:safe_alert_admin/notification_screen.dart';
import 'package:safe_alert_admin/report_notification_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Utils.dart';

class HomeScreen extends StatefulWidget {
  String cityName;
  HomeScreen({super.key, required this.cityName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int sos_unseenNotificationCount = 0;
  int report_unseenNotificationCount = 0;

  @override
  void initState() {
    super.initState();
    _getSOSUnseenNotificationCount();
    _getReportUnseenNotificationCount();
  }

  // Fetch SOS unseen notification count
  void _getSOSUnseenNotificationCount() {
    FirebaseFirestore.instance
        .collection("Emergency_Notifications")
        .where('city', isEqualTo: widget.cityName) // Filter by city
        .where('seen', isEqualTo: false) // Filter only unseen notifications
        .snapshots()
        .listen((snapshot) {
      setState(() {
        sos_unseenNotificationCount = snapshot.docs.length; // Update unseen count
      });
    });
  }

  // Fetch Report unseen notification count
  void _getReportUnseenNotificationCount() {
    FirebaseFirestore.instance
        .collection("Report_Notifications")
        .where('city', isEqualTo: widget.cityName) // Filter by city
        .where('seen', isEqualTo: false) // Filter only unseen notifications
        .snapshots()
        .listen((snapshot) {
      setState(() {
        report_unseenNotificationCount = snapshot.docs.length; // Update unseen count
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const AdminLogin()));
        },
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child:const Icon(Icons.logout , color: Colors.white,),
      ),

      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            _buildNotificationButton(
              label: "SOS Notifications",
              onTap: () {
                Utils.navigateWithSlideTransitionWithPush(
                  context: context,
                  screen: NotificationScreen(cityName: widget.cityName),
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                );
              },
              unseenCount: sos_unseenNotificationCount,
            ),
            const SizedBox(height: 30),
            _buildNotificationButton(
              label: "Report Notifications",
              onTap: () {
                Utils.navigateWithSlideTransitionWithPush(
                  context: context,
                  screen: ReportNotificationScreen(cityName: widget.cityName),
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                );
              },
              unseenCount: report_unseenNotificationCount,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build notification buttons with unseen count badges
  Widget _buildNotificationButton({
    required String label,
    required Function() onTap,
    required int unseenCount,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: unseenCount > 0
            ? Stack(
          children: [
            const Icon(Icons.notifications,size: 30,),
            Positioned(
              right: -1,
              top: -5,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unseenCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        )
            : const Icon(Icons.notifications,size: 30,),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow.shade700,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }
}
