import 'package:flutter/material.dart';

class Customtextinput extends StatelessWidget {
  final TextEditingController myController;
  final VoidCallback onSearch;

  const Customtextinput({
    Key? key,
    required this.myController,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 50.0,
        child: TextField(
          controller: myController,
          style: const TextStyle(color: Color.fromARGB(255, 32, 1, 43)),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Color.fromARGB(255, 61, 2, 82)),
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
                onSearch();
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
    );
  }
}
