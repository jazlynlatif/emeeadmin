import 'package:emee_admin/pages/auth-pages/auth_api.dart';
import 'package:emee_admin/pages/auth-pages/login.dart';
import 'package:emee_admin/pages/units_api.dart';
import 'package:flutter/material.dart';

class UnitsInfo extends StatefulWidget {
  final Map<String, dynamic> data;
  const UnitsInfo({
    super.key,
    required this.data
  });

  @override
  State<UnitsInfo> createState() => _UnitsInfoState();
}

class _UnitsInfoState extends State<UnitsInfo> {
  // List<String> status = ['occupied', 'online', 'offline', 'in maintenance' ];
  bool _statusSwitch = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _statusSwitch = widget.data['status'] == 'offline' ? false : widget.data['status'] == 'in maintenance' ? false : true;
  }

  void updateStatus(String status) async{
    if(status != 'occupied' && status != 'in maintenance') {
      final String theStat = _statusSwitch == false ? 'active' : 'offline';
      await updateUnitStatus(widget.data['units_id'], theStat);
      _statusSwitch = _statusSwitch == false ? true : false;
      setState(() {});
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot change status while $status'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informasi Unit'
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 80,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25), 
                      spreadRadius: 2, 
                      blurRadius: 2, 
                      offset: Offset.zero, 
                    )
                  ]
                ),
                child: FutureBuilder(
                  future: getUnitStatus(widget.data['units_id']),
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

                    final userData = snapshot.data![0];
                    final String status = userData['status'];

                    return Row(
                      children: [
                        Text(
                          status.toString().toUpperCase(),
                        ),
                        Spacer(),
                        Switch(
                          value: _statusSwitch, 
                          onChanged: (bool newValue) {
                              updateStatus(status);
                          }
                        )
                      ],
                    );
                  }
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Informasi General',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25), 
                      spreadRadius: 2, 
                      blurRadius: 2, 
                      offset: Offset.zero, 
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Kode Unit',
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacer(),
                        Text(
                          widget.data['unit_code'],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Layanan',
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacer(),
                        Text(
                          widget.data['service_id'] == 1
                          ? 'Medis'
                          : 'Damkar'
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Nomor Plat',
                          style: theme.textTheme.titleSmall,
                        ),
                        Spacer(),
                        Text(
                          widget.data['plat_number']
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                'Aksi',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  await logout();

                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (Route<dynamic> route) => false
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.25), 
                        spreadRadius: 2, 
                        blurRadius: 2, 
                        offset: Offset.zero, 
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Sign out',
                        style: theme.textTheme.titleSmall,
                      ),
                      Spacer(),
                      Icon(
                        Icons.logout_outlined
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}