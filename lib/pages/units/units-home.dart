import 'package:emee_admin/pages/history/history.dart';
import 'package:emee_admin/pages/units/unit-report.dart';
import 'package:emee_admin/pages/units/units-info.dart';
import 'package:emee_admin/pages/units_api.dart';
import 'package:flutter/material.dart';

class UnitsHomePage extends StatefulWidget {
  final int unitid;
  final int serviceid;
  const UnitsHomePage({
    super.key,
    required this.unitid,
    required this.serviceid
  });

  @override
  State<UnitsHomePage> createState() => _UnitsHomePageState();
}

class _UnitsHomePageState extends State<UnitsHomePage> {
  Map<String, Color> statusColor = {'occupied' : Colors.green, 'active' : Colors.blue, 'offline' : Colors.black, 'in maintenance' : Colors.grey};

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'emee admin'
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: StreamBuilder(
            stream: getUnit(widget.unitid), 
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

              final data = snapshot.data!;
              final userData = data['unit_data'][0];
              late final reportData;
              bool reportDataAvailable = false;
              if(data['report_data'].isNotEmpty) {
                reportData = data['report_data'][0];
                reportDataAvailable = true;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome, unit ${userData['unit_code']}',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Saat ini status Anda '
                      ),
                      Text(
                        userData['status'].toString().toUpperCase(),
                        style: TextStyle(
                          color: statusColor[userData['status']],
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      if(reportDataAvailable) {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => UnitReport(
                            data: reportData,
                            unitid: widget.unitid,
                          ))
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tidak ada laporan'))
                        );
                      }
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
                            'Laporan',
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
                        MaterialPageRoute(builder: (context) => History(serviceid: widget.serviceid, adminid: 1, unitid: widget.unitid,))
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
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => UnitsInfo(data: userData))
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
                            'Informasi Unit',
                            style: theme.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            
          ),
        )
      ),
    );
  }
}