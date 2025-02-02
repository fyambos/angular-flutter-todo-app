// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/ui/screens/task/detail.dart';
import 'package:todoapp/utilities/const/colors.dart';
import 'package:todoapp/utilities/const/fonts.dart';
import 'package:todoapp/utilities/const/style.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  final bool isSelected;
  final Function(bool?)? onSelect;
  final VoidCallback onEdit;

  const TaskCard({
    super.key,
    required this.task,
    this.isSelected = false,
    this.onSelect,
    required this.onEdit,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: UIColors.whiteColor,
                boxShadow: customBoxShadow,
                borderRadius: const BorderRadius.all(
                  Radius.circular(xsSpacer),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: smSpacer),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title.capitalize(),
                          maxLines: 1,
                          style: const TextStyle(
                            color: UIColors.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: FONT_SIZE_SM,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 3,
              child: Row(
                children: [
                  Checkbox(
                    value: widget.isSelected,
                    onChanged: widget.onSelect,
                  ),
                  GestureDetector(
                    onTap: () {
                      showTaskDetailsBottomSheet(context, widget.task);
                    },
                    child: const Icon(
                      Icons.remove_red_eye_sharp,
                      color: UIColors.grayText,
                      size: 25,
                    ),
                  )
                ],
              )),
          Positioned(
              bottom: 12,
              right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: statebgColors[widget.task.state],
                      border: Border.all(
                        color: stateBorderColors[widget.task.state]!,
                      ),
                    ),
                    child: Text(stateLabels[widget.task.state]!,
                        style: TextStyle(
                            fontSize: FONT_SIZE_XS,
                            color: stateTextColors[widget.task.state]!)),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _endDatePassed()
                          ? UIColors.cancelledBorderColor
                          : UIColors.backgroundColor,
                      border: Border.all(
                        color: _endDatePassed()
                            ? UIColors.cancelledBorderColor
                            : UIColors.grayText,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: _endDatePassed()
                              ? UIColors.cancelledTextColor
                              : UIColors.grayText,
                          size: 14,
                        ),
                        Text(
                          ' ${'${widget.task.endDate.day}-${widget.task.endDate.month}-${widget.task.endDate.year}'}',
                          style: TextStyle(
                            color: _endDatePassed()
                                ? UIColors.cancelledTextColor
                                : UIColors.grayText,
                            fontSize: FONT_SIZE_SM,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Positioned(
            top: 0,
            right: 6,
            child: IconButton(
              icon: const Icon(Icons.edit, color: UIColors.grayText),
              onPressed: widget.onEdit,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linearToEaseOut,
    );

    _controller.forward();
  }

  bool _endDatePassed() {
    return widget.task.endDate.isBefore(DateTime.now());
  }
}
