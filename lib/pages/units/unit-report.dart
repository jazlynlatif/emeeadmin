import 'package:emee_admin/pages/active-report/report-widgets/assesment-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/emergencycontact-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/chatroom-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/locationmap-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/medicalnotes-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/reportdetails-widget.dart';
import 'package:emee_admin/pages/inbox_api.dart';
import 'package:emee_admin/pages/units/unit-widget-progress.dart';
import 'package:flutter/material.dart';

class UnitReport extends StatefulWidget {
  final Map data;
  final int unitid;
  const UnitReport({
    super.key,
    required this.data,
    required this.unitid
  });

  @override
  State<UnitReport> createState() => __UnitReportState();
}

class __UnitReportState extends State<UnitReport> {
  
  int getAge(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final int age = now.year - date.year;
    return age;
  }

  void thankYouNotif() {
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
  }

  void sessionDone() async {
    thankYouNotif();

    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) Navigator.pop(context);

    Navigator.pop(context);
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
                thankYouNotif();

                await Future.delayed(const Duration(seconds: 2));
                if (context.mounted) Navigator.pop(context);

                final now = DateTime.now().toString();

                await postEndtime(widget.data['report_id'], now);

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
          widget.data['deskripsi'],
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getReportInformation(widget.data['report_id'], 1, widget.data['service_id']), 
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
                }
          
                if(snapshot.hasError) {
                  print(snapshot.error);
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
                  print('i am tirggered');
                  appear = true;
                  mednoteData = userData['mednote'];
                  contactData = userData['contact'];
                }
          
                print('this is widget data');
                print(widget.data);  

                print(initialData);    
                return Column(
                  children: [
                    ReportProgress(reportid: widget.data['report_id'], unitid: widget.unitid, callback: sessionDone,),
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
                            height: 10,
                          ),
                          ChatroomBarWidget(reportid: widget.data['report_id'], initialData: initialData, status: 0,),
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
                          AssesmentWidget(reportid: widget.data['report_id']),
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
                    // SizedBox(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       endSessionButton();
                    //     }, 
                    //     style : ElevatedButton.styleFrom(
                    //       backgroundColor : Colors.red,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(25)
                    //       )
                    //     ),
                    //     child: Text(
                    //       'selesaikan laporan',
                    //     style: TextStyle(
                    //         color : Colors.white,
                    //         fontWeight: FontWeight.bold
                    //       ),
                    //     )
                    //   ),
                    // ),
                  ],
                );
            }
           ),
        )
      ),
    );
  }
}