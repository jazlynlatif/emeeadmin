import 'package:flutter/material.dart';

class MedicalNotes extends StatelessWidget {
  final List<dynamic>? mednoteData;
  const MedicalNotes({
    super.key,
    required this.mednoteData
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notes_sharp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Catatan Medis',
                style: theme.textTheme.titleSmall,
              ),
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
            height: 10,
          ),
          SizedBox(
            height: 115,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mednoteData!.length,
              itemBuilder: (context, index) {
                final mednote = mednoteData![index];
                return Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                        mednote['mednoteTitle'],
                        style: theme.textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          mednote['mednoteNotes'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 10
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            )
          ),
        ],
      ),
    );
  }
}