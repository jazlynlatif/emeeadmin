import 'package:emee_admin/pages/inbox_api.dart';
import 'package:flutter/material.dart';

class AssesmentWidget extends StatefulWidget {
  final int reportid;
  const AssesmentWidget({
    super.key,
    required this.reportid
  });

  @override
  State<AssesmentWidget> createState() => _AssesmentWidgetState();
}

class _AssesmentWidgetState extends State<AssesmentWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(15),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25), 
            spreadRadius: 0.5, 
            blurRadius: 2, 
            offset: Offset.zero, 
          )
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Assesment',
                style: theme.textTheme.titleSmall,
              ),
              Spacer()
            ],
          ),
          SizedBox(
            height: 5,
          ),
          // Divider(
          //   color: theme.colorScheme.primary,
          //   thickness: 2,
          // ),
          SizedBox(
            height: 120,
            child: FutureBuilder(
              future: getAssesmentResult(widget.reportid), 
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
                print('this is the asses result');
                print(userData);

                return userData.isEmpty
                ? Center(child: Text('pending...', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold,fontSize: 15)),)
                : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final data = userData[index];
                    return Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary, 
                            spreadRadius: 0.25, 
                            blurRadius: 2, 
                            offset: Offset.zero, 
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['question'],
                            style: theme.textTheme.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 180,
                            child: data['answer'] == null
                            ? Text('Tidak dijawab')
                            : Text(
                              data['answer'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                );
              }
            )
          )
        ],
      ),
    );
  }
}