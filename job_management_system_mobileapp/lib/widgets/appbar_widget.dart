import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderPage.dart';
import 'package:job_management_system_mobileapp/Screens/JobProviderScreens/ProfileJobProvider.dart';
import 'package:job_management_system_mobileapp/Screens/JobSeekerScreens/ProfileJobSeeker.dart';

class AppBarWidget {
  AppBarWidget();

  PreferredSizeWidget simpleAppBarWidget(String title, double fontsize) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black,
            fontSize: fontsize,
            fontWeight: FontWeight.bold),
      ), // Set the title of the app bar
      backgroundColor: const Color.fromARGB(255, 255, 136, 0),
    );
  }

  Widget bottomAppBarProvider(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 255, 136, 0),
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.popAndPushNamed(context, 'provider_dashboard');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.popAndPushNamed(context, "editProviderProfile");
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>const ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                //Navigator.popAndPushNamed(context, "chats");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomAppBarSeeker(BuildContext context) {
    return BottomAppBar(
      color: const Color.fromARGB(255, 255, 136, 0),
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.popAndPushNamed(context, 'seeker_dashboard');
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.popAndPushNamed(context, "edit_seeker_profile");
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>const ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.popAndPushNamed(context, "seeker_chats");
              },
            ),
          ],
        ),
      ),
    );
  }
}
