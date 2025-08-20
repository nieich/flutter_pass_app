import 'package:flutter/material.dart';

class Destination {
  final String label;
  final Widget icon;

  const Destination({required this.label, required this.icon});
}

final destinations = <Destination>[
  Destination(icon: Image.asset('assets/icons/clock_icon.png', scale: 1.5), label: 'Clock'),
  Destination(icon: Image.asset('assets/icons/alarm_icon.png', scale: 1.5), label: 'Alarm'),
  Destination(icon: Image.asset('assets/icons/stopwatch_icon.png', scale: 1.5), label: 'Stopwatch'),
  Destination(icon: Image.asset('assets/icons/timer_icon.png', scale: 1.5), label: 'Timer'),
];
