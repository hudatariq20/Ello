import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

/// A custom audio source that plays raw MP3 bytes using just_audio
class MyCustomSource extends StreamAudioSource {
  final List<int> audioBytes; // Audio data from ElevenLabs API

  MyCustomSource(this.audioBytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // Convert the List<int> to Uint8List for streaming
    final Uint8List fullData = Uint8List.fromList(audioBytes);

    // Slice the bytes if a range is requested (for buffering/seeking)
    final Uint8List slicedData = (start != null && end != null)
        ? fullData.sublist(start, end)
        : fullData;

    return StreamAudioResponse(
      sourceLength: fullData.length, // Total size of the audio
      contentLength: slicedData.length, // Size of the returned chunk
      offset: start ?? 0, // Offset of the chunk
      stream: Stream.value(slicedData), // Actual stream
      contentType: 'audio/mpeg', // Format for ElevenLabs
    );
  }
}
