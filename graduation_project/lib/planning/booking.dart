import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'program_provider.dart';

class CompanyListPage extends StatefulWidget {
  final String destination;

  CompanyListPage({required this.destination});

  @override
  _CompanyListPageState createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  late List<Map<String, dynamic>> companies;
  List<Map<String, dynamic>> filteredCompanies = [];
  String searchCompanyName = '';
  String searchProgramPrice = '';

  @override
  void initState() {
    super.initState();
    companies = RegionData.companies[widget.destination]?['Hotels'] ?? [];
    filteredCompanies = List.from(companies);
  }

  void applyFilters() {
    setState(() {
      filteredCompanies = companies.where((company) {
        final companyNameMatch = company["name"]
            .toString()
            .toLowerCase()
            .contains(searchCompanyName.toLowerCase());
        final programPriceMatch = company["programs"].any((program) =>
            program["price"]
                .toString()
                .toLowerCase()
                .contains(searchProgramPrice.toLowerCase()));
        return companyNameMatch && programPriceMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text("Companies in ${widget.destination}"),
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
                    labelText: 'Search by Company Name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchCompanyName = value;
                    });
                    applyFilters();
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Filter by Program Price (e.g., 1000)',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      searchProgramPrice = value;
                    });
                    applyFilters();
                  },
                ),
              ],
            ),
          ),
          // Company List
          Expanded(
            child: filteredCompanies.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: filteredCompanies.length,
                itemBuilder: (context, index) {
                  final company = filteredCompanies[index];
                  return CompanyCard(
                    name: company["name"] ?? "No Name",
                    email: company["email"] ?? "No Email",
                    phone: company["phone"] ?? "No Phone",
                    address: company["address"] ?? "No Address",
                    license: company["license"] ?? "No License",
                    programs: company["programs"] ?? [],
                  );
                },
              ),
            )
                : Center(
              child: Text(
                "No companies found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String license;
  final List<dynamic> programs;

  const CompanyCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.license,
    required this.programs,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailsPage(
              name: name,
              email: email,
              phone: phone,
              address: address,
              license: license,
              programs: programs,
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
                      "Email: $email",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Phone: $phone",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Address: $address",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "License: $license",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Programs:",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    ...programs.map((program) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          "- ${program["program_name"]} (${program["price"]})",
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      );
                    }).toList(),
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

class CompanyDetailsPage extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String license;
  final List<dynamic> programs;

  const CompanyDetailsPage({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.license,
    required this.programs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: $name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Email: $email",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "Phone: $phone",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              SizedBox(height: 8),
              Text(
                "Address: $address",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "License: $license",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                "Programs:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...programs.map((program) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Program Name: ${program["program_name"]}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Description: ${program["description"]}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      Text(
                        "Price: ${program["price"]}",
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
                      Text(
                        "Duration: ${program["duration"]}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "Start Date: ${program["start_date"]}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "End Date: ${program["end_date"]}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Divider(color: Colors.grey),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}