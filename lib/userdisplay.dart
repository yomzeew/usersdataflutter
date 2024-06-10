import 'dart:convert';
import 'package:biodata_app/custominput.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biodata_app/endpoint.dart';

class UserDisplayData extends StatefulWidget {
  const UserDisplayData({Key? key}) : super(key: key);

  @override
  State<UserDisplayData> createState() => _UserDisplayDataState();
}

class _UserDisplayDataState extends State<UserDisplayData> {
  final TextEditingController myController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _userData;
  List<dynamic> useget = [];
  String errormsg = '';

  bool isVisible = false;

  final ButtonStyle styleprop = TextButton.styleFrom(
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    minimumSize: Size(30, 30),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
  }

  void handleget() {
    final inputtext = myController.text;
    _userData.then((data) {
      List<dynamic> datauser = data.where((item) {
        return item["login"]["username"].contains(inputtext) ||
            item["email"].contains(inputtext);
      }).toList();
      print(datauser);
      setState(() {
        useget = datauser;
        isVisible = true;
        if (datauser.isEmpty) {
          errormsg = 'Record Not Found';
        } else {
          errormsg = '';
        }
      });
    });
  }

  Future<List<Map<String, dynamic>>> _fetchUserData() async {
    final response = await http.get(Uri.parse(apiurl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void handlnavigatorback() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double heightScreen = screenHeight * 0.15;

    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data!;
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 246, 221, 255),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: heightScreen,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 61, 2, 82),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  handlnavigatorback();
                                },
                                style: styleprop,
                                child: Icon(
                                  Icons.arrow_circle_left_rounded,
                                  size: 30.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ), // Add some space between icon and text
                              Text(
                                'Userlist',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 32,
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            'images/logobiodatawhite.png',
                            fit: BoxFit.contain,
                            height: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Customtextinput(
                      myController: myController, onSearch: handleget),
                  useget.isEmpty && errormsg != '' && myController.text != ''
                      ? Text(
                          errormsg,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  isVisible && useget.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: useget.length,
                            itemBuilder: (context, index) {
                              final user = useget[index];
                              String age = user['dob']['age'].toString();
                              return Material(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['picture']['medium']),
                                  ),
                                  title: Text(
                                      '${user['name']['first']} ${user['name']['last']}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(user['email']),
                                      Text(user['dob']['date']),
                                      Text(age),
                                      // Add more widgets here if needed
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: userData.length,
                            itemBuilder: (context, index) {
                              final user = userData[index];
                              String age = user['dob']['age'].toString();
                              return Material(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['picture']['medium']),
                                  ),
                                  title: Text(
                                      '${user['name']['first']} ${user['name']['last']}'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(user['email']),
                                      Text(user['dob']['date']),
                                      Text(age),
                                      // Add more widgets here if needed
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
