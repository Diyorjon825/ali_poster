import 'package:event/event.dart';

class CancelOrCompleteOrderMessage {
  int orderId;
  int tableId;

  CancelOrCompleteOrderMessage({
    required this.orderId,
    required this.tableId,
  });

  factory CancelOrCompleteOrderMessage.fromJson(Map json) =>
      CancelOrCompleteOrderMessage(orderId: json["orderId"], tableId: json["tableId"]);

  Map toJson() => {"orderId": orderId, "tableId": tableId};
}

class SwapModel {
  int orderId;
  int fromTableId;
  int toTableId;

  SwapModel({
    required this.orderId,
    required this.fromTableId,
    required this.toTableId,
  });

  factory SwapModel.fromJson(Map json) => SwapModel(
        orderId: json["orderId"],
        fromTableId: json["fromTableId"],
        toTableId: json["toTableId"],
      );
}

class TableMessage extends EventArgs {
  int id;
  int type;
  bool isBusy;

  TableMessage({
    required this.id,
    required this.type,
    required this.isBusy,
  });

  factory TableMessage.fromJson(Map json) => TableMessage(
        id: json["tableId"],
        type: json["tableMessageType"],
        isBusy: json["isBusy"],
      );

  Map toJson() => {
        "TableId": id,
        "TableMessageType": type,
        "isBusy": isBusy,
      };
}
