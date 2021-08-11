import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:timezone/timezone.dart';
import 'package:todo/features/add_task/styles/formField_style.dart';
import 'package:todo/features/bottomBarScreen/bottomBar_screen.dart';
import 'package:todo/features/tasks/models/tasks_model.dart';
import 'package:todo/shared/widgets/colored_button.dart';
import 'package:todo/shared/widgets/colored_circles.dart';
import 'package:todo/shared/widgets/myContainer.dart';
import 'package:todo/shared/widgets/myDivider.dart';
import 'package:todo/utils/helper_functions.dart';
import 'package:todo/utils/size_config.dart';

import 'cubit/edit_cubit.dart';
import 'cubit/edit_states.dart';

class EditScreen extends StatefulWidget {
  static const String routeName = "/edit_screen";
  final Task task;

  const EditScreen({required this.task});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();

  final TextEditingController _date = TextEditingController();

  final TextEditingController _time = TextEditingController();
  final FocusNode _titleNode = FocusNode();

  bool _notification = false;

  @override
  void initState() {
    super.initState();
    _title.text = widget.task.title;
    DateTime _date = DateTime.parse(widget.task.date);
    this._date.text = "${_date.day}/${_date.month}/${_date.year}";
    _time.text = widget.task.time;
    _notification = widget.task.notification;
  }

  @override
  void dispose() {
    super.dispose();
    _title.dispose();
    _date.dispose();
    _time.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditCubit()
        ..init(TZDateTime.parse(local, widget.task.tzDateTime),
            widget.task.priority, _notification),
      child: BlocConsumer<EditCubit, EditStates>(
        //    buildWhen: (prev, current) => current is AddTaskStates,
        listener: (context, state) {
          if (state is EditSuccessState) {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                BottomBarScreen.routeName, (route) => false);
          }
          if (state is EditErrorState) showErrorDialog(context, state.errorMsg);
          if (state is CantCreateNotification)
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Time must be after now to get notification"),
                duration: Duration(seconds: 2, milliseconds: 500)));
        },
        builder: (context, state) {
          final cubit = EditCubit.get(context);
          return ModalProgressHUD(
            inAsyncCall: state is EditLoadingState,
            child: GestureDetector(
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
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 1 * heightMultiplier),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyContainer(
                                    child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 3.5),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          focusNode: _titleNode,
                                          controller: _title,
                                          decoration: myDecoration(
                                              label: "Title",
                                              hint: "Enter task title",
                                              myIcon: Icon(Icons
                                                  .drive_file_rename_outline)),
                                          keyboardType: TextInputType.name,
                                          validator: (String? value) {
                                            return value!.isNotEmpty
                                                ? null
                                                : "Title is empty";
                                          },
                                        ),
                                        MyDivider(),
                                        InkWell(
                                          onTap: () async {
                                            closeKeyboard(context);
                                            await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.parse(
                                                        widget.task.date),
                                                    firstDate: DateTime(
                                                        DateTime.now().year - 20),
                                                    lastDate: DateTime(
                                                        DateTime.now().year + 30))
                                                .then((DateTime? value) {
                                              if (value != null) {
                                                cubit.changeDateOfTask(value);
                                                _date.text =
                                                    "${value.day}/${value.month}/${value.year}";
                                              }
                                            });
                                          },
                                          child: IgnorePointer(
                                            child: TextFormField(
                                              controller: _date,
                                              decoration: myDecoration(
                                                  label: "Date",
                                                  hint: "Choose task date",
                                                  myIcon:
                                                      Icon(Icons.calendar_today)),
                                            ),
                                          ),
                                        ),
                                        MyDivider(),
                                        InkWell(
                                          onTap: () async {
                                            closeKeyboard(context);
                                            await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        cubit.initialTime)
                                                .then((TimeOfDay? value) {
                                              if (value != null) {
                                                cubit.changeTimeOfTask(value);
                                                _time.text =
                                                    "${value.hour}:${value.minute}";
                                              }
                                            });
                                          },
                                          child: IgnorePointer(
                                            child: TextFormField(
                                              controller: _time,
                                              decoration: myDecoration(
                                                  label: "Time",
                                                  hint: "Choose task time",
                                                  myIcon: Icon(
                                                      Icons.access_time_sharp)),
                                            ),
                                          ),
                                        ),
                                        MyDivider(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 30),
                                          child:
                                              DropdownButtonFormField<Priority>(
                                            value: widget.task.priority,
                                            items: Priority.values.map((element) {
                                              return DropdownMenuItem<Priority>(
                                                child: Text(
                                                    getPriorityText(element)),
                                                value: element,
                                              );
                                            }).toList(),
                                            //  icon: Icon(Icons.priority_high_rounded),
                                            decoration: myDecoration(
                                                label: "Priority",
                                                hint: "",
                                                myIcon: Icon(
                                                    Icons.priority_high_rounded)),
                                            onChanged: (value) {
                                              cubit.choosePriority(value);
                                            },
                                            onTap: () {
                                              closeKeyboard(context);
                                            },
                                            validator: (value) {
                                              if (value == null) {
                                                return "Choose the priority";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                        MyDivider(),
                                        SwitchListTile(
                                          value: _notification,
                                          onChanged: (bool? newValue) {
                                            closeKeyboard(context);
                                            setState(() {
                                              _notification = newValue!;
                                            });
                                            cubit.enableNotification(newValue!);
                                            if (newValue) {
                                              cubit.checkNotificationAbility();
                                            }
                                          },
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .notification_important_rounded,
                                                color:
                                                    Colors.black.withOpacity(0.4),
                                              ),
                                              SizedBox(
                                                width: 2 * widthMultiplier,
                                              ),
                                              Text(
                                                "Enable Notification",
                                                style: TextStyle(
                                                    color: _notification
                                                        ? Colors.black
                                                        : Colors.black
                                                            .withOpacity(0.4)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                                SizedBox(
                                  height: 5 * heightMultiplier,
                                ),
                                Container(
                                  height: 8 * heightMultiplier,
                                  width: 75 * widthMultiplier,
                                  child: ColoredButton(
                                      text: "Save",
                                      function: () {
                                        closeKeyboard(context);
                                        if (_formKey.currentState!.validate()) {
                                          cubit.saveChanges(widget.task.id!,
                                              _title.text, widget.task.isDone);
                                        }
                                      }),
                                )
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
