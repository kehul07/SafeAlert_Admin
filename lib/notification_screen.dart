// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class NotificationScreen extends StatelessWidget {
//   final String cityName;
//
//   // Constructor to pass the city name
//   NotificationScreen({required this.cityName});
//
//   // Function to retrieve notifications by city name
//   Future<List<Map<String, dynamic>>> getNotificationsByCityName(
//       String cityName) async {
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection("Notifications")
//           .where('city', isEqualTo: cityName)
//           .get();
//
//       return querySnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//     } catch (e) {
//       print("Error fetching notifications: $e");
//       return [];
//     }
//   }
//
//   Future<void> _openLink(String url) async {
//     final Uri _url = Uri.parse(url);
//     if (!await launchUrl(_url)) {
//       throw 'Could not launch $url';
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Notifications for $cityName',
//           style: TextStyle(
//               color: Colors.yellow.shade700,
//               fontWeight: FontWeight.bold,
//               fontSize: 25),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//       ),
//       backgroundColor: Colors.black,
//       body: Container(
//         margin: EdgeInsets.only(top: 10),
//         padding: EdgeInsets.all(5),
//         child: FutureBuilder<List<Map<String, dynamic>>>(
//           future: getNotificationsByCityName(cityName),
//           builder: (BuildContext context,
//               AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//             // Check the connection state
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               // While data is loading, show a progress indicator
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               // If there's an error, display it
//               return Center(child: Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.white)));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               // If no data is returned, show a message
//               return Center(child: Text('No notifications found.',style: TextStyle(color: Colors.white),));
//             } else {
//               // If data is successfully retrieved, display it in a ListView
//               List<Map<String, dynamic>> notifications = snapshot.data!;
//
//               return ListView.builder(
//                 itemCount: notifications.length,
//                 reverse: true,
//                 itemBuilder: (context, index) {
//                   Map<String, dynamic> notification = notifications[index];
//
//                   // Customize how you want to display the notification data
//                   return Container(
//                     padding:const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey,width: 1),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: ListTile(
//                       title: Text(notification['title'] ?? 'No Title' , style:const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
//                       subtitle: Text(notification['message'] ?? 'No Message' ,maxLines: 2, style:const TextStyle(color: Colors.grey),),
//                       leading:const Icon(Icons.notification_important),
//                       trailing: ElevatedButton.icon(
//                         onPressed: () {
//                             _openLink(notification["location"]);
//                         },
//                         label:const Text("Location"),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.yellow.shade700,
//                             foregroundColor: Colors.black),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationScreen extends StatelessWidget {
  final String cityName;

  NotificationScreen({required this.cityName});

  Future<void> _openLink(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _markAsSeen(DocumentSnapshot doc) async {
    try {
      await FirebaseFirestore.instance
          .collection("Emergency_Notifications")
          .doc(doc.id)
          .update({'seen': true});
    } catch (e) {
      print("Error marking notification as seen: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications for $cityName',
          style: TextStyle(
              color: Colors.yellow.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(5),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Emergency_Notifications")
              .where('city', isEqualTo: cityName)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text('No notifications found.',
                      style: TextStyle(color: Colors.white)));
            } else {
              List<DocumentSnapshot> notifications = snapshot.data!.docs;

              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];
                  var data = notification.data() as Map<String, dynamic>;
                  bool isSeen = data['seen'] ?? false;

                  return GestureDetector(
                    onTap: () {
                      _markAsSeen(notification); // Mark as seen
                      if (data["location"] != null) {
                        _openLink(data["location"]); // Open link
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        color: isSeen ? Colors.black : Colors.yellow.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(
                          data['title'] ?? 'No Title',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['message'] ?? 'No Message',
                          maxLines: 2,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        leading:isSeen ?const Icon(Icons.notification_important) : const Icon(Icons.notifications_active_sharp,color: Colors.red,),
                        trailing: ElevatedButton.icon(
                          onPressed: () {
                            if (data["location"] != null) {
                              _openLink(data["location"]);
                            }
                          },
                          label: const Text("Location"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade700,
                              foregroundColor: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
