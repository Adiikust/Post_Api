class UpDataModel {
  final String bagTrackingNo;
  final String bagId;
  final String fromLocationId;
  final String userId;
  final String shiftId;
  final String articles;
  final String da;
  final String sheetNo;
  final String clerkSheetNo;
  final String sysId;
  final String exciseArticle;

  UpDataModel(
      {required this.bagTrackingNo,
      required this.bagId,
      required this.fromLocationId,
      required this.userId,
      required this.shiftId,
      required this.articles,
      required this.da,
      required this.sheetNo,
      required this.clerkSheetNo,
      required this.sysId,
      required this.exciseArticle});
  factory UpDataModel.fromJson(Map<String, dynamic> json) {
    return UpDataModel(
      bagTrackingNo: json['BagTrackingNo'],
      bagId: json['Bag_Id'],
      fromLocationId: json['FromLocationId'],
      userId: json['UserId'],
      shiftId: json['ShiftId'],
      articles: json['_Articles'],
      da: json['DA'],
      sheetNo: json['_SheetNo'],
      clerkSheetNo: json['_ClerkSheetNo'],
      sysId: json['sys_Id'],
      exciseArticle: json['ExciseArticle'],
    );
  }
}
