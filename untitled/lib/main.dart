import 'package:flutter/material.dart';
import 'login_page.dart';
import 'our_services_page.dart';
import 'globals.dart'; // استيراد المتغير isLoggedIn

// حالة تسجيل الدخول العامة

// بيانات المستخدم الافتراضية


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? OurServicesPage(
        userName: registeredName,
        userEmail: registeredEmail,
        userImage: userImage,
      )
          : DestinationsPage(),
    );
  }
}

class DestinationsPage extends StatefulWidget {
  final String? userName;
  final String? userEmail;

  const DestinationsPage({Key? key, this.userName, this.userEmail}) : super(key: key);

  @override
  _DestinationsPageState createState() => _DestinationsPageState();
}


class _DestinationsPageState extends State<DestinationsPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  static const List<Map<String, String>> destinations = [
    {
      'title': 'Saint Catherine',
      'description':
      'Saint Catherine is a serene destination in Egypt\'s Sinai, famous for Mount Sinai, the historic Saint Catherine\'s Monastery, and stunning mountainous landscapes. Perfect for hiking, camping, and exploring nature.',
      'image': 'assets/saint_catherine.jpg',
    },
    {
      'title': 'Dahab',
      'description':
      'Dahab, a charming town on Egypt\'s Sinai coast, is known for its laid-back vibe, golden beaches, and world-renowned diving spots like the Blue Hole.',
      'image': 'assets/dahab.jpg',
    },
    {
      'title': 'Sharm El Sheikh',
      'description':
      'Sharm El Sheikh, Egypt\'s premier Red Sea resort, is famous for its crystal-clear waters, vibrant coral reefs, and luxury resorts.',
      'image': 'assets/sharm.jpg',
    },
    {
      'title': 'El Tor',
      'description':
      'El Tor is a peaceful town on the Gulf of Suez, known for its serene beaches, historical significance, and stunning views of the mountains.',
      'image': 'assets/el_tor.jpg',
    },
  ];

  void goToNextPage() {
    if (currentPage < destinations.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for destinations
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return Stack(
                children: [
                  // Background Image
                  Image.asset(
                    destination['image']!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Content Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination['title']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          destination['description']!,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 24),
                        // Let's Go Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // التحقق من حالة تسجيل الدخول
                              if (isLoggedIn) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OurServicesPage(
                                      userName: registeredName, // تمرير اسم المستخدم
                                      userEmail: registeredEmail, // تمرير البريد الإلكتروني
                                      userImage: userImage, // تمرير صورة المستخدم
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Let's Go",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Navigation Buttons
          if (currentPage > 0)
            Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height / 2 - 40,
              child: IconButton(
                icon: Icon(Icons.arrow_upward, color: Colors.white, size: 32),
                onPressed: goToPreviousPage,
              ),
            ),
          if (currentPage < destinations.length - 1)
            Positioned(
              right: 16,
              bottom: MediaQuery.of(context).size.height / 2 - 40,
              child: IconButton(
                icon: Icon(Icons.arrow_downward, color: Colors.white, size: 32),
                onPressed: goToNextPage,
              ),
            ),
          // Page Indicators
          Positioned(
            bottom: 40,
            right: 24,
            child: Row(
              children: List.generate(
                destinations.length,
                    (dotIndex) => Container(
                  width: 12,
                  height: 12,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotIndex == currentPage
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
