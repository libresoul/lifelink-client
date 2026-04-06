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
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)
                        )
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Email"),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)
                        )
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Phone Number"),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)
                        )
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("District"),
                    DropdownButtonFormField<String>(
                      hint: Text("select District"),
                      initialValue:selectDescrict,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)
                        )
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
                    SizedBox(
                      height: 20,
                    ),
                    Text("Blood Type"),
                    DropdownButtonFormField<String>(
                      hint: Text("select Blood Type"),
                      initialValue:BloodType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)
                        )
                      ),
                      items: ['A','A+']
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
                    SizedBox(
                      height: 20,
                    ),
                    Text("Gender"),
                    DropdownButtonFormField<String>(
                      hint: Text("select Gender"),
                      initialValue:Gender,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)
                        )
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
                    SizedBox(
                      height: 20,
                    ),
                    Text("Date of Birth"),
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)
                        ),
                        suffixIcon: Icon(Icons.calendar_today),
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
                    SizedBox(
                      height: 20,
                    ),
                    Text("Weight(Kg)"),
                    TextField(
                      controller: weightController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13)
                        )
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
                            borderRadius: BorderRadius.circular(13),
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