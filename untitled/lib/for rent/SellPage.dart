import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:untitled/for%20rent/upload_image.dart';
import '../globals.dart';
import 'globalforrent.dart';
import 'rent_page.dart';

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

  bool _validateFieldsForStep(int step) {
    switch (step) {
      case 0:
        return true; // No fields to validate for user details
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
        backgroundColor: Colors.black,
      ),
    );
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
      "images": uploadedImages,
      "user": user,
      "contract": contract,
    };

    if (!RegionData.properties.containsKey(selectedRegion)) {
      RegionData.properties[selectedRegion] = {};
    }

    if (!RegionData.properties[selectedRegion]!.containsKey(selectedCategory)) {
      RegionData.properties[selectedRegion]![selectedCategory] = [];
    }

    RegionData.properties[selectedRegion]![selectedCategory]!.add(newProperty);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessPage(selectedRegion: selectedRegion),
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
        title: Text("Add Property"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
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
            title: Text("User Details"),
            isActive: currentStep >= 0,
            content: Column(
              children: [
                Text("Name: $registeredName"),
                Text("National ID: $registeredNationalId"),
                Text("Email: $registeredEmail"),
                Text("Phone: $registeredPhone"),
              ],
            ),
          ),
          Step(
            title: Text("Property Details"),
            isActive: currentStep >= 1,
            content: Column(
              children: [
                TextField(
                  controller: fullAddressController,
                  decoration: InputDecoration(labelText: "Full Address"),
                ),
                TextField(
                  controller: spaceController,
                  decoration: InputDecoration(labelText: "Space (m²)"),
                ),
                TextField(
                  controller: numberOfRoomsController,
                  decoration: InputDecoration(labelText: "Number of Rooms"),
                ),
                TextField(
                  controller: floorNumController,
                  decoration: InputDecoration(labelText: "Floor Number"),
                ),
                TextField(
                  controller: buildingNumController,
                  decoration: InputDecoration(labelText: "Building Number"),
                ),
                TextField(
                  controller: apartmentNumController,
                  decoration: InputDecoration(labelText: "Apartment Number"),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: "Price"),
                ),
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(labelText: "Details"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedRegion,
                  items: ['Dahab', 'Saint Catherine', 'Sharm El Sheikh', 'El Tor']
                      .map((region) => DropdownMenuItem(
                    value: region,
                    child: Text(region),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRegion = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: "Select Region"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: ['Hotels', 'For Rent', 'For Sale']
                      .map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: "Select Category"),
                ),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items: ['Available', 'Sold', 'Rented']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: "Select Status"),
                ),
              ],
            ),
          ),
          Step(
            title: Text("Contract Details"),
            isActive: currentStep >= 2,
            content: Column(
              children: [
                TextField(
                  controller: contractTermsController,
                  decoration: InputDecoration(labelText: "Contract Terms"),
                ),
                TextField(
                  controller: rentAmountController,
                  decoration: InputDecoration(labelText: "Rent Amount"),
                ),
                TextField(
                  controller: startDateController,
                  decoration: InputDecoration(labelText: "Start Date"),
                ),
                TextField(
                  controller: endDateController,
                  decoration: InputDecoration(labelText: "End Date"),
                ),
              ],
            ),
          ),
          Step(
            title: Text("Upload Images"),
            isActive: currentStep >= 3,
            content: Column(
              children: [
                Text(
                  uploadedImages.isNotEmpty
                      ? "Uploaded Images: ${uploadedImages.length}"
                      : "No images uploaded yet.",
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                ),
                ElevatedButton(
                  onPressed: _navigateToUploadImagesPage,
                  child: Text("Upload Images"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 16),
            Text(
              "Property added successfully!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForRentHomePage(
                      selectedRegion: selectedRegion, // القيمة المختارة للمنطقة
                      userName: registeredName,       // اسم المستخدم
                      destination: selectedRegion,    // تمرير المنطقة كوجهة
                    ),
                  ),
                      (route) => false,
                );
              },
              child: Text("Back to Home"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}