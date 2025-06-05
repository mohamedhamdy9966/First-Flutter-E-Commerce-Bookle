import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String phone = '';
  String address = '';
  String email = '';
  String password = '';
  bool isLoading = false;

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse("https://ib.jamalmoallart.com/api/v2/register"),
      body: {
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "address": address,
        "email": email,
        "password": password,
      },
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token']; // Adjust based on response

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "First Name"),
                onChanged: (val) => firstName = val,
                validator: (val) =>
                    val!.isEmpty ? "Enter your first name" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Last Name"),
                onChanged: (val) => lastName = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Phone"),
                onChanged: (val) => phone = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Address"),
                onChanged: (val) => address = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (val) => email = val,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
                onChanged: (val) => password = val,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: register,
                      child: const Text("Register"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
