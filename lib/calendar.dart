import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List> _eventsList = {};

 @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    //サンプルのイベントリスト
    _eventsList = {
      DateTime.now().add(Duration(days: 11)): ['Event A11', 'Event B11'],
      DateTime.now().add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      DateTime.now().add(Duration(days: 22)): ['Event A13', 'Event B13'],
      DateTime.now().add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };
  }
  @override
  Widget build(BuildContext context) {

    final _events = LinkedHashMap<DateTime, List>(
    /// If [equals] is provided, it is used to compare the keys in the table with
  /// new keys. If [equals] is omitted, the key's own [Object.==] is used
  /// instead.
  ///
  /// Similarly, if [hashCode] is provided, it is used to produce a hash value
  /// for keys in order to place them in the hash table. If it is omitted, the
  /// key's own [Object.hashCode] is used.
  ///
  /// The used `equals` and `hashCode` method should always be consistent,
  /// so that if `equals(a, b)` then `hashCode(a) == hashCode(b)`. The hash
  /// of an object, or what it compares equal to, should not change while the
  /// object is in the table. If it does change, the result is unpredictable.
  ///

  
      equals: isSameDay,
      // ハッシュコードはobjectを識別するint型    
      // getHashCodeは、hashCodeが Function(DateTime)と定義されている為、()の引数はいらない
      // hashCode:(datetime){return getHashCode(datetime);}は、hashCode: getHashCodeと同定義 ,
  
  
      hashCode: getHashCode
    )..addAll(_eventsList);

    List _getEventForDay(DateTime day) {
      //  _events[day]がnullでなければ、 _events[day]を返す。
      return _events[day] ?? [];
    }
    
    return Scaffold(
      body: Center(
        child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            eventLoader: _getEventForDay,
            calendarFormat: _calendarFormat,
            // カレンダーのフォーマットを変更
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            }
        ),
      ),
    );
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

}
