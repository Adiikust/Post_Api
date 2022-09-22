import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/Controller/Export/export_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryScreen extends StatefulWidget {
  late String? personalID;
  late String? location;
  late String? locationId;
  late String? userId;
  DeliveryScreen({
    String? personalID,
    String? location,
    String? locationId,
    String? userId,
  }) {
    this.personalID = personalID;
    this.location = location;
    this.locationId = locationId;
    this.userId = userId;
  }

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  late Box<String> storeMobileApiData;
  var isLoading = false;
  var isButton = false;
  var _articleId = "";
  var _transitState = "";
  var _location_Name = "";
  var _sysId = "";
  var _data = "";
  /*Future<void> _storeData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _upadate = (prefs.getString('counter') ?? _upadate.toString() + _data);
      prefs.setString('counter', _upadate);
      print(_upadate);
    });
  }*/
  //Process
  /*Future<void> _upLoadfile() async {
    isLoading = true;
    await Future.delayed(Duration(seconds: 3));
    isLoading = false;
  }*/
  //

  String SelectedCurrentValue = "Change Status";
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _scanArticleData = TextEditingController();
  final TextEditingController _textArticleData = TextEditingController();
  final String txt = "DO";

  Future<void> fetchUserData({
    required String personalID,
    required String location,
    required String locationId,
    required String userId,
    required String barCode,
  }) async {
    final Response response = await http.post(
      Uri.parse('http://58.65.169.108:999/MobileAPP/ArticleUpdate'),
      body: {
        "BagTrackingNo": "$txt$locationId${DateTime.now().toString()}",
        "Bag_Id": Hive.box('StoreBiId').get("data") ?? "0",
        "FromLocationId": locationId,
        "UserId": userId,
        "ShiftId": "1",
        "_Articles": "${_counter.toString()}-$barCode",
        "DA": userId,
        "_SheetNo": "217",
        "_ClerkSheetNo": "$userId-217",
        "sys_Id": _sysId.toString(),
        "ExciseArticle": "0"
      },
    );
    if (response.statusCode == 200) {
      var data = response.body.toString();
      print(data);
      _articleId = jsonDecode(data)["ArticleNo"];
      _transitState = jsonDecode(data)["TransitState"];
      _location_Name = jsonDecode(data)["Location_Name"];
      _data = jsonDecode(data)["BagID"].toString();
      Hive.box('StoreBiId').put("data", _data);
      print(Hive.box('StoreBiId').get("data"));
    } else {
      print("No data");
    }
  }

  Future<void> fetchSysId({
    required String userId,
  }) async {
    final response = await http.post(Uri.parse(
        "http://58.65.169.108:999/MobileAPP/Sys_Id?Sender_Location_Id=$userId"));
    if (response.statusCode == 200) {
      var data1 = response.body.toString();
      _sysId = jsonDecode(data1).toString();
    } else {
      print("Error");
    }
  }

  _startBarcodeScanStream() async {
    return await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)
        .then((value) {
      setState(() {
        _scanArticleData.text = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSysId(
      userId: widget.userId.toString(),
    );
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isLoading = !isLoading;
      });
    });
    storeMobileApiData = Hive.box<String>("adnan");
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 23),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {
                            Hive.box('isUserLogin')
                                .put('isUserLoggedIn', false);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          icon: const Icon(Icons.logout)),
                    ),
                    SizedBox(
                      height: data.size.height * 0.04,
                    ),
                    Visibility(
                      visible: isLoading,
                      child: TextFormField(
                        controller: _scanArticleData,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          hintText: "Enter the Article ",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter article';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: data.size.height * 0.04,
                    ),
                    Visibility(
                      visible: isLoading,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _startBarcodeScanStream();
                            },
                            child: Container(
                              height: data.size.height * 0.05,
                              width: data.size.width * 0.45,
                              decoration: BoxDecoration(
                                  color: AppColors.kButton,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.document_scanner,
                                        size: 21,
                                        color: AppColors.kWhite,
                                      ),
                                    ),
                                    SizedBox(
                                      width: data.size.height * 0.005,
                                    ),
                                    const Expanded(
                                      flex: 7,
                                      child: Text(
                                        "BarCode Scan",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: AppColors.kWhite),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: data.size.height * 0.04,
                    ),
                    InkWell(
                      onTap: () {
                        // _upLoadfile();
                        if (_formKey.currentState!.validate()) {
                          final key = _scanArticleData.text;
                          final value = _textArticleData.text.toString();
                          storeMobileApiData.put(key, value);
                          fetchUserData(
                              location: widget.location!,
                              locationId: widget.locationId!,
                              personalID: widget.personalID!,
                              userId: widget.userId!,
                              barCode: _scanArticleData.text);
                          _incrementCounter();
                          _scanArticleData.clear();
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: data.size.height * 0.06,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: AppColors.kButton,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text("Save",
                            // isLoading ? "Processing" : "Save",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.kWhite,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: data.size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Article Id",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Status",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: data.size.height * 0.04,
                    ),
                    ValueListenableBuilder(
                        valueListenable: storeMobileApiData.listenable(),
                        builder: (context, Box<String> adnan, _) {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final key = adnan.keys.toList()[index];

                              return SizedBox(
                                height: data.size.width * 0.1,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$key",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                              child: const Text("Saved"),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        child: SizedBox(
                                                          height: 300,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Center(
                                                                    child: Text(
                                                                        "$key",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              20,
                                                                        ))),
                                                                SizedBox(
                                                                  height: data
                                                                          .size
                                                                          .height *
                                                                      0.04,
                                                                ),
                                                                Text(
                                                                  _articleId
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                SizedBox(
                                                                  height: data
                                                                          .size
                                                                          .height *
                                                                      0.04,
                                                                ),
                                                                Text(
                                                                  _transitState
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                SizedBox(
                                                                  height: data
                                                                          .size
                                                                          .height *
                                                                      0.04,
                                                                ),
                                                                Text(
                                                                  _location_Name
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                                ),
                                                                SizedBox(
                                                                  height: data
                                                                          .size
                                                                          .height *
                                                                      0.04,
                                                                ),
                                                                Center(
                                                                  child:
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text("Close")),
                                                                )
                                                              ],
                                                            ),
                                                            /* FutureBuilder(
                                                                future: fetchUserDara(
                                                                    location: widget
                                                                        .location!,
                                                                    locationId: widget
                                                                        .locationId!,
                                                                    personalID: widget
                                                                        .personalID!,
                                                                    userId: widget
                                                                        .userId!,
                                                                    barCode:
                                                                        _scanArticleData
                                                                            .text),
                                                                builder: (context,
                                                                    AsyncSnapshot<
                                                                            Userdatamodel>
                                                                        snapshot) {
                                                                  //  print("fgh$snapshot");
                                                                  if (!snapshot
                                                                      .hasData) {
                                                                    return const Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                          "Loading..."),
                                                                    );
                                                                  } else {
                                                                    return Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Center(
                                                                            child: Text(
                                                                                "$key",
                                                                                style: const TextStyle(
                                                                                  fontSize: 20,
                                                                                ))),
                                                                        SizedBox(
                                                                          height: data.size.height *
                                                                              0.04,
                                                                        ),
                                                                        Text(
                                                                          widget
                                                                              .location
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  20),
                                                                        ),
                                                                        SizedBox(
                                                                          height: data.size.height *
                                                                              0.04,
                                                                        ),
                                                                        Text(
                                                                          widget
                                                                              .location
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  20),
                                                                        ),
                                                                        SizedBox(
                                                                          height: data.size.height *
                                                                              0.04,
                                                                        ),
                                                                        Text(
                                                                          widget
                                                                              .locationId
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  20),
                                                                        ),
                                                                        SizedBox(
                                                                          height: data.size.height *
                                                                              0.04,
                                                                        ),
                                                                        Center(
                                                                          child: ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: const Text("Close")),
                                                                        )
                                                                      ],
                                                                    );
                                                                  }
                                                                }),*/
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              }),
                                          SizedBox(
                                            width: data.size.width * 0.06,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              storeMobileApiData.delete(key);
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: storeMobileApiData.keys.toList().length,
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _counter = 0;
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 0) + 1;
      prefs.setInt('counter', _counter);
    });
  }
}
/*Card(
                          child: ListTile(
                            title: Text("$key",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                            trailing: InkWell(
                              onTap: (){
                                storeMobileApiData.delete(key);
                              },
                              child: const Icon(Icons.delete),),
                          ),
                        );*/
/*  InkWell(
                                    onTap: (){},
                                    child: Text("Saved",style: TextStyle(fontSize: 15),)),*/
