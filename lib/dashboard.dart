import 'dart:convert';

import 'package:biodata_app/displaybynationalty.dart';
import 'package:biodata_app/displayyeardata.dart';
import 'package:biodata_app/endpoint.dart';
import 'package:biodata_app/resultdisplay.dart';
import 'package:biodata_app/userdisplay.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> userdatalist = [];
  List<dynamic> useget = [];
  bool isVisible = false;
  final TextEditingController myController = TextEditingController();
  Future<void> handlegetalldata() async {
    try {
      final response = await http.get(Uri.parse(apiurl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userdatalist = data['results'];
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handlegetalldata();
  }

  void handleget() {
    final inputtext = myController.text;
    print(inputtext);
    print(userdatalist);
    List<dynamic> datauser = userdatalist.where((item) {
      return item["login"]["username"].contains(inputtext) ||
          item["email"].contains(inputtext);
    }).toList();
    setState(() {
      useget = datauser;
      isVisible = true;
    });
  }

  final styleprop = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    overlayColor: MaterialStateProperty.all(Colors.transparent),
    padding: MaterialStateProperty.all(EdgeInsets.zero),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
  void handlnavigatoruserlist() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const UserDisplayData()));
  }

  void handlnavigatoryearsort() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const Displayyeardata()));
  }

  void handlnavigatorcountry() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const Displaynation()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                'images/logobiodatawhite.png',
                fit: BoxFit.contain,
                height: 32,
              ),
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 61, 2, 82),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              margin: const EdgeInsets.only(top: 100.0),
              height: 50.0,
              child: TextField(
                controller: myController,
                style: const TextStyle(color: Color.fromARGB(255, 32, 1, 43)),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 61, 2, 82)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 61, 2, 82),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 61, 2, 82),
                      width: 1,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  suffixIcon: IconButton(
                    onPressed: () {
                      handleget();
                      // Add your send icon functionality here
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Color.fromARGB(255, 61, 2, 82),
                    ),
                  ),
                ),
              ),
            ),
          ),
          HandlerResultContainer(useget: useget, isVisible: isVisible),
          Container(
            width: double.infinity,
            height: 80.0,
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextButton(
                        onPressed: () => handlnavigatoruserlist(),
                        style: styleprop,
                        child: _buildIconColumn(
                          icon: Icons.list_rounded,
                          label: 'Userlist',
                          backgroundColor:
                              const Color.fromARGB(255, 241, 202, 255),
                          iconColor: const Color.fromARGB(255, 61, 2, 82),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          handlnavigatoryearsort();
                        },
                        style: styleprop,
                        child: _buildIconColumn(
                          icon: Icons.data_exploration_rounded,
                          label: 'Sort by DOB',
                          backgroundColor:
                              const Color.fromARGB(255, 241, 202, 255),
                          iconColor: const Color.fromARGB(255, 61, 2, 82),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          handlnavigatorcountry();
                        },
                        style: styleprop,
                        child: _buildIconColumn(
                          icon: Icons.settings_applications_rounded,
                          label: 'Settings',
                          backgroundColor:
                              const Color.fromARGB(255, 241, 202, 255),
                          iconColor: const Color.fromARGB(255, 61, 2, 82),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconColumn({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 40.0,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: iconColor),
        ),
      ],
    );
  }
}
