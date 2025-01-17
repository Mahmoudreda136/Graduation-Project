import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // استيراد حزمة http
import 'dart:convert'; // لتحويل JSON

class AddEditPropertyDialog extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? property;
  final Function(Map<String, dynamic>) onConfirm;

  AddEditPropertyDialog({
    required this.title,
    this.property,
    required this.onConfirm,
  });

  @override
  _AddEditPropertyDialogState createState() => _AddEditPropertyDialogState();
}

class _AddEditPropertyDialogState extends State<AddEditPropertyDialog> {
  late TextEditingController addressController;
  late TextEditingController spaceController;
  late TextEditingController numberOfRoomsController;
  late TextEditingController floorController;
  late TextEditingController buildingController;
  late TextEditingController apartmentController;
  late TextEditingController priceController;
  late TextEditingController detailsController;
  late TextEditingController contractTermsController;
  late TextEditingController rentAmountController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  String selectedStatus = "Available"; // الحالة الافتراضية

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.property?["address"] ?? "");
    spaceController = TextEditingController(text: widget.property?["space"] ?? "");
    numberOfRoomsController = TextEditingController(text: widget.property?["rooms"] ?? "");
    floorController = TextEditingController(text: widget.property?["floor"] ?? "");
    buildingController = TextEditingController(text: widget.property?["building_num"] ?? "");
    apartmentController = TextEditingController(text: widget.property?["apartment_num"] ?? "");
    priceController = TextEditingController(text: widget.property?["price"]?.toString() ?? "");
    detailsController = TextEditingController(text: widget.property?["details"] ?? "");
    contractTermsController = TextEditingController(text: widget.property?["contract"]?["terms"] ?? "");
    rentAmountController = TextEditingController(text: widget.property?["contract"]?["rent_amount"] ?? "");
    startDateController = TextEditingController(text: widget.property?["contract"]?["start_date"] ?? "");
    endDateController = TextEditingController(text: widget.property?["contract"]?["end_date"] ?? "");

    // تعيين الحالة الحالية إن وجدت
    selectedStatus = widget.property?["status"] ?? "Available";
  }

  // دالة لتحديث العقار على الخادم
  Future<void> updateProperty(Map<String, dynamic> updatedProperty) async {
    final response = await http.put(
      Uri.parse('https://your-api-endpoint.com/properties/${widget.property?["id"]}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedProperty),
    );

    if (response.statusCode == 200) {
      widget.onConfirm(updatedProperty); // إرجاع البيانات المحدثة
    } else {
      throw Exception('Failed to update property');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Address"),
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
              controller: floorController,
              decoration: InputDecoration(labelText: "Floor"),
            ),
            TextField(
              controller: buildingController,
              decoration: InputDecoration(labelText: "Building Number"),
            ),
            TextField(
              controller: apartmentController,
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
              value: selectedStatus,
              items: ["Available", "Sold", "Rented"]
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
              decoration: InputDecoration(labelText: "Status"),
            ),
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final updatedProperty = {
              "address": addressController.text.isNotEmpty
                  ? addressController.text
                  : widget.property?["address"],
              "space": spaceController.text.isNotEmpty
                  ? spaceController.text
                  : widget.property?["space"],
              "rooms": numberOfRoomsController.text.isNotEmpty
                  ? numberOfRoomsController.text
                  : widget.property?["rooms"],
              "floor": floorController.text.isNotEmpty
                  ? floorController.text
                  : widget.property?["floor"],
              "building_num": buildingController.text.isNotEmpty
                  ? buildingController.text
                  : widget.property?["building_num"],
              "apartment_num": apartmentController.text.isNotEmpty
                  ? apartmentController.text
                  : widget.property?["apartment_num"],
              "price": priceController.text.isNotEmpty
                  ? priceController.text
                  : widget.property?["price"],
              "details": detailsController.text.isNotEmpty
                  ? detailsController.text
                  : widget.property?["details"],
              "status": selectedStatus,
              "contract": {
                "terms": contractTermsController.text.isNotEmpty
                    ? contractTermsController.text
                    : widget.property?["contract"]?["terms"],
                "rent_amount": rentAmountController.text.isNotEmpty
                    ? rentAmountController.text
                    : widget.property?["contract"]?["rent_amount"],
                "start_date": startDateController.text.isNotEmpty
                    ? startDateController.text
                    : widget.property?["contract"]?["start_date"],
                "end_date": endDateController.text.isNotEmpty
                    ? endDateController.text
                    : widget.property?["contract"]?["end_date"],
              },
            };

            await updateProperty(updatedProperty); // تحديث العقار على الخادم
            Navigator.pop(context);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}