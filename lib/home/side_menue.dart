import 'package:flutter/material.dart';

class SideMenue extends StatelessWidget {
  const SideMenue({
    super.key,
    required TextEditingController apiKeyController,
  }) : _apiKeyController = apiKeyController;

  final TextEditingController _apiKeyController;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(),
      child: ListView(
        children: [
          const DrawerHeader(
            child: SizedBox(
              height: 120,
              width: 150,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 100),
          Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            height: 50,
            child: TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'Enter API ',
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue[700])),
              child: const Text(
                'Process',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
