class Trip {
  const Trip({
    required this.id,
    required this.destinationId,
    required this.startingPoint,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  final String id;
  final String destinationId;
  final String startingPoint;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  Trip copyWith({String? status}) => Trip(
        id: id,
        destinationId: destinationId,
        startingPoint: startingPoint,
        startDate: startDate,
        endDate: endDate,
        status: status ?? this.status,
      );

  Map<String, Object> toJson() => {
        'id': id,
        'destinationId': destinationId,
        'startingPoint': startingPoint,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'status': status,
      };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        id: json['id'] as String,
        destinationId: json['destinationId'] as String,
        startingPoint: json['startingPoint'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        status: json['status'] as String,
      );
}
