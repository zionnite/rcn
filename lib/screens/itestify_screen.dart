import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:rcn/controller/itestify_controller.dart';
import 'package:rcn/screens/edit_profile_screen.dart';
import 'package:rcn/util.dart';
import 'package:rcn/widget/itestify_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';

class ItestifyScreen extends StatefulWidget {
  const ItestifyScreen({Key? key}) : super(key: key);

  @override
  _ItestifyScreenState createState() => _ItestifyScreenState();
}

class _ItestifyScreenState extends State<ItestifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final itestListController = ItestifyController().getXID;
  late ScrollController _controller;
  String? user_id;
  var current_page = 1;
  bool isLoading = false;
  bool? isFab;
  bool isSubmitting = false;
  late String msg;
  bool widgetLoading = true;
  String? is_profile_updated;

  getIfTestifyLoaded() {
    var loading = itestListController.isDataProcessing.value;
    if (loading) {
      setState(() {
        widgetLoading = false;
      });
    }
  }

  _initUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isUserLogin = prefs.getBool('isUserLogin');
    var user_id1 = prefs.getString('user_id');
    var user_name1 = prefs.getString('user_name');
    var user_full_name = prefs.getString('full_name');
    var user_email = prefs.getString('email');
    var user_img1 = prefs.getString('user_img');
    var user_age = prefs.getString('age');
    var phone_no1 = prefs.getString('phone_no');
    var profile_updated = prefs.getString('profile_updated');

    setState(() {
      user_id = user_id1!;
      is_profile_updated = profile_updated;
    });

    itestListController.getDetails(current_page, user_id);

    _check_if_profile_updated();
  }

  _check_if_profile_updated() {
    if (is_profile_updated == "false") {
      setState(() {
        isFab = true;
      });
    } else {
      setState(() {
        isFab = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initUserDetail();
    _controller = ScrollController()..addListener(_scrollListener);

    Future.delayed(new Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          getIfTestifyLoaded();
        });
      }
    });
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
        child: (widgetLoading)
            ? Center(
                child: Loading(
                  indicator: BallPulseIndicator(),
                  size: 50.0,
                  color: Colors.redAccent,
                ),
              )
            : Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: itestListController.itestList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == itestListController.itestList.length - 1 &&
                        isLoading == true) {
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
                      test_full_name:
                          itestListController.itestList[index].fullName,
                      test_user_name:
                          itestListController.itestList[index].userName,
                      test_counter:
                          itestListController.itestList[index].counter,
                      test_body: itestListController.itestList[index].body,
                      isTestLike:
                          itestListController.itestList[index].isTeskLike,
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
    if (isFab == true) {
      Get.defaultDialog(
        title: 'Oops!!',
        content: Text(
            'You need to update your profile detail before you can use this section'),
        onConfirm: () {
          Get.to(() => EditProfileScreen());
        },
        onCancel: () {
          Get.back();
        },
        textConfirm: 'Ok,update',
        textCancel: 'Cancel',
        buttonColor: Colors.redAccent,
        confirmTextColor: Colors.white,
        contentPadding: EdgeInsets.all(20),
        // barrierDismissible: false,
      );
    } else {
      Get.bottomSheet(
        Wrap(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: TextFormField(
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      } else if (value.length <= 50) {
                        return 'Text too short (Test must be above 50 Length';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            GestureDetector(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isSubmitting = true;
                  });
                  await itestListController.add_testimony(user_id, msg);
                  Future.delayed(new Duration(seconds: 4), () {
                    setState(() {
                      isSubmitting = false;
                    });
                  });
                }
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
