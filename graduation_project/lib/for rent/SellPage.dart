import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:graduation_project/for%20rent/upload_image.dart';
import '../globals.dart';
import 'globalforrent.dart';
import 'rent_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellPage extends StatefulWidget {
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final TextEditingController fullAddressController = TextEditingController();
  final TextEditingController spaceController = TextEditingController();
  final TextEditingController numberOfRoomsController = TextEditingController();
  final TextEditingController floorNumController = TextEditingController();
  final TextEditingController buildingNumController = TextEditingController();
  final TextEditingController apartmentNumController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController contractTermsController = TextEditingController();
  final TextEditingController rentAmountController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  String selectedRegion = 'Dahab';
  String selectedCategory = 'Hotels';
  String selectedStatus = 'Available';

  List<Uint8List> uploadedImages = [];
  int currentStep = 0;
  bool _isLoading = false; // لإدارة حالة التحميل

  bool _validateFieldsForStep(int step) {
    switch (step) {
      case 0:
        return true; // لا يوجد حقول للتحقق في الخطوة الأولى
      case 1:
        return fullAddressController.text.isNotEmpty &&
            spaceController.text.isNotEmpty &&
            numberOfRoomsController.text.isNotEmpty &&
            floorNumController.text.isNotEmpty &&
            buildingNumController.text.isNotEmpty &&
            apartmentNumController.text.isNotEmpty &&
            priceController.text.isNotEmpty &&
            detailsController.text.isNotEmpty;
      case 2:
        return contractTermsController.text.isNotEmpty &&
            rentAmountController.text.isNotEmpty &&
            startDateController.text.isNotEmpty &&
            endDateController.text.isNotEmpty;
      case 3:
        return uploadedImages.isNotEmpty;
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

  Future<void> submitPropertyToAPI(Map<String, dynamic> property) async {
    setState(() {
      _isLoading = true; // بدء التحميل
    });

    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/properties'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(property),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(selectedRegion: selectedRegion),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to submit property. Status Code: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // إيقاف التحميل
      });
    }
  }

  void _submitProperty() {
    if (!_validateFieldsForStep(3)) {
      _showValidationError();
      return;
    }

    final user = {
      "name": registeredName,
      "national_id": registeredNationalId,
      "email": registeredEmail,
      "password": registeredPassword,
      "phone": registeredPhone,
    };

    final contract = {
      "terms": contractTermsController.text,
      "rent_amount": rentAmountController.text,
      "start_date": startDateController.text,
      "end_date": endDateController.text,
    };

    final newProperty = {
      "address": fullAddressController.text,
      "space": spaceController.text,
      "rooms": numberOfRoomsController.text,
      "floor": floorNumController.text,
      "building_num": buildingNumController.text,
      "apartment_num": apartmentNumController.text,
      "region": selectedRegion,
      "category": selectedCategory,
      "status": selectedStatus,
      "price": priceController.text,
      "details": detailsController.text,
      "images": uploadedImages.map((image) => base64Encode(image)).toList(), // تحويل الصور إلى base64
      "user": user,
      "contract": contract,
    };

    submitPropertyToAPI(newProperty);
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
        title: Text("Add Property", style: TextStyle(color: Colors.white)),
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
            if (_isLoading) return; // منع التحميل المتعدد
            if (!_validateFieldsForStep(currentStep)) {
              _showValidationError();
            } else if (currentStep < 3) {
              setState(() {
                currentStep++;
              });
            } else {
              _submitProperty();
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
              title: Text("User Details", style: TextStyle(color: Colors.brown[900])),
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
                    Text("Name: $registeredName", style: TextStyle(color: Colors.brown[900])),
                    Text("National ID: $registeredNationalId", style: TextStyle(color: Colors.brown[900])),
                    Text("Email: $registeredEmail", style: TextStyle(color: Colors.brown[900])),
                    Text("Phone: $registeredPhone", style: TextStyle(color: Colors.brown[900])),
                  ],
                ),
              ),
            ),
            Step(
              title: Text("Property Details", style: TextStyle(color: Colors.brown[900])),
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
                      controller: fullAddressController,
                      decoration: InputDecoration(
                        labelText: "Full Address",
                        prefixIcon: Icon(Icons.location_on, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: spaceController,
                      decoration: InputDecoration(
                        labelText: "Space (m²)",
                        prefixIcon: Icon(Icons.square_foot, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: numberOfRoomsController,
                      decoration: InputDecoration(
                        labelText: "Number of Rooms",
                        prefixIcon: Icon(Icons.room_preferences, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: floorNumController,
                      decoration: InputDecoration(
                        labelText: "Floor Number",
                        prefixIcon: Icon(Icons.stairs, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: buildingNumController,
                      decoration: InputDecoration(
                        labelText: "Building Number",
                        prefixIcon: Icon(Icons.business, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: apartmentNumController,
                      decoration: InputDecoration(
                        labelText: "Apartment Number",
                        prefixIcon: Icon(Icons.apartment, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: "Price",
                        prefixIcon: Icon(Icons.attach_money, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: detailsController,
                      decoration: InputDecoration(
                        labelText: "Details",
                        prefixIcon: Icon(Icons.description, color: Colors.brown[800]),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedRegion,
                      items: ['Dahab', 'Saint Catherine', 'Sharm El Sheikh', 'El Tor']
                          .map((region) => DropdownMenuItem(
                        value: region,
                        child: Text(region, style: TextStyle(color: Colors.brown[900])),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Select Region",
                        prefixIcon: Icon(Icons.map, color: Colors.brown[800]),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: ['Hotels', 'For Rent', 'For Sale']
                          .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category, style: TextStyle(color: Colors.brown[900])),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Select Category",
                        prefixIcon: Icon(Icons.category, color: Colors.brown[800]),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: ['Available', 'Sold', 'Rented']
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status, style: TextStyle(color: Colors.brown[900])),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Select Status",
                        prefixIcon: Icon(Icons.flag, color: Colors.brown[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Step(
              title: Text("Contract Details", style: TextStyle(color: Colors.brown[900])),
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
                    TextField(
                      controller: contractTermsController,
                      decoration: InputDecoration(
                        labelText: "Contract Terms",
                        prefixIcon: Icon(Icons.article, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: rentAmountController,
                      decoration: InputDecoration(
                        labelText: "Rent Amount",
                        prefixIcon: Icon(Icons.money, color: Colors.brown[800]),
                      ),
                    ),
                    TextField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        labelText: "Start Date",
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.brown[800]),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          startDateController.text = "${picked.toLocal()}".split(' ')[0];
                        }
                      },
                    ),
                    TextField(
                      controller: endDateController,
                      decoration: InputDecoration(
                        labelText: "End Date",
                        prefixIcon: Icon(Icons.calendar_today, color: Colors.brown[800]),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          endDateController.text = "${picked.toLocal()}".split(' ')[0];
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Step(
              title: Text("Upload Images", style: TextStyle(color: Colors.brown[900])),
              isActive: currentStep >= 3,
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
  final String selectedRegion;

  SuccessPage({required this.selectedRegion});

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
                "Property added successfully!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown[900]),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForRentHomePage(
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