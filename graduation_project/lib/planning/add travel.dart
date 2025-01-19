import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'upload photo.dart';
import '../globals.dart';
import 'planning_page.dart';
import 'program_provider.dart';

class RegionData {
  static Map<String, List<Map<String, dynamic>>> companies = {};
}

class CompanyRegistrationPage extends StatefulWidget {
  @override
  _CompanyRegistrationPageState createState() => _CompanyRegistrationPageState();
}

class _CompanyRegistrationPageState extends State<CompanyRegistrationPage> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController telegramController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();

  final TextEditingController programNameController = TextEditingController();
  final TextEditingController programDescriptionController = TextEditingController();
  final TextEditingController programPriceController = TextEditingController();
  final TextEditingController programDurationController = TextEditingController();
  final TextEditingController programStartDateController = TextEditingController();
  final TextEditingController programEndDateController = TextEditingController();

  List<Uint8List> uploadedImages = [];
  int currentStep = 0;

  // إضافة المتغيرات المطلوبة
  final String selectedRegion = "Dahab"; // يمكن تغيير القيمة حسب الحاجة
  final String registeredName = "User Name"; // يمكن تغيير القيمة حسب الحاجة

  bool _validateFieldsForStep(int step) {
    switch (step) {
      case 0:
      // Validate Company Details
        final isStep0Valid = companyNameController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            facebookController.text.isNotEmpty &&
            telegramController.text.isNotEmpty &&
            whatsappController.text.isNotEmpty &&
            instagramController.text.isNotEmpty &&
            addressController.text.isNotEmpty &&
            licenseController.text.isNotEmpty;

        if (!isStep0Valid) {
          print("Validation failed for Step 0. Missing fields:");
          if (companyNameController.text.isEmpty) print("Company Name");
          if (emailController.text.isEmpty) print("Email");
          if (phoneController.text.isEmpty) print("Phone");
          if (facebookController.text.isEmpty) print("Facebook");
          if (telegramController.text.isEmpty) print("Telegram");
          if (whatsappController.text.isEmpty) print("WhatsApp");
          if (instagramController.text.isEmpty) print("Instagram");
          if (addressController.text.isEmpty) print("Address");
          if (licenseController.text.isEmpty) print("License");
        }

        return isStep0Valid;

      case 1:
      // Validate Program Details
        final isStep1Valid = programNameController.text.isNotEmpty &&
            programDescriptionController.text.isNotEmpty &&
            programPriceController.text.isNotEmpty &&
            programDurationController.text.isNotEmpty &&
            programStartDateController.text.isNotEmpty &&
            programEndDateController.text.isNotEmpty;

        if (!isStep1Valid) {
          print("Validation failed for Step 1. Missing fields:");
          if (programNameController.text.isEmpty) print("Program Name");
          if (programDescriptionController.text.isEmpty) print("Program Description");
          if (programPriceController.text.isEmpty) print("Program Price");
          if (programDurationController.text.isEmpty) print("Program Duration");
          if (programStartDateController.text.isEmpty) print("Program Start Date");
          if (programEndDateController.text.isEmpty) print("Program End Date");
        }

        return isStep1Valid;

      case 2:
      // Validate Uploaded Images
        final isStep2Valid = uploadedImages.isNotEmpty;

        if (!isStep2Valid) {
          print("Validation failed for Step 2. No images uploaded.");
        }

        return isStep2Valid;

      default:
        return false;
    }
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Please fill out all required fields."),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _submitCompanyRegistration() {
    if (!_validateFieldsForStep(2)) {
      _showValidationError();
      return;
    }

    final company = {
      "name": companyNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "facebook": facebookController.text,
      "telegram": telegramController.text,
      "whatsapp": whatsappController.text,
      "instagram": instagramController.text,
      "address": addressController.text,
      "license": licenseController.text,
    };

    final program = {
      "name": programNameController.text,
      "description": programDescriptionController.text,
      "price": programPriceController.text,
      "duration": programDurationController.text,
      "start_date": programStartDateController.text,
      "end_date": programEndDateController.text,
      "images": uploadedImages,
    };

    // إضافة الشركة والبرنامج إلى RegionData
    if (!RegionData.companies.containsKey(companyNameController.text)) {
      RegionData.companies[companyNameController.text] = [];
    }

    RegionData.companies[companyNameController.text]!.add(program);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPage(
          companyName: companyNameController.text,
          selectedRegion: selectedRegion,
          registeredName: registeredName,
        ),
      ),
    );
  }

  Future<void> _navigateToUploadImagesPage() async {
    final images = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadImagesPage(
          onImagesUploaded: (uploadedImages) {
            setState(() {
              this.uploadedImages = uploadedImages;
            });
          },
        ),
      ),
    );

    if (images != null && images is List<Uint8List>) {
      setState(() {
        uploadedImages = images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Company Registration", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown[50]!, Colors.brown[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stepper(
          currentStep: currentStep,
          onStepContinue: () {
            if (!_validateFieldsForStep(currentStep)) {
              _showValidationError();
            } else if (currentStep < 2) {
              setState(() {
                currentStep++;
              });
            } else {
              _submitCompanyRegistration();
            }
          },
          onStepCancel: () {
            if (currentStep > 0) {
              setState(() {
                currentStep--;
              });
            }
          },
          steps: [
            Step(
              title: Text("Company Details", style: TextStyle(color: Colors.brown[900])),
              isActive: currentStep >= 0,
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: companyNameController,
                      decoration: InputDecoration(
                        labelText: "Company Name",
                        prefixIcon: Icon(Icons.business, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        prefixIcon: Icon(Icons.phone, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: facebookController,
                      decoration: InputDecoration(
                        labelText: "Facebook",
                        prefixIcon: Icon(Icons.facebook, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: telegramController,
                      decoration: InputDecoration(
                        labelText: "Telegram",
                        prefixIcon: Icon(Icons.telegram, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: whatsappController,
                      decoration: InputDecoration(
                        labelText: "WhatsApp",
                        prefixIcon: Icon(Icons.call, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: instagramController,
                      decoration: InputDecoration(
                        labelText: "Instagram",
                        prefixIcon: Icon(Icons.camera_alt, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: Icon(Icons.location_on, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: licenseController,
                      decoration: InputDecoration(
                        labelText: "License",
                        prefixIcon: Icon(Icons.assignment, color: Colors.brown[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Step(
              title: Text("Program Details", style: TextStyle(color: Colors.brown[900])),
              isActive: currentStep >= 1,
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: programNameController,
                      decoration: InputDecoration(
                        labelText: "Program Name",
                        prefixIcon: Icon(Icons.title, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: programDescriptionController,
                      decoration: InputDecoration(
                        labelText: "Program Description",
                        prefixIcon: Icon(Icons.description, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: programPriceController,
                      decoration: InputDecoration(
                        labelText: "Program Price",
                        prefixIcon: Icon(Icons.attach_money, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: programDurationController,
                      decoration: InputDecoration(
                        labelText: "Program Duration",
                        prefixIcon: Icon(Icons.timer, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: programStartDateController,
                      decoration: InputDecoration(
                        labelText: "Start Date",
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: programEndDateController,
                      decoration: InputDecoration(
                        labelText: "End Date",
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.brown[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Step(
              title: Text("Upload Images", style: TextStyle(color: Colors.brown[900])),
              isActive: currentStep >= 2,
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      uploadedImages.isNotEmpty
                          ? "Uploaded Images: ${uploadedImages.length}"
                          : "No images uploaded yet.",
                      style: TextStyle(fontSize: 16, color: Colors.brown[900]),
                    ),
                    ElevatedButton(
                      onPressed: _navigateToUploadImagesPage,
                      child: Text("Upload Images"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[800],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  final String companyName;
  final String selectedRegion;
  final String registeredName;

  SuccessPage({
    required this.companyName,
    required this.selectedRegion,
    required this.registeredName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown[50]!, Colors.brown[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.brown[800], size: 100),
              SizedBox(height: 16),
              Text(
                "Company registered successfully!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown[900]),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanningHomePage(
                        selectedRegion: selectedRegion,
                        userName: registeredName,
                        destination: selectedRegion,
                      ),
                    ),
                        (route) => false,
                  );
                },
                child: Text("Back to Home", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[800],
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}