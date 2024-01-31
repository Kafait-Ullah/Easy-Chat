import 'package:easy_chat/auth/signin_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final String systemRole;
  final Function(String) onRoleChanged;

  const MyDrawer({
    Key? key,
    required this.systemRole,
    required this.onRoleChanged,
  }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final TextEditingController _roleController = TextEditingController();
  void _showInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information'),
          content: const Text(
            "The ability to customize your assistant role serves the purpose of tailoring the AI's responses to align with your specific needs and preferences. By defining the role, you guide the assistant to focus on a particular domain or expertise, ensuring more relevant and accurate information. This customization enhances the assistant's ability to provide assistance that is contextually appropriate and aligned with your desired outcomes, creating a more personalized and effective interaction.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

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
              Color.fromARGB(255, 15, 84, 77),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              padding: EdgeInsets.zero,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      _showInformationDialog(context);
                    },
                    child: const Text(
                      'How to use',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _roleController,
                onChanged: widget.onRoleChanged,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.bubble_chart,
                    color: Colors.white,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  hintText: 'Enter Assistant Role...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
            const Spacer(),
            ListTile(
              title: const Text(
                "Settings",
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onTap: () {},
              trailing: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    'Change Role',
                    'Logout',
                  ].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
                onSelected: (value) {
                  if (value == 'Change Role') {
                    _showChangeRoleDialog(context);
                  } else if (value == 'Logout') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SigninPage(),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  void _showChangeRoleDialog(BuildContext context) {
    _roleController.clear(); // Clear the text field
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Role'),
          content: const Text('Select a new role:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onRoleChanged("generic");
                Navigator.pop(context);
              },
              child: const Text('Change Role'),
            ),
          ],
        );
      },
    );
  }
}
