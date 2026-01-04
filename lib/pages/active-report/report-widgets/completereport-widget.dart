import 'package:emee_admin/pages/dispatch/dispatch-home.dart';
import 'package:emee_admin/pages/inbox_api.dart';
import 'package:emee_admin/pages/units_api.dart';
import 'package:flutter/material.dart';

class CompleteReport extends StatelessWidget {
  final int reportid;
  final int unitid;
  const CompleteReport({
    super.key,
    required this.reportid,
    required this.unitid
  });

  @override
  Widget build(BuildContext context) {
    void endSessionButton() {
      showDialog(
        context: context, 
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            title: const Text(
              'End report',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
            content: const Text(
              'are you sure?',
              style: TextStyle(
                fontStyle: FontStyle.italic
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    final now = DateTime.now().toString();

                    await postEndtime(reportid, now);

                    await updateUnitStatus(unitid, 'active');

                    showDialog(
                      context: context, 
                      barrierDismissible: false,
                      builder: (dialogContext) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          ),
                          content: const SizedBox(
                            height: 150,
                            child: Center(
                              child : Text(
                                'Laporan selesai',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    );

                    await Future.delayed(const Duration(seconds: 2));
                    if (context.mounted) Navigator.pop(context);

                    Navigator.pop(context);

                    // Navigator.pushAndRemoveUntil(
                    //   context, 
                    //   MaterialPageRoute(
                    //     builder: (context) => const DispatchHomePage(service: 1,),
                    //   ),
                    //   (Route<dynamic> route) => false
                    // );
                  } catch(err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error : $err'))
                    );
                  }

                  
                }, 
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                )
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                }, 
                child: const Text(
                  'No',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(0, 150, 255, 1)
                  ),
                )
              ),
            ],
          );
        }
      );
    }
    return SizedBox(
      child: ElevatedButton(
        onPressed: () {
          endSessionButton();
        }, 
        style : ElevatedButton.styleFrom(
          backgroundColor : Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          )
        ),
        child: Text(
          'selesaikan laporan',
        style: TextStyle(
            color : Colors.white,
            fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}