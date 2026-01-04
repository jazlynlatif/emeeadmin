import 'package:emee_admin/pages/units_api.dart';
import 'package:flutter/material.dart';

class ChooseUnit extends StatefulWidget {
  final int serviceid;
  final int reportid;
  const ChooseUnit({
    super.key,
    required this.serviceid,
    required this.reportid
  });

  @override
  State<ChooseUnit> createState() => _ChooseUnitState();
}

class _ChooseUnitState extends State<ChooseUnit> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'pilih unit'
        )
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column (
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Unit aktif',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: FutureBuilder(
                  future: getDispatchActiveUnits(widget.serviceid), 
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
              
                    if(snapshot.hasError) {
                      print('it is error');
                      return Center(child: Text("Error : ${snapshot.error}"),);
                    }
              
                    if(!snapshot.hasData || snapshot.data == null || snapshot.data.length == 0) {
                      print('this is null');
                      return const Center(child: Text('No available unit'),);
                    }
          
                    print(snapshot.data);
              
                    final userData = snapshot.data!;
          
                    return ListView.builder(
                      itemCount: userData.length,
                      itemBuilder: (context, index) {
                        final data = userData[index];
                        print(data);
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 1.5
                                  )
                                ),
                                child: CircleAvatar(
                                  radius: 23,
                                  backgroundColor: theme.colorScheme.primary,
                                  child: Icon(
                                    Icons.fire_truck,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['unitcode'],
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  Text(
                                    '${data['companyname']}',
                                    style: theme.textTheme.labelSmall,
                                  ),
                                  Text(
                                    '${data['licensenum']}',
                                    style: theme.textTheme.labelSmall,
                                  )
                                ],
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () async {
                                  try {
                                    await updateProgressStatus(2, widget.reportid);

                                    await updateUnitStatus(data['unitid'], 'occupied');

                                    await chooseUnit(data['unitid'], widget.reportid);

                                    Navigator.pop(context);
                                    
                                  } catch (err) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Error : $err'))
                                    );
                                  }
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
                              )
                            ],
                          ),
                        );
                      },
                    );
                  }
                )
              )
            ]
          ),
        )
      )
    );
  }
}