import 'package:emee_admin/pages/active-report/report-widgets/assesment-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/chatroom-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/emergencycontact-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/locationmap-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/medicalnotes-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/reportdetails-widget.dart';
import 'package:emee_admin/pages/dispatch/reports/choose-unit.dart';
import 'package:emee_admin/pages/inbox_api.dart';
import 'package:flutter/material.dart';

class Report extends StatefulWidget {
  final Map data;
  final String title;
  final int reportid;
  final int serviceid;
  const Report({
    super.key,
    required this.data,
    required this.title,
    required this.reportid,
    required this.serviceid
  });

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  int getAge(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final int age = now.year - date.year;
    return age;
  }

  void endSessionButton() {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)
          ),
          title: const Text(
            'End report',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            ),
          ),
          content: const Text(
            'are you sure?',
            style: TextStyle(
              fontStyle: FontStyle.italic
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                showDialog(
                  context: context, 
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      ),
                      content: const SizedBox(
                        height: 150,
                        child: Center(
                          child : Text(
                            'Laporan selesai',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                );

                await Future.delayed(const Duration(seconds: 2));
                if (context.mounted) Navigator.pop(context);

                final now = DateTime.now().toString();

                await postEndtime(widget.reportid, now);

                Navigator.pop(context);
              }, 
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              )
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              }, 
              child: const Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 150, 255, 1)
                ),
              )
            ),
          ],
        );
      }
    );
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
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChooseUnit(serviceid: widget.serviceid,reportid: widget.reportid,)
                )
              );
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white
            ),
            child: Text(
              'tugaskan',
              style: TextStyle(
                fontWeight: FontWeight.bold
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
                      color: Colors.white,
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
                          height: 10,
                        ),
                        ChatroomBarWidget(reportid: widget.reportid, initialData: initialData, status: 0),
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
                    height: 10,
                  ),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {
                        endSessionButton();
                      }, 
                      style : ElevatedButton.styleFrom(
                        backgroundColor : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                        )
                      ),
                      child: Text(
                        'selesaikan laporan',
                      style: TextStyle(
                          color : Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      )
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