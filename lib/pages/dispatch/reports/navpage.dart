import 'package:emee_admin/pages/dispatch/reports/assigned-reports-list.dart';
import 'package:emee_admin/pages/dispatch/reports/unassigned-reports-list.dart';
import 'package:flutter/material.dart';

class NavPage extends StatefulWidget {
  final int serviceid;
  const NavPage({
    super.key,
    required this.serviceid
  });

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int currPageIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages = [
      UnassignedReports(serviceid: widget.serviceid,),
      AssignedReportsList(serviceid: widget.serviceid,)
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: IndexedStack(
        index: currPageIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        onDestinationSelected: (index) {
          setState(() {
            currPageIndex = index;
          });
        },
        indicatorShape: CircleBorder(
          side : BorderSide(
            width: 30,
            color: theme.colorScheme.primary
          ),
        ),
        selectedIndex: currPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ), 
            selectedIcon: Icon(Icons.home),
            label: 'Belum Ditugaskan',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history), 
            label: 'Sudah Ditugaskan'
          ),
        ]
      ),
    );
  }
}