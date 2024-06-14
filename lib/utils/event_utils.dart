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

  // event collectionから全データを取得し、日付ごとにグループ化
  Future<LinkedHashMap<DateTime, List<Event>>> fetchEvents() async {
    // event collectionから全データを取得
    final events = await getEvents();
    // eventMapに日付ごとにグループ化
    final eventMap = <DateTime, List<Event>>{};
    // for文でeventsを回して、eventMapに日付ごとにグループ化
    for (final event in events) {
      // event.createdAtをDateTime型に変換
      final eventDate = event.createdAt!.toDate();
      // eventMapに日付ごとにグループ化
      if (eventMap[eventDate] == null) {
        // eventMapにeventDateがない場合は、[event]をリストで追加
        eventMap[eventDate] = [event];
      } else {
        // eventMapにeventDateがある場合は、.add(event)でリストに追加
        eventMap[eventDate]!.add(event);
      }
    }
    // LinkedHashMap<DateTime, List<Event>>を返す
    return LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(eventMap); // eventMapを返す
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
