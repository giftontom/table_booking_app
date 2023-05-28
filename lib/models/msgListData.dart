class MsgListData {
  String orderId;
  String message;
  String formatDate;

  MsgListData(this.orderId, this.message, this.formatDate);

  factory MsgListData.fromJson(Map<String, dynamic> json) {
    return MsgListData(json['orderId'], json['message'], json['formatDate']);
  }
}
