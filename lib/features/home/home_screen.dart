import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/features/home/widgets/dayTasks.dart';
import 'package:todo/features/home/widgets/day_content_builder.dart';
import 'package:todo/features/home/widgets/noTasks.dart';
import 'package:todo/features/settings/settings_screen.dart';
import 'package:todo/shared/widgets/task_widget.dart';
import 'package:todo/shared/widgets/white_circles.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/dummy_tasks.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;
  bool? boo = false;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    _controller.index = 1;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          body: orientation == Orientation.portrait
              ? Column(
                  children: [
                    _buildHeader(),
                    _buildTasks(orientation)
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildLandScapeSide(),
                    ),
                    Expanded(child: _buildTasks(orientation)),
                  ],
                ),
        );
      },
    );
  }

  Stack _buildLandScapeSide() {
    return Stack(
                      children: [
                        Container(
                          color: mainColor,
                          width: 45 * heightMultiplier,
                        ),
                        WhiteCircles(),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: 5 * widthMultiplier,
                                left: 3 * heightMultiplier),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context, rootNavigator: true).pushNamed(SettingsScreen.routeName);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                    size: 7.5 * imageSizeMultiplier,
                                  ),
                                  Text(
                                    "Settings",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 2.5 * textMultiplier),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 6 * heightMultiplier,
                              left: 6 * heightMultiplier),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/default_profile_pic.jpg'),
                            radius: 11 * imageSizeMultiplier,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 19 * heightMultiplier,
                              left: 6 * heightMultiplier),
                          child: Text(
                            getGreeting(DateTime.now()),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 2.8 * textMultiplier),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 35 * heightMultiplier),
                          child: PreferredSize(
                            preferredSize:
                                Size(10 * widthMultiplier, double.infinity),
                            child: RotatedBox(
                              quarterTurns: 1,
                              child: TabBar(
                                unselectedLabelColor: Colors.white,
                                indicatorColor: Colors.black45,
                                tabs: [
                                  RotatedBox(
                                    quarterTurns: 3,
                                    child: Tab(
                                      child: Text(
                                        "Yesterday",
                                        /* style: TextStyle(
                                        color: _controller.index == 0
                                            ? Colors.black45
                                            : Colors.white), */
                                      ),
                                    ),
                                  ),
                                  RotatedBox(
                                    quarterTurns: 3,
                                    child: Tab(
                                      child: Text(
                                        "Today",
                                        /* style: TextStyle(
                                        color: _controller.index == 1
                                            ? Colors.black45
                                            : Colors.white), */
                                      ),
                                    ),
                                  ),
                                  RotatedBox(
                                    quarterTurns: 3,
                                    child: Tab(
                                      child: Text(
                                        "Tomorrow",
                                        /*   style: TextStyle(
                                        color: _controller.index == 2
                                            ? Colors.black45
                                            : Colors.white), */
                                      ),
                                    ),
                                  ),
                                ],
                                controller: _controller,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
  }

  Expanded _buildTasks(Orientation orientation) {
    return Expanded(
      child: Container(
        alignment:
            orientation == Orientation.landscape ? Alignment.centerRight : null,
        child: TabBarView(
          controller: _controller,
          children: [
            DayContentBuilder(tasks: old),
            DayContentBuilder(tasks: tasks),
            DayContentBuilder(tasks: tasks),
          ],
        ),
      ),
    );
  }

  Align _buildHeader() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: mainColor,
        height: 33 * heightMultiplier,
        //   width: double.infinity,
        child: Stack(
          children: [
            Align(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 6 * heightMultiplier, right: 3 * widthMultiplier),
                child: IconButton(
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).pushNamed(SettingsScreen.routeName);
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 7.5 * imageSizeMultiplier,
                  ),
                ),
              ),
              alignment: Alignment.topRight,
            ),
            WhiteCircles(),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 8 * heightMultiplier),
                child: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/default_profile_pic.jpg'),
                  radius: 11 * imageSizeMultiplier,
                ),
              ),
            ),
            Align(
              child: Padding(
                padding: EdgeInsets.only(top: 21 * heightMultiplier),
                child: Text(
                  getGreeting(DateTime.now()),
                  style: TextStyle(
                      color: Colors.white, fontSize: 2.8 * textMultiplier),
                ),
              ),
              alignment: Alignment.topCenter,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TabBar(
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.black45,
                tabs: [
                  Tab(
                    child: Text(
                      "Yesterday",
                      /* style: TextStyle(
                                color: _controller.index == 0
                                    ? Colors.black45
                                    : Colors.white), */
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Today",
                      /* style: TextStyle(
                                color: _controller.index == 1
                                    ? Colors.black45
                                    : Colors.white), */
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Tomorrow",
                      /*   style: TextStyle(
                                color: _controller.index == 2
                                    ? Colors.black45
                                    : Colors.white), */
                    ),
                  ),
                ],
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
