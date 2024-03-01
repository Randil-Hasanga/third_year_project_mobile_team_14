
import 'package:flutter/material.dart';
import 'package:job_management_system_mobileapp/Screens/ChooseUser.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(250.0),
          child: AppBar(
            backgroundColor: Colors.transparent, // Set the AppBar color to transparent
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.orange, Colors.white], // Colors for the gradient
                  stops: [0.7, 1.0], // Gradient stops
                ),
                image: DecorationImage(
                  image: AssetImage("assets/DME_image01.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        body: Container(
         decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 255, 255, 255), Colors.orange],
              stops: [0.7, 1.0],
            ),
          ), child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 350,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),                                            //***********************************Navigate to sinhala************* */
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ආයුබෝවන් සිංහලෙන් බලන්න",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'AbhayaLibre',
                          ),
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChooseUser()),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),                                                    //***********************************Navigate to Tamil************* */
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ayubowan View in English",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'AbhayaLibre',
                          ),
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Row(                                              //***********************************Navigate to Tamil************* */
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "வணக்கம் தமிழ் பார்வையில்",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'AbhayaLibre',
                          ),
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    
                  ),
                  
                ),
                 const SizedBox(height: 200),
                const Text(
                  "Job Center, District Secretariat, Matara",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
