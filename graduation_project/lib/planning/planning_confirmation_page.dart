import 'package:flutter/material.dart';

class PlanningConfirmationPage extends StatelessWidget {
  final String userName;
  final String destination;

  const PlanningConfirmationPage({Key? key, required this.userName, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Your Plan'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip Confirmation',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Destination: $destination'),
            Text('Planned by: $userName'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // تنفيذ تأكيد الرحلة
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip planned successfully!')),
                );
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}