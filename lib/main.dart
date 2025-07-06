import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(PixelCalendarApp());
}

class PixelCalendarApp extends StatelessWidget {
  const PixelCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.black87, displayColor: Colors.black87),
        cardTheme: CardThemeData(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.all(8),
          shadowColor: Colors.blue.withValues(alpha: 0.3),
        ),
      ),
      home: PixelCalendar(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PixelCalendar extends StatefulWidget {
  const PixelCalendar({super.key});

  @override
  State<PixelCalendar> createState() => _PixelCalendarState();
}

class _PixelCalendarState extends State<PixelCalendar> {
  DateTime selectedMonth = DateTime.now();
  final _pageController = PageController(initialPage: DateTime.now().month - 1);

  final List<String> monthImages = [
    "assets/jan.jpeg",
    "assets/feb.jpeg",
    "assets/march.jpeg",
    "assets/apri.jpeg",
    "assets/may.jpeg",
    "assets/june.jpeg",
    "assets/july.jpeg",
    "assets/aug.jpeg",
    "assets/sep.jpeg",
    "assets/oct.jpg",
    "assets/nov.jpg",
    "assets/dec.jpeg",
  ];

  final List<Color> monthColors = [
    Colors.blue.shade400,
    Colors.pink.shade300,
    Colors.green.shade400,
    Colors.yellow.shade600,
    Colors.purple.shade400,
    Colors.orange.shade400,
    Colors.red.shade400,
    Colors.brown.shade400,
    Colors.teal.shade400,
    Colors.orange.shade800,
    Colors.deepPurple.shade400,
    Colors.red.shade800,
  ];

  void changeMonth(int offset) {
    final newMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + offset,
      1,
    );
    setState(() {
      selectedMonth = newMonth;
    });
    _pageController.animateToPage(
      newMonth.month - 1,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  List<TableRow> buildCalendar(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;

    List<Widget> dayWidgets = [];
    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDay = DateTime(month.year, month.month, day);
      final isSunday = currentDay.weekday == DateTime.sunday;
      final isToday =
          DateTime.now().day == day &&
          DateTime.now().month == month.month &&
          DateTime.now().year == month.year;

      dayWidgets.add(
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isToday
                ? monthColors[month.month - 1].withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: monthColors[month.month - 1], width: 2)
                : null,
            boxShadow: isToday
                ? [
                    BoxShadow(
                      color: monthColors[month.month - 1].withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 14,
                color: isSunday
                    ? Colors.red
                    : isToday
                    ? monthColors[month.month - 1]
                    : Colors.black87,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    List<TableRow> rows = [
      TableRow(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        children: ["S", "M", "T", "W", "T", "F", "S"]
            .map(
              (d) => Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    d,
                    style: TextStyle(
                      fontSize: 14,
                      color: d == "S"
                          ? Colors.red
                          : monthColors[month.month - 1],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ];

    for (int i = 0; i < dayWidgets.length; i += 7) {
      rows.add(
        TableRow(
          children: List.generate(7, (j) {
            return i + j < dayWidgets.length ? dayWidgets[i + j] : Container();
          }),
        ),
      );
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MMMM yyyy');
    String monthName = formatter.format(selectedMonth).toUpperCase();
    int monthIndex = selectedMonth.month - 1;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            SizedBox(
              height: 220,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    selectedMonth = DateTime(selectedMonth.year, index + 1, 1);
                  });
                },
                itemCount: 12,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(monthImages[index]),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            DigitalClock(accentColor: monthColors[monthIndex]),
            SizedBox(height: 30),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left, size: 32),
                        color: monthColors[monthIndex],
                        onPressed: () => changeMonth(-1),
                      ),
                      Column(
                        children: [
                          Text(
                            monthName,
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 1.2,
                              color: monthColors[monthIndex],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "${selectedMonth.year}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right, size: 32),
                        color: monthColors[monthIndex],
                        onPressed: () => changeMonth(1),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder.symmetric(
                        inside: BorderSide(color: Colors.grey.shade300),
                      ),
                      children: buildCalendar(selectedMonth),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DigitalClock extends StatefulWidget {
  final Color accentColor;

  const DigitalClock({super.key, required this.accentColor});

  @override
  DigitalClockState createState() => DigitalClockState();
}

class DigitalClockState extends State<DigitalClock> {
  late String _timeString;
  late Timer _timer;
  late String _dateString;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    setState(() {
      _timeString = DateFormat('hh:mm:ss a').format(now);
      _dateString = DateFormat('EEEE, MMMM d').format(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 40),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _timeString,
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 2,
                color: widget.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _dateString,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
