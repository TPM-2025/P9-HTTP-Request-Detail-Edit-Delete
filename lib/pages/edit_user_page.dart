import 'package:asisten_tpm_8/models/user_model.dart';
import 'package:asisten_tpm_8/pages/home_page.dart';
import 'package:asisten_tpm_8/services/user_service.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatefulWidget {
  final User user;
  const EditUserPage({super.key, required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late final TextEditingController _name = TextEditingController(
    text: widget.user.name,
  );
  late final TextEditingController _email = TextEditingController(
    text: widget.user.email,
  );
  late String? _gender = widget.user.gender;

  Future<void> _updateUser(BuildContext context) async {
    try {
      User updatedUser = User(
        id: widget.user.id,
        name: _name.text.trim(),
        email: _email.text.trim(),
        gender: _gender,
      );

      final Map<String, dynamic> response = await UserApi.updateUser(
        updatedUser,
      );
      final status = response["status"];

      if (status == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response["message"]),
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
        );
      } else {
        throw Exception(response["message"]);
      }
    } catch (e) {
      SnackBar snackBar = SnackBar(content: Text(e.toString()));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Update User"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text("Gender"),
            Row(
              spacing: 4,
              children: [
                Radio(
                  value: "Male",
                  groupValue: _gender,
                  onChanged: (event) {
                    setState(() {
                      _gender = event;
                    });
                  },
                ),
                Text("Male"),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              spacing: 4,
              children: [
                Radio(
                  value: "Female",
                  groupValue: _gender,
                  onChanged: (event) {
                    setState(() {
                      _gender = event;
                    });
                  },
                ),
                Text("Female"),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _updateUser(context);
              },
              child: const Text("Create User"),
            ),
          ],
        ),
      ),
    );
  }
}
