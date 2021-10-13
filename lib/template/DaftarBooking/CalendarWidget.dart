import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../extensions/DateExtension.dart';

class CalendarWidget extends StatelessWidget {
  final Function callback;
  final DateTime selected;
  final DateTime focused;
  CalendarWidget(
      {required this.selected, required this.focused, required this.callback});
  @override
  Widget build(BuildContext context) {
    var bg = Colors.white;
    var tc = Colors.black;
    return TableCalendar(
      calendarFormat: CalendarFormat.week,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) =>
          callback(selectedDay, focusedDay),
      selectedDayPredicate: (day) {
        return day.isSameDate(selected);
      },
      // onFormatChanged: (),
      calendarStyle: CalendarStyle(
          // dec
          defaultDecoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          defaultTextStyle: TextStyle(color: tc, fontSize: 16),
          weekendDecoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          weekendTextStyle: TextStyle(color: tc, fontSize: 16),
          outsideDecoration:
              BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
          outsideTextStyle: TextStyle(color: tc),
          todayDecoration:
              BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          selectedTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          selectedDecoration: BoxDecoration(
              color: Colors.lightBlue[300], shape: BoxShape.circle)),
      headerStyle: HeaderStyle(
          // headerMargin: EdgeInsets.only(bottom: 10),
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(color: bg, fontSize: 22),
          leftChevronIcon: Icon(Icons.chevron_left, color: bg),
          rightChevronIcon: Icon(Icons.chevron_right, color: bg)),
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(DateTime.now().year, DateTime.now().month + 1, 31),
      focusedDay: focused,
      // selectedDayPredicate: selec,
      calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
        final text = DateFormat.E().format(day);
        var color =
            day.weekday == DateTime.sunday ? Colors.red[400] : Colors.white;
        return Center(
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 18),
          ),
        );
      }),
    );
  }
}
