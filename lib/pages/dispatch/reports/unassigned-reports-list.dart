import 'package:emee_admin/pages/inbox_api.dart';
import 'package:emee_admin/pages/dispatch/reports/unassigned-report.dart';
import 'package:flutter/material.dart';

class UnassignedReports extends StatefulWidget {
  final int serviceid;
  const UnassignedReports({
    super.key,
    required this.serviceid
  });

  @override
  State<UnassignedReports> createState() => _UnassignedReportsState();
}

class _UnassignedReportsState extends State<UnassignedReports> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Laporan Aktif'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Laporan Belum Ditugaskan',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: getUnassignedReports(widget.serviceid), 
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }  

                    if(!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text("Belum ada laporan :)"));
                    }
                              
                    if(snapshot.hasError) {
                      return Center(child: Text("Error : ${snapshot.error}"),);
                    }
                     
                              
                    final userData = snapshot.data!;

                    final reportData = userData['report_data'];
                    final assesmentData = userData['assesment_data'];

                    return userData.isEmpty
                    ? Center(child: Text('no reports yet :)'))
                    : ListView.builder(
                      itemCount: reportData.length,
                      itemBuilder: (context, index) {
                        final data = reportData[index];
                        final title = assesmentData[0]['deskripsi'];
                        final DateTime time = DateTime.parse(data['created_at']).toLocal();
                        final timestamp = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) =>  Report(data: data, title: title, reportid: data['report_id'], serviceid: widget.serviceid,))
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.grey.withOpacity(0.25), 
                              //     spreadRadius: 2, 
                              //     blurRadius: 2, 
                              //     offset: Offset.zero, 
                              //   )
                              // ]
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: theme.colorScheme.primary,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              title,
                                              style: theme.textTheme.titleSmall,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            timestamp,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[700],
                                              fontSize: 12
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Location : ${data['latitude']}, ${data['longitude']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Pelapor  : ${data['name']}',
                                        style: TextStyle(
                                          fontSize: 12
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    );
                  }
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}