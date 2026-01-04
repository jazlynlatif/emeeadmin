import 'package:emee_admin/pages/active-report/chatroom/message_bubble.dart';
import 'package:emee_admin/pages/active-report/chatroom/text_message.dart';
import 'package:emee_admin/pages/dispatch/dispatch-home.dart';
import 'package:emee_admin/pages/inbox_api.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String username;
  final int reportid;

  const ChatRoom({
    super.key,
    required this.username,
    required this.reportid,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.username
        ),
        backgroundColor: Colors.grey[200],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(),
            child: StreamBuilder(
              stream: getMessage(widget.reportid), 
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

                return userData.isEmpty ?
                    Center(child: Text('mulai percakapan sekarang!')) 
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      final data = userData[index];
                      final align = data['sender'] == 1 ? Alignment.centerRight : Alignment.centerLeft;
                      return Align(
                        alignment: align,
                        child: MessageBubble(
                          message: data['text_content'], 
                          align: align, 
                          timeString: data['created_at']
                        ),
                      );
                    }
                  );
              }
            )
          ),
          Spacer(),
          TextMessage(report :  widget.reportid),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}