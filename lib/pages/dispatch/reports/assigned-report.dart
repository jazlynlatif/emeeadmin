import 'package:emee_admin/pages/active-report/report-widgets/assesment-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/completereport-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/emergencycontact-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/locationmap-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/medicalnotes-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/reportdetails-widget.dart';
import 'package:emee_admin/pages/inbox_api.dart';
import 'package:flutter/material.dart';

class AssignedReportDispatch extends StatefulWidget {
  final Map data;
  final String title;
  final int reportid;
  final int serviceid;
  final int unitid;
  final String unitcode;
  const AssignedReportDispatch({
    super.key,
    required this.data,
    required this.title,
    required this.reportid,
    required this.serviceid,
    required this.unitid,
    required this.unitcode
  });

  @override
  State<AssignedReportDispatch> createState() => __AssignedReportDispatchState();
}

class __AssignedReportDispatchState extends State<AssignedReportDispatch> {
  
  int getAge(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final int age = now.year - date.year;
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              widget.unitcode,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            )
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getReportInformation(widget.reportid, 1, widget.serviceid), 
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
        
              if(snapshot.hasError) {
                return Center(child: Text("Error : ${snapshot.error}"),);
              }
        
              if(!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text("No data"));
              }
        
              final userData = snapshot.data!;

              late final initialData;
              if(userData.length > 1) {
                initialData = userData['initial'][0];
              } else {
                initialData = userData[0];
              }
              
        
              late final List? mednoteData;
              late final List? contactData;
              bool appear = false;
              if(initialData['victimId'] == 0 && widget.data['service_id'] == 1) {
                appear = true;
                mednoteData = userData['mednote'];
                contactData = userData['contact'];
              }
              
              return Column(
                children: [
                  LocationMap(lat: widget.data['latitude'], long: widget.data['longitude'],),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: theme.colorScheme.primary,
                              radius: 10,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  initialData['username'],
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ),
                                Text(
                                  '${initialData['gender']}, ${getAge(initialData['birthdate'])}'
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ReportDetails(data: widget.data),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        AssesmentWidget(reportid: widget.reportid),
                        appear 
                        ? MedicalNotes(mednoteData: mednoteData)
                        : SizedBox(height: 5,),
                        appear 
                        ? EmergencyContact(contactData: contactData)
                        : SizedBox(height: 5,),
                      ],
                    )
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CompleteReport(reportid: widget.reportid, unitid: widget.unitid,),
                ],
              );
            }
           ),
        )
      ),
    );
  }
}