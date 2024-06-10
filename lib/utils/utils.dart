// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

// ダミーのJSONデータ
final dummyEvents = {
  // Cloud Firestoreをイメージして、keyが２０文字の英語と数字、値が日付と、メモ
  'pqxft55555pqxft55555': ['2024-06-01', 'サウナにいった'],
  'pqxft55555pqxft55556': ['2024-06-02', 'ジムにいった'],
  'pqxft55555pqxft55557': ['2024-06-03', 'ランニングにいった'],
  'pqxft55555pqxft55558': ['2024-06-04', '筋トレにいった'],
};

// イベントの日付をキーにして、イベントのリストを値にしたマップ
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(
    Map.fromEntries(
      dummyEvents.entries.map(
        (e) => MapEntry(
          DateTime.parse(e.value[0]),
          [
            Event(e.value[1]),
          ],
        ),
      ),
    ),
  );

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
