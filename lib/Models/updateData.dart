import 'dart:convert';

/// BagTrackingNo : "DO183420171012130216"
/// Bag_Id : "0"
/// FromLocationId : "1834"
/// UserId : "1784"
/// ShiftId : "1"
/// _Articles : "10-RGL99188334"
/// DA : "1753"
/// _SheetNo : "217"
/// _ClerkSheetNo : "1784-217"
/// sys_Id : ""
/// ExciseArticle : "0"

UpdateData updateDataFromJson(String str) =>
    UpdateData.fromJson(json.decode(str));
String updateDataToJson(UpdateData data) => json.encode(data.toJson());

class UpdateData {
  UpdateData({
    String? bagTrackingNo,
    String? bagId,
    String? fromLocationId,
    String? userId,
    String? shiftId,
    String? articles,
    String? da,
    String? sheetNo,
    String? clerkSheetNo,
    String? sysId,
    String? exciseArticle,
  }) {
    _bagTrackingNo = bagTrackingNo;
    _bagId = bagId;
    _fromLocationId = fromLocationId;
    _userId = userId;
    _shiftId = shiftId;
    _articles = articles;
    _da = da;
    _sheetNo = sheetNo;
    _clerkSheetNo = clerkSheetNo;
    _sysId = sysId;
    _exciseArticle = exciseArticle;
  }

  UpdateData.fromJson(dynamic json) {
    _bagTrackingNo = json['BagTrackingNo'];
    _bagId = json['Bag_Id'];
    _fromLocationId = json['FromLocationId'];
    _userId = json['UserId'];
    _shiftId = json['ShiftId'];
    _articles = json['_Articles'];
    _da = json['DA'];
    _sheetNo = json['_SheetNo'];
    _clerkSheetNo = json['_ClerkSheetNo'];
    _sysId = json['sys_Id'];
    _exciseArticle = json['ExciseArticle'];
  }
  String? _bagTrackingNo;
  String? _bagId;
  String? _fromLocationId;
  String? _userId;
  String? _shiftId;
  String? _articles;
  String? _da;
  String? _sheetNo;
  String? _clerkSheetNo;
  String? _sysId;
  String? _exciseArticle;
  UpdateData copyWith({
    String? bagTrackingNo,
    String? bagId,
    String? fromLocationId,
    String? userId,
    String? shiftId,
    String? articles,
    String? da,
    String? sheetNo,
    String? clerkSheetNo,
    String? sysId,
    String? exciseArticle,
  }) =>
      UpdateData(
        bagTrackingNo: bagTrackingNo ?? _bagTrackingNo,
        bagId: bagId ?? _bagId,
        fromLocationId: fromLocationId ?? _fromLocationId,
        userId: userId ?? _userId,
        shiftId: shiftId ?? _shiftId,
        articles: articles ?? _articles,
        da: da ?? _da,
        sheetNo: sheetNo ?? _sheetNo,
        clerkSheetNo: clerkSheetNo ?? _clerkSheetNo,
        sysId: sysId ?? _sysId,
        exciseArticle: exciseArticle ?? _exciseArticle,
      );
  String? get bagTrackingNo => _bagTrackingNo;
  String? get bagId => _bagId;
  String? get fromLocationId => _fromLocationId;
  String? get userId => _userId;
  String? get shiftId => _shiftId;
  String? get articles => _articles;
  String? get da => _da;
  String? get sheetNo => _sheetNo;
  String? get clerkSheetNo => _clerkSheetNo;
  String? get sysId => _sysId;
  String? get exciseArticle => _exciseArticle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['BagTrackingNo'] = _bagTrackingNo;
    map['Bag_Id'] = _bagId;
    map['FromLocationId'] = _fromLocationId;
    map['UserId'] = _userId;
    map['ShiftId'] = _shiftId;
    map['_Articles'] = _articles;
    map['DA'] = _da;
    map['_SheetNo'] = _sheetNo;
    map['_ClerkSheetNo'] = _clerkSheetNo;
    map['sys_Id'] = _sysId;
    map['ExciseArticle'] = _exciseArticle;
    return map;
  }
}
