import 'package:emee_admin/data.dart';
import 'package:emee_admin/pages/active-report/report-widgets/assesment-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/chatroom-widget.dart';
import 'package:emee_admin/pages/active-report/report-widgets/locationmap-widget.dart';
import 'package:emee_admin/pages/inbox_api.dart';
import 'package:flutter/material.dart';

class ReportHistory extends StatefulWidget {
  final Map data;
  const ReportHistory({
    super.key,
    required this.data,
  });

  @override
  State<ReportHistory> createState() => _ReportHistoryState();
}

class _ReportHistoryState extends State<ReportHistory> {

  int getAge(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final now = DateTime.now();
    final int age = now.year - date.year;
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final DateTime timeStart = DateTime.parse(widget.data['created_at']).toLocal();
    final timestampStart = '${timeStart.day.toString().padLeft(2, '0')} ' '${Utilities.monthsFull[timeStart.month-1]} ' '${timeStart.year}, ' ' ${timeStart.hour.toString().padLeft(2, '0')}:${timeStart.minute.toString().padLeft(2, '0')}';

    final DateTime timeEnd = DateTime.parse(widget.data['ended_at']).toLocal();
    final timestampEnd = '${timeEnd.day.toString().padLeft(2, '0')} ' '${Utilities.monthsFull[timeEnd.month-1]} ' '${timeEnd.year}, ' ' ${timeEnd.hour.toString().padLeft(2, '0')}:${timeEnd.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data['deskripsi']),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getReportInformation(widget.data['report_id'], 0, widget.data['service_id']), 
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
                print(userData);

                
                final initialData = userData[0];
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
                          ChatroomBarWidget(reportid: widget.data['report_id'], initialData: initialData, status: 1,),
                          // ChatRoomHistory(username: initialData['username'],reportid: widget.data['report_id']),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                            ),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lokasi',
                                  style: theme.textTheme.titleSmall,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${widget.data['latitude']}, ${widget.data['longitude']}',
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Dilaporkan pada',
                                  style: theme.textTheme.titleSmall,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${timestampStart}',
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Selesai pada',
                                  style: theme.textTheme.titleSmall,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  timestampEnd,
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      // decoration: BoxDecoration(
                      //   boxShadow: [
                      //     BoxShadow(
                      //       color: Colors.grey.withOpacity(0.25), 
                      //       spreadRadius: 2, 
                      //       blurRadius: 2, 
                      //       offset: Offset.zero, 
                      //     )
                      //   ]
                      // ),
                      child: AssesmentWidget(reportid: widget.data['report_id'])
                    ),
                  ],
                );
            }
           ),
        )
      ),
    );
  }
}