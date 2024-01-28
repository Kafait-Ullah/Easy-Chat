import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final String systemRole;
  final Function(String) onRoleChanged;

  const MyDrawer({
    Key? key,
    required this.systemRole,
    required this.onRoleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero),
      ),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 6, 16, 33),
              Color.fromARGB(255, 15, 84, 77)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              padding: EdgeInsets.zero, // Set padding to zero
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.contain,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(8),
              child: Container(
                margin: const EdgeInsets.all(8),
                child: TextField(
                  onChanged: onRoleChanged,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.bubble_chart,
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    hintText: 'Enter Assistant Role...',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage("assets/images/profile.jpeg"),
              ),
              title: const Text(
                "User Name",
                style: TextStyle(color: Colors.white),
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    // Handle logout
                  }
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white, // Set the color to white
                ),
                itemBuilder: (BuildContext context) {
                  return ['Logout'].map((String choice) {
                    return PopupMenuItem<String>(
                      value: 'logout',
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
