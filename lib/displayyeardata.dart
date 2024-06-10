import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biodata_app/endpoint.dart';
import 'dart:convert';

class Displayyeardata extends StatefulWidget {
  const Displayyeardata({super.key});

  @override
  State<Displayyeardata> createState() => _DisplayyeardataState();
}

class _DisplayyeardataState extends State<Displayyeardata> {
  late Future<List<Map<String, dynamic>>> userdata;
  List<dynamic> yeararrays = [];
  Future<List<Map<String, dynamic>>> _fetchUserData() async {
    final response = await http.get(Uri.parse(apiurl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  void initState() {
    super.initState();
    userdata = _fetchUserData();
    userdata.then((datadisplay) => yearArrayfunction(datadisplay));
  }

  void yearArrayfunction(List<Map<String, dynamic>> datadisplay) {
    List<int> years = datadisplay.map((item) {
      DateTime dobyear = DateTime.parse(item["dob"]["date"]);
      return dobyear.year;
    }).toList();
    years.sort();
    print(years);
    setState(() {
      yeararrays = years;
    });
  }

  void handleshowdialog(int year) {
    userdata.then((user) {
      List<dynamic> usersbyyear = user.where((item) {
        int getyear = DateTime.parse(item['dob']['date']).year;
        return getyear == year;
      }).toList();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Users born in $year'),
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

  // get all the years in array
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date of Birth By Year Data'),
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
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                childAspectRatio: 2, // Width to height ratio of the grid cells
              ),
              itemCount: yeararrays.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      handleshowdialog(yeararrays[index]);
                    },
                    child: Text(
                      '${yeararrays[index]}',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(
                          255, 255, 173, 250), // Set your desired color here
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
