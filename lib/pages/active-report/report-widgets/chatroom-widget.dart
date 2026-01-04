import 'package:emee_admin/pages/active-report/chatroom/chatroom.dart';
import 'package:emee_admin/pages/history/chatroom-history.dart';
import 'package:flutter/material.dart';

class ChatroomBarWidget extends StatelessWidget {
  final int reportid;
  final Map<dynamic, dynamic> initialData;
  final int status;
  const ChatroomBarWidget({
    super.key,
    required this.reportid,
    required this.initialData,
    required this.status
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => status == 0 
          ? ChatRoom(username: initialData['username'],reportid: reportid)
          : ChatRoomHistory(username: initialData['username'],reportid: reportid),)
        );
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: theme.colorScheme.primary
          )
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
          children: [
            Icon(
              Icons.chat_bubble,
              color: theme.colorScheme.primary,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Chatroom',
              style: theme.textTheme.titleSmall,
            ),
            Spacer(),
            // IconButton(
            //   onPressed: () async {
            //     // try {
            //     //    await openLocation(-7.0064, 110.4323);
            //     // } catch (err) {
            //     //   ScaffoldMessenger.of(context).showSnackBar(
            //     //     SnackBar(content: Text(err))
            //     //   );
            //     // }
            //   }, 
            //   icon: Icon(Icons.link)
            // )
          ],
        ),
      ),
    );
  }
}