import 'package:emee_admin/pages/dispatch/units/add-units.dart';
import 'package:emee_admin/pages/units_api.dart';
import 'package:flutter/material.dart';

class UnitPage extends StatefulWidget {
  final int serviceid;
  const UnitPage({
    super.key,
    required this.serviceid
  });

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  List<String> filters = ['all', 'occupied', 'active', 'offline', 'in maintenance' ];
  String _selectedFilter = 'all';

  Map<String, Color> statusColor = {'occupied' : Colors.green, 'active' : Colors.blue, 'offline' : Colors.black, 'in maintenance' : Colors.grey};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Units'
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: 
                (context) => AddUnits(serviceid: widget.serviceid,))
              );
            }, 
            icon: Icon(Icons.add)
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final String filter = filters[index];
                  return Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      child: Chip(
                        label: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedFilter == filter ? const Color.fromRGBO(255, 255, 255, 1) : Colors.black
                          ),
                        ),
                        backgroundColor: _selectedFilter == filter ? theme.colorScheme.primary : const Color.fromRGBO(235, 235, 235, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        side: BorderSide(
                          width: 2,
                          color: _selectedFilter == filter ? theme.colorScheme.primary :const Color.fromRGBO(192, 192, 192, 1)
                        ),
                      )
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getDispatchUnits(widget.serviceid), 
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
            
                  if(snapshot.hasError) {
                    print(snapshot.error);
                    return Center(child: Text("Error : ${snapshot.error}"),);
                  }
            
                  if(!snapshot.hasData || snapshot.data == null) {
                    return const Spacer();
                  }
            
                  final userData = snapshot.data!;
                  print(userData);
                  print('hi');

                  final filteredData = _selectedFilter == 'all'
                  ? userData
                  : userData.where((item) =>
                      item['unitstatus']
                          ?.toString()
                          .toLowerCase()
                          .trim() ==
                      _selectedFilter
                    ).toList();
            
                  return ListView.builder(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final data = filteredData[index];
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
                                  color: statusColor[data['unitstatus']] ?? Colors.grey,
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
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              data['unitstatus']
                            ),
                            // IconButton(
                            //   onPressed: () {}, 
                            //   icon: Icon(
                            //     Icons.message,
                            //     color: theme.colorScheme.primary,
                            //   )
                            // ),
                          ],
                        ),
                      );
                    },
                  );
                }
              )
            )
          ],
        )
      ),
    );
  }
}