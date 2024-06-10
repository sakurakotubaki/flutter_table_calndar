import 'package:flutter/material.dart';
import 'package:flutter_table_calendart/utils/event_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<Event>> _events = {};
  List<Event> _selectedEvents = [];
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final eventUtils = EventUtils();
      final fetchedEvents = await eventUtils.fetchEvents();
      setState(() {
        _events = fetchedEvents;
        _selectedEvents = _events[_selectedDay] ?? [];
      });
    } catch (e) {
      print('Failed to fetch events: $e');
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
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
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: DateTime.now(),
            eventLoader: (day) => _events[day] ?? [],
            onDaySelected: _onDaySelected,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedEvents.length,
              itemBuilder: (context, index) {
                final event = _selectedEvents[index];
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
