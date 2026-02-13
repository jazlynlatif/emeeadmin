import 'dart:convert';
import 'package:emee_admin/pages/auth-pages/auth_api.dart';
import 'package:emee_admin/pages/dispatch/dispatch-home.dart';
import 'package:emee_admin/pages/units/units-home.dart';
import 'package:emee_admin/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _selectedAccIndex = 0;
  List<Widget> accountChoice = <Widget> [
    SizedBox(width:130,child: Align(alignment: Alignment.center, child: Text('Dispatch', style: TextStyle(fontWeight: FontWeight.bold),)),),
    SizedBox(width:130,child: Align(alignment: Alignment.center, child: Text('Unit', style: TextStyle(fontWeight: FontWeight.bold),)),)
  ];

  @override 
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor : Colors.white,
      appBar: AppBar(
        title: Text(
          'login'
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  'emee admin',
                  style: theme.textTheme.titleLarge,
                ),
                SizedBox(
                  height: 30,
                ),
                ToggleButtons(
                  selectedColor: Colors.black,
                  fillColor: theme.colorScheme.primary,
                  isSelected: List.generate(accountChoice.length, (i) => i == _selectedAccIndex),
                  onPressed: (index) {
                    setState(() {
                      _selectedAccIndex = index;
                    });
                  },
                  children: accountChoice, 
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    decoration: InputDecoration(
                      label : Text(
                        'ID'
                      ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                    ),
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text(
                        'Password'
                      ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    )
                    ),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // for a success
                      final String role = _selectedAccIndex == 0 ? 'dispatch' : 'unit';
        
                      final loginRes = await loginAcc(_emailController.text, _passwordController.text, role);
        
                      if(loginRes.statusCode == 200) {
                        final data = jsonDecode(loginRes.body);
        
                        await _authService.saveTokens(data['accessToken'], data['refreshToken']);
        
                        print(data);
                        
                        late final int unit_id;
                        if(_selectedAccIndex == 1) {
                          unit_id = data['unitsid'];
                        }
                        final int service_id = data['serviceid'];
        
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(
                            builder: (context) =>  _selectedAccIndex == 0 
                            ? DispatchHomePage(service: service_id,)
                            : UnitsHomePage(unitid: unit_id, serviceid: service_id,)
                          )
                        );
                      }
                      else {
                        print(loginRes.body);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(loginRes.body))
                        );
                      }
                      
                      
                    }
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10)
                  ),
                  child: Text(
                    'login',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                ),
                SizedBox(
                  height: 10
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}