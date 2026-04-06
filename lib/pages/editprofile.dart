import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final TextEditingController nameController = TextEditingController(text: "john doe");
  final TextEditingController emailController = TextEditingController(text: "john@gmail.com");
  final TextEditingController phoneController = TextEditingController(text: "0771234567");
  final TextEditingController weightController = TextEditingController(text: "60");
  final TextEditingController dateController = TextEditingController();

  String? selectDescrict;
  String? BloodType;
  String? Gender;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Edit profile",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsetsGeometry.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child:CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 50,
                      ), 
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Tap to change photo",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Full Name"),
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: nameController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(

                          filled: true,
                          fillColor: Colors.grey[50],

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          isDense: true,

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Email"),
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: emailController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          
                          filled: true,
                          fillColor: Colors.grey[50],

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Phone Number"),
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: emailController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          
                          filled: true,
                          fillColor: Colors.grey[50],

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          isDense: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("District"),
                    SizedBox(
                      height: 45 ,
                      child: DropdownButtonFormField<String>(

                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        isDense: true,
                        hint: Text("select District"),
                        value:selectDescrict,

                        decoration: InputDecoration(

                          filled: true,
                          fillColor: Colors.grey[50],

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        items: ['colombo','Gampaha']
                          .map((item)=>DropdownMenuItem(
                            value: item,
                            child: Text(item)
                          ))
                          .toList(),
                        onChanged: (value){
                          setState(() {
                            selectDescrict=value;
                          });
                        }
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Blood Type"),
                    SizedBox(
                      height: 45,
                      child: DropdownButtonFormField<String>(

                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        isDense: true,
                        hint: Text("select Blood Type"),
                        value:BloodType,

                        decoration: InputDecoration(

                          filled: true,
                          fillColor: Colors.grey[50],


                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),

                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        items: ['A+','A-','B+','B-','AB+','AB-','o+','o-']
                          .map((item)=>DropdownMenuItem(
                            value: item,
                            child: Text(item)
                          ))
                          .toList(),
                        onChanged: (value){
                          setState(() {
                            BloodType=value;
                          });
                        }
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Gender"),
                    SizedBox(
                      height: 45,
                      child: DropdownButtonFormField<String>(

                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(12),

                        isDense: true,
                        hint: Text("select Gender"),
                        value:Gender,
                        decoration: InputDecoration(

                          filled: true,
                          fillColor: Colors.grey[50],

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        items: ['Male','Female','Other']
                          .map((item)=>DropdownMenuItem(
                            value: item,
                            child: Text(item)
                          ))
                          .toList(),
                        onChanged: (value){
                          setState(() {
                            Gender=value;
                          });
                        }
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Date of Birth"),
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(

                          filled: true,
                          fillColor: Colors.grey[50],

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(), // prevents future dates
                          );
                          if (pickedDate != null) {
                            setState(() {
                              dateController.text =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            });
                          }
                      
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Weight(Kg)"),
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: weightController,
                        decoration: InputDecoration(

                          
                          filled: true,
                          fillColor: Colors.grey[50],

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          isDense: true
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text("Save Changes"),
                      ),
                    ),
                  ]
                ),
              

            ),
          ),
        )
      
    );
  }
}