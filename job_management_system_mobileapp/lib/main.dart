import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: AppBar(
            backgroundColor: const Color.fromARGB(255, 241, 157, 47),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/DME_image01.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),

//**********************************************Body of the mobile App***********************************************************/

        body: Container(
          color: const Color.fromARGB(255, 241, 157, 47),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 70,
                ),
//************************************************button to display content in Sinhala*****************************************/
                Container(
                  width: 350,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.orange, // Button background color
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        spreadRadius: 1,
                        blurRadius:8,
                        offset: Offset(4,4),
                      ),
                    ], // Button border radius
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent, // Make button transparent
                      elevation: 0, // Remove button shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // Set button border radius
                      ),
                    ),
                    child: Text(
                      "ආයුබොවන් සිංහලෙන් බලන්න",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'AbhayaLibre',
                      ),
                    ),
                  ),
                ),

 //************************************************button to display content in English*****************************************/               
                SizedBox(height: 10),
                Container(
                  width: 350,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                     boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        spreadRadius: 1,
                        blurRadius:8,
                        offset: Offset(4,4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "English",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),


//************************************************button to display content in Tamil****************************************/               
                Container(
                  width: 350,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                     boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        spreadRadius: 1,
                        blurRadius:8,
                        offset: Offset(4,4),
                      ),
                    ], 
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        
                      ),
                    ),
                    child: Text(
                      "தமிழில் ஆயுபோவன் பார்க்கவும்",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'AbhayaLibre',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
