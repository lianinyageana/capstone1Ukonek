import 'package:flutter/material.dart';
import 'package:ukonekmobile/uKonekMenuPage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              SizedBox(height: 20,),
              /// IMAGE (TOP)
            Image.asset("assets/welcome_screen/welcomPhoto-removebg-preview.png",
              width: 1000,
              height: 400,
              fit: BoxFit.cover,
            ),

              /// TEXT SECTION
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "WELCOME TO",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 36,
                      fontStyle: FontStyle.italic,
                      color: Colors.black,
                      letterSpacing: 0,
                    ),
                  ),

                  //SizedBox(height: 5),

                  Text(
                    "U-KONEK",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B6EFF),
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Connect with trusted healthcare professionals anytime, anywhere. "
                        "Track your health, get reminders, and stay informed with U-KONEK — "
                        "your personal healthcare companion.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              /// BUTTON
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => uKonekMenuPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2B6EFF),
                  foregroundColor: Colors.white,
                  fixedSize: Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                child: Text("GET STARTED"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

