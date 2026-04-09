import 'package:flutter/material.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/core/storage/session_store.dart';

class EditProfile extends StatefulWidget {
  final DonorProfile donor;
  const EditProfile({super.key, required this.donor});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? selectDescrict;
  String? BloodType;
  String? Gender;

  // canonical option lists used by dropdowns
  final List<String> districts = ['Colombo', 'Gampaha'];
  final List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  final List<String> genders = ['Male', 'Female', 'Other'];

  bool _isSaving = false;

  final _api = ApiClient();
  final _store = SessionStore();

  @override
  void initState() {
    super.initState();

    // Prefill controllers from donor once during init
    nameController.text = widget.donor.fullName ?? '';
    emailController.text = widget.donor.email ?? '';
    phoneController.text = widget.donor.phoneNumber ?? '';
    weightController.text = widget.donor.weightKg?.toString() ?? '';
    dateController.text = widget.donor.dateOfBirth ?? '';

    // safe matching of server values to canonical lists; if no exact match,
    // leave null so the dropdown shows the hint instead of throwing.
    selectDescrict = _safeValue(districts, widget.donor.district);
    BloodType = _safeValue(bloodTypes, widget.donor.bloodType);
    Gender = _safeValue(genders, widget.donor.gender);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    weightController.dispose();
    dateController.dispose();
    super.dispose();
  }

  // Helper to safely choose a value that exists exactly once in options
  String? _safeValue(List<String> options, String? v) {
    if (v == null) return null;
    final exact = options.where((o) => o == v).toList();
    if (exact.length == 1) return exact.first;

    final ci = options
        .where((o) => o.toLowerCase() == v.toLowerCase())
        .toList();
    if (ci.length == 1) return ci.first;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // use canonical lists from state
    // dropdown values are the already-canonical selections if any
    final districtValue = selectDescrict;
    final bloodTypeValue = BloodType;
    final genderValue = Gender;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit profile", style: TextStyle(fontSize: 20)),
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
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 50,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Tap to change photo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  ),
                ),
                SizedBox(height: 30),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Phone Number"),
                SizedBox(
                  height: 45,
                  child: TextField(
                    controller: phoneController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text("District"),
                SizedBox(
                  height: 45,
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    isDense: true,
                    hint: Text("select District"),
                    value: districtValue,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    items: List.generate(districts.length, (i) {
                      return DropdownMenuItem<String>(
                        value: districts[i],
                        child: Text(districts[i]),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectDescrict = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text("Blood Type"),
                SizedBox(
                  height: 45,
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    isDense: true,
                    hint: Text("select Blood Type"),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    items: List.generate(bloodTypes.length, (i) {
                      return DropdownMenuItem<String>(
                        value: bloodTypes[i],
                        child: Text(bloodTypes[i]),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        BloodType = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text("Gender"),
                SizedBox(
                  height: 45,
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(12),

                    isDense: true,
                    hint: Text("select Gender"),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[50],

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                    items: List.generate(genders.length, (i) {
                      return DropdownMenuItem<String>(
                        value: genders[i],
                        child: Text(genders[i]),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        Gender = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
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
                        borderRadius: BorderRadius.circular(10),
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
                SizedBox(height: 20),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: _isSaving
                        ? null
                        : () async {
                            // Validate inputs
                            final phone = phoneController.text.trim();
                            // Preserve original donor values if user didn't pick a canonical option
                            final district =
                                selectDescrict ?? widget.donor.district ?? '';
                            final bloodType =
                                BloodType ?? widget.donor.bloodType ?? '';
                            final gender = Gender ?? widget.donor.gender ?? '';
                            final dob = dateController.text.trim();
                            final weight =
                                double.tryParse(weightController.text.trim()) ??
                                0.0;

                            if (phone.isEmpty ||
                                district.isEmpty ||
                                bloodType.isEmpty ||
                                gender.isEmpty ||
                                dob.isEmpty ||
                                weight <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please fill all fields correctly',
                                  ),
                                ),
                              );
                              return;
                            }

                            final userId = await _store.getUserId();
                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('No active session'),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              _isSaving = true;
                            });
                            try {
                              await _api.registerDetails(
                                userId: userId,
                                phoneNumber: phone,
                                district: district,
                                bloodType: bloodType,
                                gender: gender,
                                dateOfBirth: dob,
                                weightKg: weight,
                              );

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile updated'),
                                  ),
                                );
                                Navigator.of(context).pop(true);
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Failed to save details: ${e.toString()}',
                                    ),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isSaving = false;
                                });
                              }
                            }
                          },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text("Save Changes"),
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
