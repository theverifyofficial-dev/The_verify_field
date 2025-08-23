import 'package:flutter/material.dart';

class User {
  final String name;
  final String email;
  final String city;

  User({required this.name, required this.email, required this.city});
}

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final List<User> _allUsers = [
    User(name: 'Alice', email: 'alice@example.com', city: 'New York'),
    User(name: 'Bob', email: 'bob@example.com', city: 'Los Angeles'),
    User(name: 'Charlie', email: 'charlie@example.com', city: 'Chicago'),
    User(name: 'David', email: 'david@example.com', city: 'Miami'),
  ];

  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _allUsers;
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        final lowerQuery = query.toLowerCase();
        return user.name.toLowerCase().contains(lowerQuery) ||
            user.email.toLowerCase().contains(lowerQuery) ||
            user.city.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multi-Field Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, email, or city',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('${user.email} • ${user.city}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
