import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome back",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    height: 1.0
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LIFEINK',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.red,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    Icon(Icons.notifications),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 16,
                          color: const Color.fromARGB(255, 242, 235, 235),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: 0.7,
                          strokeWidth: 16,
                          color: Colors.red,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        children: [
                          Text('Today, Apr 01'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "You can donate",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 25,
                              height: 1.0
                            ),
                          ),
                          Text(
                            "on July 01 ",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 25
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Instructions to get ready",
                            style: TextStyle(
                              color: Colors.red
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.red,
                          )
                        ],
                      )
                    
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Text("Nearby Campaigns"),
                    Icon(Icons.arrow_right_outlined)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Blood Donation Drive",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(
                            "View",
                            style: TextStyle(
                              color: Colors.red
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: Colors.grey,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Apr 28, 2026",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13
                                  ),
                                ),
                                TextSpan(
                                  text: " • ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextSpan(
                                  text: "10 am - 4pm",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.grey,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              "117/3 Gorge Gunawardhana Street,kurinagalla,srilanka",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13
                            
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Text("Your Donations"),
                    Icon(Icons.arrow_right_outlined)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.4),
                      width: 1,
                    ),
                    
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Blood Donation Drive",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(
                            "View",
                            style: TextStyle(
                              color: Colors.red
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: Colors.grey,
                            size: 16,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Apr 28, 2026",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13
                                  ),
                                ),
                                TextSpan(
                                  text: " • ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                TextSpan(
                                  text: "10 am - 4pm",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.grey,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              "117/3 Gorge Gunawardhana Street,kurinagalla,srilanka",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13
                            
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                

              ],
            ),
            
          
          ),

        ),
      )
    );
  }
}