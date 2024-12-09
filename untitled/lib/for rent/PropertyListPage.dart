import 'package:flutter/material.dart';

class PropertyListPage extends StatelessWidget {
  final String destination; // The selected destination

  PropertyListPage({required this.destination});

  @override
  Widget build(BuildContext context) {
    // Properties data based on destinations
    final Map<String, List<Map<String, String>>> propertyData = {
      "Dahab": [
        {
          "title": "شقة للبيع",
          "price": "600,000 جنيه",
          "location": "دهب، مصر",
          "details": "200 م | 3 غرف | 2 حمام",
          "time": "منذ 4 ساعات",
          "image": "assets/dahab_property1.jpg",
        },
        {
          "title": "فيلا للبيع",
          "price": "1,200,000 جنيه",
          "location": "دهب، مصر",
          "details": "350 م | 5 غرف | 4 حمام",
          "time": "منذ يوم",
          "image": "assets/dahab_property2.jpg",
        },
      ],
      "Saint Catherine": [
        {
          "title": "شقة للبيع",
          "price": "400,000 جنيه",
          "location": "سانت كاترين، مصر",
          "details": "150 م | 2 غرف | 1 حمام",
          "time": "منذ 6 ساعات",
          "image": "assets/saint_property1.jpg",
        },
      ],
      "Sharm El Sheikh": [
        {
          "title": "فيلا للبيع",
          "price": "2,000,000 جنيه",
          "location": "شرم الشيخ، مصر",
          "details": "500 م | 6 غرف | 5 حمام",
          "time": "منذ 3 أيام",
          "image": "assets/sharm_property1.jpg",
        },
      ],
      "El Tor": [
        {
          "title": "شقة للبيع",
          "price": "300,000 جنيه",
          "location": "الطور، مصر",
          "details": "120 م | 2 غرف | 1 حمام",
          "time": "منذ 8 ساعات",
          "image": "assets/tor_property1.jpg",
        },
      ],
    };

    // Properties for the selected destination
    final properties = propertyData[destination] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Properties in $destination"),
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
          "No properties available in $destination.",
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
                  // Property title
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  // Price
                  Text(
                    price,
                    style: TextStyle(fontSize: 14, color: Colors.green[700]),
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