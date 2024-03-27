import 'package:flutter_riverpod/flutter_riverpod.dart';

///variable [Provider]<String> to hold -ss start time in 00:00:00 format
///variable defaults to '' when not used
final startTimeProvider = StateProvider((ref) => '');

///variable [Provider]<String> to hold -to stop time in 00:00:00 format
///variable defaults to '' when not used
final endTimeProvider = StateProvider((ref) => '');

///[StateProvider] that sets the length of the selected media
///so that [endTimeProvider] can not exceed it.
final maxTimeProvider = StateProvider((ref) => '');
// ffprobe cmd to get duration:
//ffprobe -v error -show_entries format=duration
// -of default=noprint_wrappers=1 -sexagesimal <input>
