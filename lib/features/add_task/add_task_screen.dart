import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/features/add_task/styles/formField_style.dart';
import 'package:todo/shared/models/tasks_model.dart';
import 'package:todo/shared/widgets/colored_button.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/shared/widgets/myContainer.dart';
import 'package:todo/shared/widgets/myDivider.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';

class AddTaskScreen extends StatefulWidget {
  static const String routeName = "/task_screen";

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();

  final TextEditingController _date = TextEditingController();

  final TextEditingController _time = TextEditingController();

  @override
  void initState() {
    super.initState();
    _date.text =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    _time.text = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        closeKeyboard(context);
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Stack(
              children: [
                ColoredCircles(),
                SafeArea(child: BackButton()),
              ],
            ),
            SingleChildScrollView(
              child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyContainer(
                          child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: TextFormField(
                                controller: _title,
                                decoration: myDecoration(
                                    label: "Title",
                                    hint: "Enter task title",
                                    myIcon:
                                        Icon(Icons.drive_file_rename_outline)),
                                keyboardType: TextInputType.name,
                                validator: (String? value) {
                                  return value!.isNotEmpty
                                      ? null
                                      : "Title is empty";
                                },
                              ),
                            ),
                            MyDivider(),
                            InkWell(
                              onTap: () async {
                                await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate:
                                            DateTime(DateTime.now().year - 20),
                                        lastDate:
                                            DateTime(DateTime.now().year + 30))
                                    .then((DateTime? value) {
                                  _date.text =
                                      "${value!.day}/${value.month}/${value.year}";
                                });
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: _date,
                                  decoration: myDecoration(
                                      label: "Date",
                                      hint: "Choose task date",
                                      myIcon: Icon(Icons.calendar_today)),
                                ),
                              ),
                            ),
                            MyDivider(),
                            InkWell(
                              onTap: () async {
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now()).then((TimeOfDay? value){
                                          _time.text = "${value!.hour}:${value.minute}";
                                });
                              },
                              child: IgnorePointer(
                                child: TextFormField(
                                  controller: _time,
                                  decoration: myDecoration(
                                      label: "Time",
                                      hint: "Choose task time",
                                      myIcon: Icon(Icons.access_time_sharp)),
                                ),
                              ),
                            ),
                            MyDivider(),
                            DropdownButtonFormField<Priority>(
                              items: Priority.values.map((element) {
                                return DropdownMenuItem<Priority>(
                                  child: Text(getPriorityText(element)),
                                  value: element,
                                );
                              }).toList(),
                              //  icon: Icon(Icons.priority_high_rounded),
                              decoration: myDecoration(
                                  label: "Priority",
                                  hint: "",
                                  myIcon: Icon(Icons.priority_high_rounded)),
                              onChanged: (value) {},
                            ),
                            MyDivider(),
                            SwitchListTile(
                              value: false,
                              onChanged: (bool newValue) {},
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.notification_important_rounded,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  SizedBox(
                                    width: 2 * widthMultiplier,
                                  ),
                                  Text(
                                    "Enable Notification",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.4)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                      SizedBox(
                        height: 5 * heightMultiplier,
                      ),
                      Container(
                        height: 8 * heightMultiplier,
                        width: 75 * widthMultiplier,
                        child: ColoredButton(
                            text: "Add Task",
                            function: () {
                              if (_formKey.currentState!.validate()) {}
                            }),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
