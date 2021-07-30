import 'package:todo/shared/models/tasks_model.dart';


List<Task> old = [];

List<Task> tasks = [
  Task(
      title: "Teeeesttttttygfdkgjsksdfghldfhghdgfoghhuofdhgofdhgofhgldfghdfkghdflhgjldfhgjldfghkfjghfjghfdjghfdhglsfgh;hga",
      priority: Priority.Normal,
      date: "2021-07-28",
      time: "18:30",
      notification: false,
    isDone: false,
  ) ,
  Task(
      title: "222 ... 2222",
      priority: Priority.Important,
      date: "2021-07-28",
      time: "18:30",
      notification: true,
    isDone: true,
  ),
  Task(
    title: "Teeeestttttty",
    priority: Priority.Normal,
    date: "2021-07-28",
    time: "18:30",
    notification: false,
    isDone: false,
  ) ,
  Task(
    title: "Teeeestttttty",
    priority: Priority.Normal,
    date: "2021-07-28",
    time: "18:30",
    notification: false,
    isDone: false,
  ) ,
  Task(
    title: "Teeeestttttty",
    priority: Priority.Normal,
    date: "2021-07-28",
    time: "18:30",
    notification: false,
    isDone: false,
  ) ,
  Task(
    title: "Teeeestttttty",
    priority: Priority.Normal,
    date: "2021-07-28",
    time: "18:30",
    notification: false,
    isDone: false,
  ) ,
  Task(
    title: "Teeeestttttty",
    priority: Priority.Normal,
    date: "2021-07-28",
    time: "18:30",
    notification: false,
    isDone: false,
  ) ,
  Task(
    title: "Teeeestttttty",
    priority: Priority.Normal,
    date: "2021-07-28",
    time: "18:30",
    notification: false,
    isDone: false,
  ) ,
];

/* ListView.builder(
itemCount: tasks.length,
itemBuilder: (ctx, index) => TaskWidget(
title: tasks[index].title,
time: tasks[index].time,
color: getPriorityColor(tasks[index].priority)),
) */


/*  Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16 * heightMultiplier),
              height: 80 * imageSizeMultiplier,
              //  width: 80 * imageSizeMultiplier,
              child: TabBarView(
                controller: _controller,
                children: [
                  /* Image.asset("assets/images/no_tasks.png",
                      height: 50 * imageSizeMultiplier,
                      width: 80 * imageSizeMultiplier), */

                  Image.asset(
                    "assets/images/no_tasks.png",
                    height: 40 * imageSizeMultiplier,
                    width: 80 * imageSizeMultiplier,
                  ),
                  Image.asset(
                    "assets/images/no_tasks.png",
                    height: 40 * imageSizeMultiplier,
                    width: 80 * imageSizeMultiplier,
                  ),
                ],
              ),
            ),
          ) */