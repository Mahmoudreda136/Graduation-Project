import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; // استيراد حزمة http
import 'dart:convert'; // لتحويل JSON

class PropertyListPage extends StatefulWidget {
  final String destination;

  PropertyListPage({required this.destination});

  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  List<Map<String, dynamic>> properties = [];
  List<Map<String, dynamic>> filteredProperties = [];
  String searchPlaceName = '';
  String searchPrice = '';

  @override
  void initState() {
    super.initState();
    fetchProperties(); // جلب البيانات من API عند بدء التشغيل
  }

  // دالة لجلب العقارات من API
  Future<void> fetchProperties() async {
    final response = await http.get(
      Uri.parse('https://your-api-endpoint.com/properties?destination=${widget.destination}'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        properties = List<Map<String, dynamic>>.from(data);
        filteredProperties = List.from(properties);
      });
    } else {
      throw Exception('Failed to load properties');
    }
  }

  void applyFilters() {
    setState(() {
      filteredProperties = properties.where((property) {
        final placeNameMatch = property["address"]
            .toString()
            .toLowerCase()
            .contains(searchPlaceName.toLowerCase());
        final priceMatch = property["price"]
            .toString()
            .toLowerCase()
            .contains(searchPrice.toLowerCase());
        return placeNameMatch && priceMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Properties for Sale in ${widget.destination}"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by Place Name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchPlaceName = value;
                    });
                    applyFilters();
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Filter by Price (e.g., 1000)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      searchPrice = value;
                    });
                    applyFilters();
                  },
                ),
              ],
            ),
          ),
          // Property List
          Expanded(
            child: filteredProperties.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: filteredProperties.length,
                itemBuilder: (context, index) {
                  final property = filteredProperties[index];
                  return PropertyCard(
                    name: property["user"]["name"] ?? "No Name",
                    phone: property["user"]["phone"] ?? "No Contact",
                    address: property["address"] ?? "No Address",
                    price: "Price: ${property["price"] ?? "N/A"}",
                    status: property["status"] ?? "Unknown",
                    details: property["details"] ?? "No Details",
                    contractTerms:
                    property["contract"]["terms"] ?? "No Terms",
                    rentAmount:
                    property["contract"]["rent_amount"] ?? "N/A",
                    startDate:
                    property["contract"]["start_date"] ?? "N/A",
                    endDate: property["contract"]["end_date"] ?? "N/A",
                    floor: "Floor: ${property["floor"] ?? "N/A"}",
                    building:
                    "Building: ${property["building_num"] ?? "N/A"}",
                    apartment:
                    "Apartment: ${property["apartment_num"] ?? "N/A"}",
                    time: "Uploaded recently",
                    images: property["images"] ?? [],
                  );
                },
              ),
            )
                : Center(
              child: Text(
                "No properties found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final String price;
  final String status;
  final String details;
  final String contractTerms;
  final String rentAmount;
  final String startDate;
  final String endDate;
  final String floor;
  final String building;
  final String apartment;
  final String time;
  final List<dynamic> images;

  const PropertyCard({
    required this.name,
    required this.phone,
    required this.address,
    required this.price,
    required this.status,
    required this.details,
    required this.contractTerms,
    required this.rentAmount,
    required this.startDate,
    required this.endDate,
    required this.floor,
    required this.building,
    required this.apartment,
    required this.time,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailsPage(
              name: name,
              phone: phone,
              address: address,
              price: price,
              status: status,
              details: details,
              contractTerms: contractTerms,
              rentAmount: rentAmount,
              startDate: startDate,
              endDate: endDate,
              floor: floor,
              building: building,
              apartment: apartment,
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
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Address: $address",
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
        return Image.network( // استخدام Image.network للصور من الإنترنت
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

class PropertyDetailsPage extends StatelessWidget {
  final String name;
  final String phone;
  final String address;
  final String price;
  final String status;
  final String details;
  final String contractTerms;
  final String rentAmount;
  final String startDate;
  final String endDate;
  final String floor;
  final String building;
  final String apartment;
  final List<dynamic> images;

  const PropertyDetailsPage({
    required this.name,
    required this.phone,
    required this.address,
    required this.price,
    required this.status,
    required this.details,
    required this.contractTerms,
    required this.rentAmount,
    required this.startDate,
    required this.endDate,
    required this.floor,
    required this.building,
    required this.apartment,
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
                  Text("Address: $address",
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
      return Image.network( // استخدام Image.network للصور من الإنترنت
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