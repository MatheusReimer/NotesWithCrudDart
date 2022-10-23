final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    id,
    createdTime,
    isImportant,
    number,
    title,
    description
  ];

  static final String id = '_id';
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String createdTime = 'createdTime';
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note(
      {this.id,
      required this.createdTime,
      required this.description,
      required this.isImportant,
      required this.number,
      required this.title});

  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        number: json[NoteFields.number] as int,
        createdTime: DateTime.parse([NoteFields.createdTime] as String),
        description: json[NoteFields.description] as String,
        title: json[NoteFields.title] as String,
        isImportant: json[NoteFields.isImportant] == 1,
      );

  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.createdTime: createdTime.toIso8601String(),
        NoteFields.description: description,
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.number: number,
        NoteFields.title: title
      };

  Note copy(
          {int? id,
          bool? isImportant,
          int? number,
          String? title,
          String? description,
          DateTime? createdTime}) =>
      Note(
          id: id ?? this.id,
          createdTime: createdTime ?? this.createdTime,
          description: description ?? this.description,
          isImportant: isImportant ?? this.isImportant,
          number: number ?? this.number,
          title: title ?? this.title);
}
