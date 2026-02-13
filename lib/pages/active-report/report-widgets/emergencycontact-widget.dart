import 'package:flutter/material.dart';

class EmergencyContact extends StatelessWidget {
  final List<dynamic>? contactData;
  const EmergencyContact({
    super.key,
    required this.contactData
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
                Icons.call,
                color: theme.colorScheme.primary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Kontak Darurat',
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
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: contactData!.length,
              itemBuilder: (context, index) {
                final contact = contactData![index];
                return IntrinsicHeight(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
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
                          contact['contactName'],
                          style: theme.textTheme.titleSmall,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            contact['contactNum'],
                            style: TextStyle(
                              fontSize: 12
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }
}