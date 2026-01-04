import 'package:emee_admin/pages/dispatch/units/units.dart';
import 'package:emee_admin/pages/units_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddUnits extends StatefulWidget {
  final int serviceid;
  const AddUnits({
    super.key,
    required this.serviceid
  });

  @override
  State<AddUnits> createState() => _AddUnitsState();
}

class _AddUnitsState extends State<AddUnits> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedValue; 

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'add units'
        ),
      ),
      body: FutureBuilder(
        future: getCompany(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if(snapshot.hasError) {
            return Center(child: Text("Error : ${snapshot.error}"),);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return const Spacer();
          }

          final userData = snapshot.data!;

          //for list of company name
          List<String> _companyNames = userData.map<String>((e) => e["company_name"].toString()).toList();
          print(_companyNames);
          
          //for Map of company name and id
          Map<String, int> companyLookup = {
            for (var item in userData)
              item["company_name"]: item["company_id"]
          };

          return Form(
            key : _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Password',
                    style: theme.textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your password';
                      }
                    },
                    controller: _passwordController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Nomor Plat',
                    style: theme.textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText : 'Nomor Plat',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(9)
                    ],
                    controller: _licensePlateController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Masukkan nomor plat';
                      }
                      if (value.trim().length < 3) {
                        return 'Minimal 3 karakter';
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Instansi',
                    style: theme.textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      )
                    ),
                    value: _selectedValue,
                    hint: Text(
                      'pilih instansi',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15
                      ),
                    ),
                    items: _companyNames.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15
                          ),
                        ),
                      );
                    }).toList(), 
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pilih instansi';
                      }
                    },
                  ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 30),
                  //   child: TextFormField(
                  //     decoration: InputDecoration(
                  //       hint: const Text(
                  //         'Vehicle Type'
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(20)
                  //       )
                  //     ),
                  //     controller: _vehicleTypeController,
                  //     validator: (value) {
                  //       if (value == null || value.isEmpty) {
                  //         return 'Enter the vehicle';
                  //       }
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // for a success
                          try {
                            await registerUnit(widget.serviceid, _passwordController.text, _licensePlateController.text, companyLookup[_selectedValue] as int, 'ambulans') ;
                              
                            Navigator.pushAndRemoveUntil(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => UnitPage(serviceid: widget.serviceid,),
                              ),
                              (Route<dynamic> route) => route.isFirst
                            );
                              
                          } catch (err) {
                            print(err);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(err.toString()))
                            );
                          }
                        }
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      ),
                      child: Text(
                        'register unit',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                    ),
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
          );
        },
      )
    );
  }
}