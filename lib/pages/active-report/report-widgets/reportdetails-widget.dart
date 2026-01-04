import 'package:emee_admin/data.dart';
import 'package:emee_admin/pages/active-report/report-widgets/locationmap-widget.dart';
import 'package:flutter/material.dart';

class ReportDetails extends StatelessWidget {
  final Map data;
  const ReportDetails({
    super.key,
    required this.data
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final DateTime timeStart = DateTime.parse(data['created_at']).toLocal();
    final timestampStart = '${timeStart.day.toString().padLeft(2, '0')} ' '${Utilities.monthsFull[timeStart.month-1]} ' '${timeStart.year}, ' ' ${timeStart.hour.toString().padLeft(2, '0')}:${timeStart.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        // color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.25), 
        //     spreadRadius: 2, 
        //     blurRadius: 2, 
        //     offset: Offset.zero, 
        //   )
        // ]
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
            '${data['latitude']}, ${data['longitude']}',
            style: TextStyle(
              fontSize: 14
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          // LocationMap(lat: data['latitude'], long: data['longitude'],),
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
        ],
      ),
    );
  }
}