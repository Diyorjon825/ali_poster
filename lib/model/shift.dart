import 'worker.dart';

class Shift {
  Shift({
    required this.id,
    required this.totalCash,
    required this.totalCard,
    required this.createdShiftWorkerId,
    required this.createdShiftWorker,
    required this.closedShiftWorkerId,
    required this.closedShiftWorker,
    required this.created,
    required this.closed,
  });

  int id;
  int totalCash;
  int totalCard;
  int createdShiftWorkerId;
  Worker createdShiftWorker;
  int closedShiftWorkerId;
  Worker closedShiftWorker;
  DateTime created;
  DateTime closed;

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json["id"],
        totalCash: json["totalCash"],
        totalCard: json["totalCard"],
        createdShiftWorkerId: json["createdShiftWorkerId"],
        createdShiftWorker: Worker.fromJson(json["createdShiftWorker"]),
        closedShiftWorkerId: json["closedShiftWorkerId"],
        closedShiftWorker: Worker.fromJson(json["closedShiftWorker"]),
        created: DateTime.parse(json["created"]),
        closed: DateTime.parse(json["closed"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "totalCash": totalCash,
        "totalCard": totalCard,
        "createdShiftWorkerId": createdShiftWorkerId,
        "createdShiftWorker": createdShiftWorker.toJson(),
        "closedShiftWorkerId": closedShiftWorkerId,
        "closedShiftWorker": closedShiftWorker.toJson(),
        "created": created.toIso8601String(),
        "closed": closed.toIso8601String(),
      };
}
