import 'package:flutter/material.dart';

class PropertyRentPage extends StatelessWidget {
  final String destination; // Selected destination

  PropertyRentPage({required this.destination});

  @override
  Widget build(BuildContext context) {
    // Rental properties data based on destinations
    final Map<String, List<Map<String, String>>> rentalData = {
      "Dahab": [
        {
          "title": "شقة للإيجار",
          "price": "5,000 جنيه/شهر",
          "location": "دهب، مصر",
          "details": "120 م | 2 غرف | 1 حمام",
          "time": "منذ ساعتين",
          "image": "assets/rent_dahab1.jpg",
        },
        {
          "title": "فيلا للإيجار",
          "price": "15,000 جنيه/شهر",
          "location": "دهب، مصر",
          "details": "300 م | 4 غرف | 3 حمام",
          "time": "منذ يوم",
          "image": "assets/rent_dahab2.jpg",
        },
      ],
      "Saint Catherine": [
        {
          "title": "شقة للإيجار",
          "price": "3,500 جنيه/شهر",
          "location": "سانت كاترين، مصر",
          "details": "90 م | 2 غرف | 1 حمام",
          "time": "منذ 5 ساعات",
          "image": "assets/rent_saint1.jpg",
        },
      ],
      "Sharm El Sheikh": [
        {
          "title": "شقة للإيجار",
          "price": "8,000 جنيه/شهر",
          "location": "شرم الشيخ، مصر",
          "details": "150 م | 3 غرف | 2 حمام",
          "time": "منذ يومين",
          "image": "assets/rent_sharm1.jpg",
        },
        {
          "title": "فيلا للإيجار",
          "price": "20,000 جنيه/شهر",
          "location": "شرم الشيخ، مصر",
          "details": "400 م | 5 غرف | 4 حمام",
          "time": "منذ 4 ساعات",
          "image": "assets/rent_sharm2.jpg",
        },
      ],
      "El Tor": [
        {
          "title": "شقة للإيجار",
          "price": "2,500 جنيه/شهر",
          "location": "الطور، مصر",
          "details": "100 م | 2 غرف | 1 حمام",
          "time": "منذ 3 ساعات",
          "image": "assets/rent_tor1.jpg",
        },
      ],
    };

    // Properties for the selected destination
    final properties = rentalData[destination] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Rentals in $destination"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: properties.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final property = properties[index];
            return PropertyCard(
              title: property["title"]!,
              price: property["price"]!,
              location: property["location"]!,
              details: property["details"]!,
              time: property["time"]!,
              image: property["image"]!,
            );
          },
        ),
      )
          : Center(
        child: Text(
          "No rentals available in $destination.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String title;
  final String price;
  final String location;
  final String details;
  final String time;
  final String image;

  const PropertyCard({
    required this.title,
    required this.price,
    required this.location,
    required this.details,
    required this.time,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(
              image,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  // Price
                  Text(
                    price,
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Details
                  Text(
                    details,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  // Time
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
    );
  }
}