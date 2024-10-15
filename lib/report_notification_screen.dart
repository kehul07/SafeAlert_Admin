import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportNotificationScreen extends StatelessWidget {
  final String cityName;

  ReportNotificationScreen({required this.cityName});

  Future<void> _openLink(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _markAsSeen(DocumentSnapshot doc) async {
    try {
      await FirebaseFirestore.instance
          .collection("Report_Notifications")
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
        iconTheme:const IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin:const EdgeInsets.only(top: 10),
        padding:const EdgeInsets.all(5),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Report_Notifications")
              .where('city', isEqualTo: cityName)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style:const TextStyle(color: Colors.white)));
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
                       _displayDetailNotification(context,data["location"], data["image"], data["video"], data["audio"]);
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

  _displayDetailNotification(BuildContext context, String? location, String? image, String? video, String? audio) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title:const  Text("Report" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold ,)),
          backgroundColor: Colors.grey.shade700.withOpacity(0.5),
          content: Container(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 2, // 2 columns
              shrinkWrap: true,  // Makes the GridView take only the needed space
              crossAxisSpacing: 10,  // Horizontal spacing between grid items
              mainAxisSpacing: 10,   // Vertical spacing between grid items
              children: [
                location != null
                    ? GestureDetector(
                  onTap: () {
                    _openLink(location);
                  },
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(child: Text("Location")),
                  ),
                )
                    : const SizedBox(),

                image != null
                    ? GestureDetector(
                  onTap: () {
                    _openLink(image);
                  },
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(child: Text("Image")),
                  ),
                )
                    : const SizedBox(),

                video != null
                    ? GestureDetector(
                  onTap: () {
                    _openLink(video);
                  },
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(child: Text("Video")),
                  ),
                )
                    : const SizedBox(),

                audio != null
                    ? GestureDetector(
                  onTap: () {
                    _openLink(audio);
                  },
                  child: Container(
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade700,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(child: Text("Audio")),
                  ),
                )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}
