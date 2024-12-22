import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'globalforrent.dart';

class HotelListPage extends StatelessWidget {
  final String destination;

  HotelListPage({required this.destination});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> hotels =
        RegionData.properties[destination]?['Hotels'] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Hotels in $destination"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: hotels.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotel = hotels[index];
            return HotelCard(
              name: hotel["user"]["name"] ?? "No Name",
              address: hotel["address"] ?? "No Address", // إضافة العنوان
              price: " ${hotel["price"] ?? "N/A"}",
              status: hotel["status"] ?? "Unknown",
              location: destination,
              details: hotel["details"] ?? "No Details",
              floor: "Floor: ${hotel["floor"] ?? "N/A"}",
              building: "Building: ${hotel["building_num"] ?? "N/A"}",
              apartment: "Apartment: ${hotel["apartment_num"] ?? "N/A"}",
              phone: hotel["user"]["phone"] ?? "No Contact",
              contractTerms: hotel["contract"]["terms"] ?? "No Terms",
              rentAmount: hotel["contract"]["rent_amount"] ?? "N/A",
              startDate: hotel["contract"]["start_date"] ?? "N/A",
              endDate: hotel["contract"]["end_date"] ?? "N/A",
              images: hotel["images"] ?? [],
              time: "Uploaded recently",
            );
          },
        ),
      )
          : Center(
        child: Text(
          "No hotels available in $destination.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

class HotelCard extends StatelessWidget {
  final String name;
  final String address; // الحقل الجديد للعنوان
  final String price;
  final String status;
  final String location;
  final String details;
  final String floor;
  final String building;
  final String apartment;
  final String phone;
  final String contractTerms;
  final String rentAmount;
  final String startDate;
  final String endDate;
  final List<dynamic> images;
  final String time;

  const HotelCard({
    required this.name,
    required this.address, // الحقل الجديد
    required this.price,
    required this.status,
    required this.location,
    required this.details,
    required this.floor,
    required this.building,
    required this.apartment,
    required this.phone,
    required this.contractTerms,
    required this.rentAmount,
    required this.startDate,
    required this.endDate,
    required this.images,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailsPage(
              name: name,
              address: address, // تمرير العنوان إلى صفحة التفاصيل
              price: price,
              status: status,
              details: details,
              phone: phone,
              contractTerms: contractTerms,
              rentAmount: rentAmount,
              startDate: startDate,
              endDate: endDate,
              images: images,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: _buildImage(images.isNotEmpty ? images[0] : null),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: $name",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Address: $address", // عرض العنوان
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Price: $price",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Phone: $phone",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Status: $status",
                      style: TextStyle(
                        fontSize: 14,
                        color: status == "Available" ? Colors.green : Colors.red,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Details: $details",
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Contract Terms: $contractTerms",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Rent Amount: $rentAmount",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Start Date: $startDate | End Date: $endDate",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Floor: $floor | Building: $building | Apartment: $apartment",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      time,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
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

  Widget _buildImage(dynamic image) {
    if (image != null) {
      if (image is Uint8List) {
        return Image.memory(
          image,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _placeholderImage();
          },
        );
      } else if (image is String) {
        return Image.asset(
          image,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _placeholderImage();
          },
        );
      }
    }
    return _placeholderImage();
  }

  Widget _placeholderImage() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey[300],
      child: Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}

class HotelDetailsPage extends StatelessWidget {
  final String name;
  final String address; // الحقل الجديد للعنوان
  final String price;
  final String status;
  final String details;
  final String phone;
  final String contractTerms;
  final String rentAmount;
  final String startDate;
  final String endDate;
  final List<dynamic> images;

  const HotelDetailsPage({
    required this.name,
    required this.address, // الحقل الجديد
    required this.price,
    required this.status,
    required this.details,
    required this.phone,
    required this.contractTerms,
    required this.rentAmount,
    required this.startDate,
    required this.endDate,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildImage(image),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: $name",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("Address: $address", // عرض العنوان
                      style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(price, style: TextStyle(fontSize: 16, color: Colors.blue)),
                  SizedBox(height: 8),
                  Text("Status: $status", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text("Details:", style: TextStyle(fontSize: 18)),
                  Text(details, style: TextStyle(fontSize: 14)),
                  SizedBox(height: 16),
                  Text("Contact:", style: TextStyle(fontSize: 18)),
                  Text(phone, style: TextStyle(fontSize: 14)),
                  SizedBox(height: 16),
                  Text("Contract Terms:", style: TextStyle(fontSize: 18)),
                  Text(contractTerms, style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text("Rent Amount: $rentAmount", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text("Start Date: $startDate", style: TextStyle(fontSize: 14)),
                  Text("End Date: $endDate", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 16),
                  Text("Location:", style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 300,

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(dynamic image) {
    if (image is Uint8List) {
      return Image.memory(
        image,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else if (image is String) {
      return Image.asset(
        image,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        width: 200,
        height: 200,
        color: Colors.grey[300],
        child: Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }
  }
}