class ContentData {
  final String type;
  final String audiourl;
  final List<Lyrics> lyrics;

  ContentData({
    required this.type,
    required this.audiourl,
    required this.lyrics,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      type: json['type'] ?? '',
      audiourl: json['audiourl'] ?? '',
      lyrics: (json['lyrics'] as List)
          .map((data) => Lyrics.fromJson(data))
          .toList(),
    );
  }

  // Convert ContentData to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'audiourl': audiourl,
      'lyrics': lyrics.map((lyric) => lyric.toJson()).toList(),
    };
  }
}

class Lyrics {
  final String time;
  final String arabic;
  final String translitration;
  final String translation;

  Lyrics({
    required this.time,
    required this.arabic,
    required this.translitration,
    required this.translation,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    return Lyrics(
      time: json['time'] ?? '',
      arabic: json['arabic'] ?? '',
      translitration: json['translitration'] ?? '',
      translation: json['translation'] ?? '',
    );
  }

  // Convert Lyrics to JSON
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'arabic': arabic,
      'translitration': translitration,
      'translation': translation,
    };
  }
}
