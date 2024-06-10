import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String? uuid;
  final String? memo;
  final Timestamp? createdAt;

  // toJson
  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'memo': memo,
        'createdAt': createdAt,
      };

  // fromJson
  Event.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'] as String?,
        memo = json['memo'] as String?,
        createdAt = json['createdAt'] as Timestamp?;
}

class EventUtils {
  final db = FirebaseFirestore.instance;

  // event collectionから全データを取得
  Future<List<Event>> getEvents() async {
    final snapshot = await db.collection('event').get();
    return snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList();
  }

  Future<LinkedHashMap<DateTime, List<Event>>> fetchEvents() async {
    final events = await getEvents();
    final eventMap = <DateTime, List<Event>>{};
    for (final event in events) {
      final eventDate = event.createdAt!.toDate();
      if (eventMap[eventDate] == null) {
        eventMap[eventDate] = [event];
      } else {
        eventMap[eventDate]!.add(event);
      }
    }
    return LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventMap);
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

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
