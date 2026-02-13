import 'package:emee_admin/pages/active-report/chatroom/message_bubble.dart';
import 'package:emee_admin/pages/inbox_api.dart';
import 'package:flutter/material.dart';

class ChatRoomHistory extends StatefulWidget {
  final String username;
  final int reportid;

  const ChatRoomHistory({
    super.key,
    required this.username,
    required this.reportid,
  });

  @override
  State<ChatRoomHistory> createState() => _ChatRoomHistoryState();
}

class _ChatRoomHistoryState extends State<ChatRoomHistory> {
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
          Expanded(
            child: FutureBuilder(
              future: getMessageHistory(widget.reportid), 
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
            
                if(snapshot.hasError) {
                  return Center(child: Text("Error : ${snapshot.error}"),);
                }
            
                if(!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("Tidak ada data"));
                }
            
                final userData = snapshot.data!;
            
                print('this is the message');
                print(userData);
            
                return userData.isEmpty ?
                    Center(child: Text('Tidak ada riwayat pesan')) 
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
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Anda tidak bisa mengirim pesan dalam mode riwayat',
              style: TextStyle(
                fontSize: 10
              ),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}