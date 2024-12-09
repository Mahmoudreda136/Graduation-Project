import 'package:flutter/material.dart';

class HotelListPage extends StatelessWidget {
  final String destination; // Selected destination

  HotelListPage({required this.destination});

  @override
  Widget build(BuildContext context) {
    // Hotel data based on destinations
    final Map<String, List<Map<String, String>>> hotelData = {
      "Dahab": [
        {
          "name": "فندق دهب ريزورت",
          "price": "1,200 جنيه/ليلة",
          "location": "شاطئ دهب، دهب",
          "details": "إطلالة رائعة | حمام سباحة | قريب من الشاطئ",
          "time": "منذ 3 ساعات",
          "image": "assets/hotel1.jpg",
        },
        {
          "name": "فندق بلو هول",
          "price": "1,500 جنيه/ليلة",
          "location": "البلدة القديمة، دهب",
          "details": "قريب من بلو هول | غرف فاخرة",
          "time": "منذ يوم",
          "image": "assets/hotel2.jpg",
        },
      ],
      "Saint Catherine": [
        {
          "name": "فندق جبل موسى",
          "price": "800 جنيه/ليلة",
          "location": "قريب من دير سانت كاترين",
          "details": "غرف مريحة | موقع هادئ | قريب من الجبل",
          "time": "منذ 5 ساعات",
          "image": "assets/hotel3.jpg",
        },
      ],
      "Sharm El Sheikh": [
        {
          "name": "فندق خليج نعمة",
          "price": "2,500 جنيه/ليلة",
          "location": "خليج نعمة، شرم الشيخ",
          "details": "خدمة فاخرة | إطلالة على البحر",
          "time": "منذ يومين",
          "image": "assets/hotel4.jpg",
        },
        {
          "name": "فندق السلام",
          "price": "1,800 جنيه/ليلة",
          "location": "السلام، شرم الشيخ",
          "details": "غرف اقتصادية | قريب من الأسواق",
          "time": "منذ 8 ساعات",
          "image": "assets/hotel5.jpg",
        },
      ],
      "El Tor": [
        {
          "name": "فندق الطور السياحي",
          "price": "500 جنيه/ليلة",
          "location": "وسط الطور",
          "details": "سعر اقتصادي | غرف نظيفة",
          "time": "منذ 12 ساعة",
          "image": "assets/hotel6.jpg",
        },
      ],
    };

    // Hotels for the selected destination
    final hotels = hotelData[destination] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Hotels in $destination"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
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
              name: hotel["name"]!,
              price: hotel["price"]!,
              location: hotel["location"]!,
              details: hotel["details"]!,
              time: hotel["time"]!,
              image: hotel["image"]!,
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
  final String price;
  final String location;
  final String details;
  final String time;
  final String image;

  const HotelCard({
    required this.name,
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
          // Hotel image
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
                  // Hotel name
                  Text(
                    name,
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