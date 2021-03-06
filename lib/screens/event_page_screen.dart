import 'package:flutter/material.dart';
import 'package:rcn/util.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: primaryColorDark,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'Remnant Christian Network',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 18.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0, right: 80),
                      child: Divider(
                        height: 5.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Striving for the rebirth of apostolic christianity...',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Stack(
                children: [
                  Image.asset(
                    'assets/images/apostle.jpeg',
                    width: double.infinity,
                    height: 300.0,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 60.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(100.0),
                        ),
                      ),
                      height: 200.0,
                      width: 200,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                              top: 45.0,
                            ),
                            child: Text(
                              'Share',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                                color: textColorBlack,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                            ),
                            child: Text(
                              'Christ',
                              style: TextStyle(
                                fontSize: 48.0,
                                fontWeight: FontWeight.w900,
                                color: textColorRed,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5.0,
                            ),
                            child: Text(
                              'Love',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                                color: textColorBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Your act of Love will help share the life-changing message of Jesus and meet the needs of so many around the world.',
                        style: TextStyle(
                          color: primaryTextColor,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: primaryColorLight,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: bgColorWhite,
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'GIVE YOUR OFFERING',
                        style: TextStyle(
                          color: textColorBlack,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 1.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: primaryColorLight,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: bgColorWhite,
                  elevation: 5,
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'PAY YOUR TITHE',
                        style: TextStyle(
                          color: textColorBlack,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
