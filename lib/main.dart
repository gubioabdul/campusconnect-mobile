import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const CampusConnectApp());

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(title: 'CampusConnect', theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo), home: const EventListScreen());
}

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});
  @override State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<dynamic> events = [];
  bool loading = true;
  String? error;
  static const String baseUrl = 'http://10.0.2.2:5000';

  @override void initState() { super.initState(); fetchEvents(); }

  Future<void> fetchEvents() async {
    setState(() { loading = true; error = null; });
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/events'));
      if (response.statusCode != 200) throw Exception('API returned ${response.statusCode}');
      setState(() { events = jsonDecode(response.body) as List<dynamic>; loading = false; });
    } catch (_) { setState(() { loading = false; error = 'Could not connect to CampusConnect API.'; }); }
  }

  Future<void> registerAttendance(int id) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(context: context, builder: (context) => AlertDialog(
      title: const Text('Register attendance'),
      content: TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Your name')),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Register'))],
    ));
    if (name == null || name.isEmpty) return;
    final response = await http.post(Uri.parse('$baseUrl/api/events/$id/attend'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'name': name}));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.statusCode == 200 ? 'Attendance registered.' : 'Registration failed.')));
    if (response.statusCode == 200) await fetchEvents();
  }

  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('CampusConnect'), actions: [IconButton(onPressed: fetchEvents, icon: const Icon(Icons.refresh))]),
    body: loading ? const Center(child: CircularProgressIndicator()) : error != null ? Center(child: Text(error!)) : RefreshIndicator(
      onRefresh: fetchEvents,
      child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: events.length, itemBuilder: (context, index) {
        final event = events[index] as Map<String, dynamic>;
        return Card(child: ListTile(contentPadding: const EdgeInsets.all(16), title: Text(event['title'] as String), subtitle: Padding(padding: const EdgeInsets.only(top: 8), child: Text('${event['date']}\nAttendees: ${(event['attendees'] as List<dynamic>).length}\n\n${event['description']}')), trailing: IconButton(tooltip: 'Attend', onPressed: () => registerAttendance(event['id'] as int), icon: const Icon(Icons.event_available))));
      }),
    ),
  );
}
