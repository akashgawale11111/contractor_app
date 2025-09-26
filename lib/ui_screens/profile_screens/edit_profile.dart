import 'package:contractor_app/ui_screens/home/nav_bar.dart/navbar.dart';
import 'package:contractor_app/ui_screens/home/nav_bar.dart/navbar2.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard when tapping outside
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontFamily: 'Roboto'),
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: Navbar2(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Profile Image
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(width * 0.02),
                      child: Container(
                        width: width * 0.35,
                        height: width * 0.35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.yellow.shade200,
                            width: width * 0.015,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/person_img.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Personal Details Title
                Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.025,
                    top: height * 0.02,
                  ),
                  child: Row(
                    children: const [
                      Text(
                        "Personal Details",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),

                // Name Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Name",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      SizedBox(
                        height: height * 0.05,
                        width: double.infinity,
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: "Pritesh Pawar",
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          style: const TextStyle(fontFamily: 'Roboto'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),

                // Contact Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Contact Details",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      SizedBox(
                        height: height * 0.05,
                        width: double.infinity,
                        child: TextField(
                          controller: contactController,
                          decoration: const InputDecoration(
                            hintText: "+91 8552011102",
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          style: const TextStyle(fontFamily: 'Roboto'),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height * 0.02),

                // Address Field
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Address",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      SizedBox(
                        height: height * 0.05,
                        width: double.infinity,
                        child: TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            hintText: "Nashik, Maharashtra",
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          style: const TextStyle(fontFamily: 'Roboto'),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
