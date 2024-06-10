import 'package:flutter/material.dart';

class HandlerResultContainer extends StatelessWidget {
  final List<dynamic> useget;
  final bool isVisible;

  const HandlerResultContainer({
    Key? key,
    required this.useget,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVisible && useget.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemCount: useget.length,
              itemBuilder: (context, index) {
                final user = useget[index];
                String age = user['dob']['age'].toString();
                return Material(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['picture']['medium']),
                    ),
                    title: Text(
                        '${user['name']['first']} ${user['name']['last']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
        : Container();
  }
}
