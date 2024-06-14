import 'package:flutter/material.dart';
import 'package:flutter_table_calendart/utils/event_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // カレンダーの最初の日付
  Map<DateTime, List<Event>> _events = {};
  // カレンダーの最後の日付
  List<Event> _selectedEvents = [];
  // 選択された日付
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    // _fetchEventsを呼び出す
    _fetchEvents();
  }

  // イベントを取得する
  Future<void> _fetchEvents() async {
    try {
      // EventUtilsをインスタンス化
      final eventUtils = EventUtils();
      // fetchEventsを呼び出し、取得したデータをfetchedEventsに代入
      final fetchedEvents = await eventUtils.fetchEvents();
      setState(() {
        // _eventsにfetchedEventsを代入
        _events = fetchedEvents;
        // _selectedEventsに_events[_selectedDay]を代入
        // _selectedDayが_eventsにない場合は、[]を代入
        // _events[] のデータ型はList<Event>なので、List<Event>を代入
        _selectedEvents = _events[_selectedDay] ?? [];
      });
    } catch (e) {
      debugPrint('Failed to fetch events: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      // _selectedDayにselectedDayを代入
      _selectedDay = selectedDay;
      // _selectedEventsに_events[_selectedDay]を代入
      // _selectedDayが_eventsにない場合は、[]を代入
      // _events[] のデータ型はList<Event>なので、List<Event>を代入
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            // _eventsのキーを取得
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            firstDay: kFirstDay, // カレンダーの最初の日付
            lastDay: kLastDay, // カレンダーの最後の日付
            focusedDay: DateTime.now(), // フォーカスされている日付
            eventLoader: (day) => _events[day] ?? [], // イベントを取得
            onDaySelected: _onDaySelected, // 日付が選択されたときの処理
          ),
          // 選択された日付のイベントを表示
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length, // _selectedEventsの数だけリストを表示
              itemBuilder: (context, index) {
                final event =
                    _selectedEvents[index]; // _selectedEventsのindex番目のデータを取得
                return ListTile(
                  title: Text(event.memo ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
