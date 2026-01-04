import 'package:emee_admin/pages/auth-pages/auth_api.dart';
import 'package:emee_admin/pages/auth-pages/login.dart';
import 'package:emee_admin/pages/history/history.dart';
import 'package:emee_admin/pages/dispatch/reports/navpage.dart';
import 'package:emee_admin/pages/dispatch/units/units.dart';
import 'package:flutter/material.dart';

class DispatchHomePage extends StatefulWidget {
  final int service;
  const DispatchHomePage({
    super.key,
    required this.service
  });

  @override
  State<DispatchHomePage> createState() => _DispatchHomePageState();
}

class _DispatchHomePageState extends State<DispatchHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final serviceName = widget.service == 1 ? 'Medis' : 'Damkar';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'emee admin - '
            ),
            Text(
              '${serviceName.toLowerCase()}',
              style: TextStyle(
                color: widget.service == 1 ? Colors.blue : Colors.red
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) =>  NavPage(serviceid: widget.service,))
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_copy
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Reports',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => UnitPage(serviceid:  widget.service))
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.fire_truck
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Units',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => History(serviceid: widget.service ,adminid: 0,))
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Riwayat',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () async{
                  await logout();

                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (Route<dynamic> route) => false
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        'Sign Out',
                        style: theme.textTheme.titleMedium,
                      ),
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