import 'package:flutter_riverpod/flutter_riverpod.dart';

final obsecuretextProvider = StateProvider<bool>((ref) => false);

final pickedDueDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final selectedPriorityProvider = StateProvider<String>((ref) => "high");

final currentIndexProvider = StateProvider<int>((ref) => 0);
