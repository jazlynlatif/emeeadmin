import 'package:emee_admin/data.dart';
import 'package:emee_admin/pages/inbox_api.dart';
import 'package:emee_admin/pages/history/report-history.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  final int serviceid;
  final int adminid;
  final int unitid;
  const History({
    super.key,
    required this.serviceid,
    required this.adminid,
    this.unitid = 0
  });

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _startDate = TextEditingController();
  final TextEditingController _endDate = TextEditingController();
  Future<dynamic>? _historyFuture;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25), 
                    spreadRadius: 2, 
                    blurRadius: 2, 
                    offset: Offset.zero, 
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Pilih Tanggal',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'From',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: _startDate,
                      style: TextStyle(fontSize: 14.0),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        hintText: 'choose a starting date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the start date';
                        }
                      },
                      onTap: () async{
                        FocusScope.of(context).requestFocus(new FocusNode());
                        DateTime currDate = DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                          context: context, 
                          initialDate: currDate,
                          firstDate: DateTime(currDate.year-1), 
                          lastDate: currDate
                        );
                        if(pickedDate != null) {
                          setState(() {
                            _startDate.text = '${pickedDate.toLocal()}'.split(' ')[0];
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'To',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: _endDate,
                      style: TextStyle(fontSize: 14.0),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                        hintText: 'choose an ending date',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey, width: 1.5),
                        )
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the end date';
                        }
                      },
                      onTap: () async{
                        FocusScope.of(context).requestFocus(new FocusNode());
                        DateTime currDate = DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                          context: context, 
                          initialDate: currDate,
                          firstDate: DateTime(currDate.year-1), 
                          lastDate: currDate
                        );
                        if(pickedDate != null) {
                          setState(() {
                            _endDate.text = '${pickedDate.toLocal()}'.split(' ')[0];
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if(DateTime.parse(_startDate.text).isBefore(DateTime.parse(_endDate.text)) || DateTime.parse(_startDate.text).compareTo(DateTime.parse(_endDate.text)) == 0) {
                            print(_startDate.text);
                            print(_endDate.text);
                            setState(() {
                              print(widget.unitid);
                              _historyFuture = widget.adminid == 0 
                              ? getReportHistory(widget.serviceid,_startDate.text, _endDate.text)
                              : getUnitReportHistory(widget.serviceid,widget.unitid, _startDate.text, _endDate.text);
                            });
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Start Time must be before End Time'))
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(30),
                        backgroundColor: theme.colorScheme.primary
                      ), 
                      child: Text(
                        'cari laporan',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _historyFuture, 
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if(snapshot.hasError) {
                    return Center(child: Text("Error : ${snapshot.error}"),);
                  }

                  if(!snapshot.hasData || snapshot.data == null) {
                    return const Text('');
                  }

                  final userData = snapshot.data!;

                  return userData.isEmpty
                  ? Center(child: Text('Tidak ada laporan :)'),)
                  : ListView.builder(
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      final data = userData[index];
                      final DateTime time = DateTime.parse(data['created_at']).toLocal();
                      final date = '${time.day.toString().padLeft(2, '0')} ' '${Utilities.months[time.month-1]}';
                      final timestamp = '${time.day.toString().padLeft(2, '0')} ' '${Utilities.months[time.month-1]},' ' ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => ReportHistory(data: data))
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.25), 
                                spreadRadius: 2, 
                                blurRadius: 2, 
                                offset: Offset.zero, 
                              )
                            ]
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                timestamp,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                  fontSize: 12
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                data['deskripsi'],
                                style: theme.textTheme.titleSmall,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Lokasi   : ${data['latitude']}, ${data['longitude']}',
                                style: TextStyle(
                                  fontSize: 13
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Pelapor  : ${data['first_name']}',
                                style: TextStyle(
                                  fontSize: 13
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
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