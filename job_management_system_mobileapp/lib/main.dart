import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold( 


//AppBar with Department of Manpower and Employement Banner
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Corrected capitalization here
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

//body of the App
body:Container(
  color: Color.fromARGB(255, 247, 153, 12),
  child: Center(
    
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 70,
        ),
  //button to navigate to sinhala      
        ElevatedButton(
          onPressed: (){
  
          },
           child: Text("ආයුබොවන් සිංහලෙන් බලන්න",
           style: TextStyle(
            fontSize: 20,
            fontFamily: 'AbhayaLibre',
           ),
           ),
        ),
  
  
        SizedBox(height: 10),
        ElevatedButton(onPressed: (){},
         child:Text(
          "English",
          style: TextStyle(
            fontSize: 20,
          
          ),
         ),
         ),
  
  
  
          SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle button press
                  },
                  child: Text(
                    "தமிழில் ஆயுபோவன் பார்க்கவும்",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'AbhayaLibre',
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
