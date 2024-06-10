import 'package:http/http.dart' as http;
import 'package:biodata_app/endpoint.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class Displaynation extends StatefulWidget {
  const Displaynation({super.key});

  @override
  State<Displaynation> createState() => _DisplaynationState();
}

class _DisplaynationState extends State<Displaynation> {
  late Future<List<Map<String, dynamic>>> userdata;
  List<dynamic> countries = [];
  String? selectedCountry;

  Future<List<Map<String, dynamic>>> _fetchUserData() async {
    final response = await http.get(Uri.parse(apiurl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void nationalArrayfunction(List<Map<String, dynamic>> datadisplay) {
    List<dynamic> nations = datadisplay.map((item) {
      return item["location"]["country"];
    }).toList();
    nations = nations.toSet().toList(); // Remove duplicates
    nations.sort(); // Sort the list
    setState(() {
      countries = nations;
    });
  }

  @override
  void initState() {
    super.initState();
    userdata = _fetchUserData();
    userdata.then((datadisplay) => nationalArrayfunction(datadisplay));
  }

  void handleshowdialog(dynamic country) {
    userdata.then((user) {
      List<dynamic> usersbyyear = user.where((item) {
        dynamic countryitem = item['location']['country'];
        return country == countryitem;
      }).toList();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Users born in $country'),
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: usersbyyear.length,
                      itemBuilder: (context, index) {
                        final user = usersbyyear[index];
                        String age = user['dob']['age'].toString();
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(user['picture']['medium']),
                          ),
                          title: Text(
                              '${user['name']['first']} ${user['name']['last']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(user['email']),
                              Text(user['dob']['date']),
                              Text(age),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users By Nationality'),
        backgroundColor: const Color.fromARGB(255, 61, 2, 82),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: userdata,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return Center(
              child: DropdownButton<String>(
                hint: Text(
                  'Select a country',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                value: selectedCountry,
                items: countries.map((dynamic country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(
                      country,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCountry = newValue;
                  });
                  handleshowdialog(newValue);
                },
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black, fontSize: 18),
                iconEnabledColor: Colors.purple, // Icon color
                iconSize: 30, // Icon size
                underline: Container(
                  height: 2,
                  color: Colors.purple, // Underline color
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
