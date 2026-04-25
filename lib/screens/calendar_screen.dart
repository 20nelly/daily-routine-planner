import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../controllers/task_controller.dart';
import '../utils/themes.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<TaskController>(
        builder: (context, taskController, child) {
          return Column(
            children: [
              // Month Selector
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(_currentMonth),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              _currentMonth = DateTime(
                                _currentMonth.year,
                                _currentMonth.month - 1,
                              );
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              _currentMonth = DateTime(
                                _currentMonth.year,
                                _currentMonth.month + 1,
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Calendar - Use Flexible to prevent overflow
              Flexible(
                flex: 5,
                child: SingleChildScrollView(
                  child: _buildCalendar(taskController),
                ),
              ),

              // Tasks Section
              Flexible(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(
                          25,
                        ), // Changed from withOpacity(0.1)
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Tasks for ${DateFormat('MMM dd, yyyy').format(_selectedDate)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: _buildTasksForDate(taskController)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendar(TaskController taskController) {
    final firstDayOfMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month,
      1,
    );
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = DateTime(
      _currentMonth.year,
      _currentMonth.month + 1,
      0,
    ).day;

    List<DateTime> calendarDays = [];

    // Previous month days
    for (int i = firstWeekday - 1; i > 0; i--) {
      calendarDays.add(firstDayOfMonth.subtract(Duration(days: i)));
    }
    // Current month days
    for (int i = 1; i <= daysInMonth; i++) {
      calendarDays.add(DateTime(_currentMonth.year, _currentMonth.month, i));
    }
    // Next month days
    final remainingDays = 42 - calendarDays.length;
    for (int i = 1; i <= remainingDays; i++) {
      calendarDays.add(
        DateTime(_currentMonth.year, _currentMonth.month + 1, i),
      );
    }

    return Column(
      children: [
        // Weekday headers
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SizedBox(
                width: 40,
                child: Text('Sun', textAlign: TextAlign.center),
              ),
              SizedBox(
                width: 40,
                child: Text('Mon', textAlign: TextAlign.center),
              ),
              SizedBox(
                width: 40,
                child: Text('Tue', textAlign: TextAlign.center),
              ),
              SizedBox(
                width: 40,
                child: Text('Wed', textAlign: TextAlign.center),
              ),
              SizedBox(
                width: 40,
                child: Text('Thu', textAlign: TextAlign.center),
              ),
              SizedBox(
                width: 40,
                child: Text('Fri', textAlign: TextAlign.center),
              ),
              SizedBox(
                width: 40,
                child: Text('Sat', textAlign: TextAlign.center),
              ),
            ],
          ),
        ),

        // Calendar dates
        ...List.generate(6, (rowIndex) {
          final startIndex = rowIndex * 7;
          final endIndex = startIndex + 7;
          if (startIndex >= calendarDays.length) return const SizedBox.shrink();

          final weekDays = calendarDays.sublist(
            startIndex,
            endIndex > calendarDays.length ? calendarDays.length : endIndex,
          );

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: weekDays.map((date) {
                final isCurrentMonth = date.month == _currentMonth.month;
                final isToday = _isSameDay(date, DateTime.now());
                final isSelected = _isSameDay(date, _selectedDate);
                final hasTasks = taskController
                    .getTasksForDate(date)
                    .isNotEmpty;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : (isToday
                                ? AppTheme.primaryColor.withAlpha(
                                    50,
                                  ) // Changed from withOpacity(0.2). 0.2 * 255 = 51
                                : Colors.transparent),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected || isToday
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : (isCurrentMonth
                                        ? Colors.black87
                                        : Colors.grey[400]),
                            ),
                          ),
                        ),
                        if (hasTasks && !isSelected)
                          Positioned(
                            bottom: 8,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 4,
                              width: 4,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),

        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildTasksForDate(TaskController taskController) {
    final tasks = taskController.getTasksForDate(_selectedDate);

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No tasks for this day',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isCompleted = task['isCompleted'] == true;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 30,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.grey
                      : _getCategoryColor(task['category']),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: isCompleted ? Colors.grey : Colors.black87,
                      ),
                    ),
                    if (task['description'] != null &&
                        task['description'].isNotEmpty)
                      Text(
                        task['description'],
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(task['category']).withAlpha(
                    25,
                  ), // Changed from withOpacity(0.1). 0.1 * 255 = 25.5 ≈ 25
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task['category'] ?? 'Personal',
                  style: TextStyle(
                    fontSize: 10,
                    color: _getCategoryColor(task['category']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
      case 'Work':
        return const Color(0xFFFF6584);
      case 'Health':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF6C63FF);
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
