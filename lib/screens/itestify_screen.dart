import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rcn/controller/itestify_controller.dart';
import 'package:rcn/util.dart';
import 'package:rcn/widget/itestify_widget.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';

class ItestifyScreen extends StatefulWidget {
  const ItestifyScreen({Key? key}) : super(key: key);

  @override
  _ItestifyScreenState createState() => _ItestifyScreenState();
}

class _ItestifyScreenState extends State<ItestifyScreen> {
  final itestListController = ItestifyController().getXID;
  late ScrollController _controller;
  var user_id = 2;
  var current_page = 1;
  bool isLoading = false;
  bool isFab = false;
  bool isSubmitting = false;
  late String msg;

  @override
  void initState() {
    super.initState();
    itestListController.getDetails(current_page, user_id);
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
        current_page++;
      });

      //

      itestListController.getMoreDetail(current_page, user_id);

      Future.delayed(new Duration(seconds: 4), () {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'iTestify',
              style: TextStyle(),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDialFabWidget(
        secondaryIconsList: [
          Icons.add,
        ],
        secondaryIconsText: [
          "Share Testimony",
        ],
        secondaryIconsOnPress: [
          () => {callBottomSheet()},
        ],
        secondaryBackgroundColor: Colors.grey[900],
        secondaryForegroundColor: Colors.grey[100],
        primaryBackgroundColor: Colors.deepOrange,
        primaryForegroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: itestListController.itestList.length,
            itemBuilder: (BuildContext context, int index) {
              if (itestListController.itestList[index].id == null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'No Data currently available',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );
              }
              if (index > 0 &&
                  index == itestListController.itestList.length - 1 &&
                  itestListController.isMoreDataAvailable.value == true) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (itestListController.itestList[index].id == null) {
                itestListController.isMoreDataAvailable.value = false;
                return Container();
              }
              return ItestifyWidget(
                test_img: itestListController.itestList[index].userImage,
                test_full_name: itestListController.itestList[index].fullName,
                test_user_name: itestListController.itestList[index].userName,
                test_counter: itestListController.itestList[index].counter,
                test_body: itestListController.itestList[index].body,
                isTestLike: itestListController.itestList[index].isTeskLike,
                test_id: itestListController.itestList[index].id,
                user_id: user_id.toString(),
              );
            },
          ),
        ),
      ),
    );
  }

  callBottomSheet() {
    setState(() {
      isFab = true;
    });
    Get.bottomSheet(
      Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: TextField(
                maxLines: 8,
                onChanged: (value) async {
                  setState(() {
                    msg = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter your text here ...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red, //this has no effect
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                isSubmitting = true;
              });
              await itestListController.add_testimony(user_id, msg);
              Future.delayed(new Duration(seconds: 4), () {
                setState(() {
                  isSubmitting = false;
                });
              });
            },
            child: (isSubmitting)
                ? CircularProgressIndicator()
                : Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: primaryColorLight,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    color: Colors.red,
                    elevation: 3,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      // margin: const EdgeInsets.only(bottom: 24.0),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          'Share Testimony',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
          ),
          SizedBox(
            height: 85,
          ),
        ],
      ),
      // backgroundColor: Colors.white,
      isDismissible: true,
    );
  }

  showSnackBar(String title, String msg, Color backgroundColor) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
