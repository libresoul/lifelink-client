import 'package:flutter/material.dart';
import 'package:lifelink/pages/editprofile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 246, 225, 224),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "0+  BLOOD GROUP",
                        style: TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 100,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 247, 244, 244),
                            borderRadius: BorderRadius.circular(10)
            
                          ),
                          child:Column(
                            children: [ 
                              Text(
                                "8",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20
                                ),
                              ),
                              Text(
                                "TOTAL",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                              Text(
                                "DONATIONS",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ],
                          ), 
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 245, 245),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:Column(
                            children: [
                              Text(
                                "Sept15",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              Text("LAST"),
                              Text("DONATION"),
                            ],
                          ), 
                        ),
                        Container(
                          width: 80,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 240, 237, 237),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:Column(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: Colors.green,
                              ),
                              Text("SEATTLE")
                            ],
                          ), 
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 240, 240),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: CircularProgressIndicator(
                                  value: 1,
                                  strokeWidth: 16,
                                  color: const Color.fromARGB(255, 185, 183, 183),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                height: 150,
                                child: CircularProgressIndicator(
                                  value: 0.7,
                                  strokeWidth: 16,
                                  color: Colors.red,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "12",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 25
                                    ),
                                  ),
                                  Text("DAYS LEFT")
                                ],
                              )
            
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Next Eligibility",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("You're almost there! You'll be"),
                          Text("ready to save lives again on"),
                          Text(
                            "October 10",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700
                            ),
                          )
                          
                        ],
            
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context)=>EditProfile()
                          )

                        )
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Ink(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 244, 244, 244),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.person),
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right_outlined)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: ()=>{},
                      borderRadius: BorderRadius.circular(10),
                      child: Ink(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 252, 240, 239),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            Text(
                              "Log out",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.red
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: Colors.red,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}