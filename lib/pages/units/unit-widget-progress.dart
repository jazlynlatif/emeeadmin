import 'package:emee_admin/data.dart';
import 'package:emee_admin/pages/inbox_api.dart';
import 'package:emee_admin/pages/units_api.dart';
import 'package:flutter/material.dart';

class ReportProgress extends StatelessWidget {
  final int reportid;
  final int unitid;
  final VoidCallback callback;
  const ReportProgress({
    super.key,
    required this.reportid,
    required this.unitid,
    required this.callback
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List <Icon> theicons = [
      Icon(Icons.query_builder_sharp), 
      Icon(Icons.document_scanner_outlined), 
      Icon(Icons.fire_truck_outlined),
      Icon(Icons.run_circle_outlined),
      Icon(Icons.handyman_outlined),
      Icon(Icons.check)
    ];

    return StreamBuilder(
      stream: getUnitProgress(reportid),
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
        final progress = userData[0]['progress'];

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.black12
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress < 6 ? 
                    'up next : ${UnitProgress.progressIndicator[progress]}'
                    :'all done!',
                    style : TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 10
                    )
                  ), 
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      theicons[progress-1],
                      SizedBox(
                        width: 10
                      ),
                      Text(
                        UnitProgress.progressIndicator[progress-1],
                        style: theme.textTheme.titleMedium
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await updateProgressStatus(progress+1, reportid);
                      
                    if(progress == 5) {
                      final now = DateTime.now().toString();

                      await postEndtime(reportid, now);

                      await updateUnitStatus(unitid, 'active');
                      
                      callback();
                    }
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error : $err'))
                    );
                  }
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 32), // 👈 height here
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  'next',
                  // style: TextStyle(
                  //   fontSize: 15
                  // ),
                )
              )
            ],
          ),
        );
      }
    );
  }
}