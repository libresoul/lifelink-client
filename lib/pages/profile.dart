import 'package:flutter/material.dart';
import 'package:lifelink/core/storage/session_store.dart';
import 'package:lifelink/pages/editprofile.dart';
import 'package:lifelink/screens/onboarding/welcome.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _sessionStore = SessionStore();

  Future<void> _logout() async {
    await _sessionStore.clear();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Welcome()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  CircleAvatar(backgroundColor: Colors.black, radius: 50),
                  SizedBox(height: 10),
                  Text(
                    "John Doe",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 242, 235, 234),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    child: Text(
                      "0+  BLOOD GROUP",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 80,
                        width: 100,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "8",
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                            Text(
                              "TOTAL",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            Text(
                              "DONATIONS",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 100,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sept15",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text("LAST"),
                            Text("DONATION"),
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: Colors.green,
                            ),
                            Text(
                              "SEATTLE",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.4),
                        width: 1,
                      ),
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
                                color: const Color.fromARGB(255, 225, 223, 223),
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
                                    fontSize: 25,
                                  ),
                                ),
                                Text("DAYS LEFT"),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Next Eligibility",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("You're almost there! You'll be"),
                        Text("ready to save lives again on"),
                        Text(
                          "October 10",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfile()),
                      ),
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
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_right_outlined),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: _logout,
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
                          Icon(Icons.logout, color: Colors.red),
                          Text(
                            "Log out",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: Colors.red,
                          ),
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
    );
  }
}
