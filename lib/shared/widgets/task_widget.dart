import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/shared/styles/styles.dart';
import 'package:todo/utils/colors.dart';
import 'package:todo/utils/size_config.dart';

class TaskWidget extends StatelessWidget {
  final String title;
  final String time;
  final Color color;
  final bool notification;
  final bool isDone;
  final Function delete;

  const TaskWidget(
      {required this.title,
      required this.time,
      required this.color,
      required this.notification,
      required this.isDone, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete_forever,
          caption: "Delete",
          onTap: (){
            showDialog(context: context, builder: (ctx)=> AlertDialog(
              title: Text("Are you sure?"),
              content: Text("Are you sure to delete this task?"),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(ctx).pop();
                }, child: Text("Cancel")),
                TextButton(onPressed: (){
                  Navigator.of(ctx).pop();
                  delete();
                }, child: Text("Delete", style: TextStyle(color: Colors.red),)),
              ],
            ) );
          },
        )
      ],
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 5 * heightMultiplier, horizontal: 7 * widthMultiplier),
        height: 13 * heightMultiplier,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.transparent),
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black12)),
          color: secondaryColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 5 * widthMultiplier,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  color: isDone ? Colors.grey : color,
                ),
              ),
              Checkbox(
                value: isDone,
                onChanged: (bool? value) {},
                shape: CircleBorder(),
              ),
              Container(
                child: Text(
                  title,
                  style: isDone ? doneTaskStyle() : null,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                width: 45 * widthMultiplier,
              ),
              Padding(
                padding: EdgeInsets.only(right: 5 * widthMultiplier),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    time,
                    style: isDone ? doneTaskStyle() : null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
