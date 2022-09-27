import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:post_app/Controller/Export/export_screen.dart';
import 'package:post_app/Views/Update/update_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryScreen extends StatefulWidget {
  late String? personalID;
  late String? location;
  late String? locationId;
  late String? userId;
  late String? userFullName;
  DeliveryScreen({
    String? personalID,
    String? location,
    String? locationId,
    String? userId,
    String? userFullName,
  }) {
    this.personalID = personalID;
    this.location = location;
    this.locationId = locationId;
    this.userId = userId;
    this.userFullName = userFullName;
  }

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  late Box<String> storeMobileApiData;
  var isLoading = false;
  bool isButton = false;
  var _articleId = "";
  var _transitState = "";
  var _location_Name = "";
  var _cusClient_Id = "";
  var _recipientAddress = "";
  var _recipientName = "";
  var _sysId = "";
  var _data = "";
  var _bookingProcessId = "";

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _scanArticleData = TextEditingController();
  final TextEditingController _textArticleData = TextEditingController();
  final TextEditingController _updateController = TextEditingController();
  final String txt = "DO";

//UserData
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
      _cusClient_Id = jsonDecode(data)["CusClient_Id"].toString();
      _recipientName = jsonDecode(data)["RecipientName"];
      _recipientAddress = jsonDecode(data)["RecipientAddress"];
      _bookingProcessId = jsonDecode(data)["BookingprocessID"].toString();
      _data = jsonDecode(data)["BagID"].toString();
      Hive.box('StoreBiId').put("data", _data);
    } else {
      print("No data");
    }
  }

//Sys_id
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

//BarCode Scan
  _startBarcodeScanStream() async {
    return await FlutterBarcodeScanner.scanBarcode(
            'F44336FF', 'Cancel', true, ScanMode.BARCODE)
        .then((value) {
      setState(() {
        _scanArticleData.text = value;
      });
    });
  }

//initState
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
        appBar: AppBar(
          title: (const Text("Post Office")),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  widget.userFullName.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                accountEmail: Text(
                  widget.location.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                currentAccountPicture: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://www.businesslist.pk/img/pk/s/1606670029-34-pakistan-post-office.jpg")),
              ),
              ListTile(
                leading: const Icon(Icons.article),
                title: const Text('New Article'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Update Article'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateScreen(
                                s: _cusClient_Id.toString(),
                                add: _location_Name.toString(),
                                rd: _recipientAddress.toString(),
                                rn: _recipientName.toString(),
                                bookingId: _bookingProcessId.toString(),
                              )));
                  /*showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            height: data.size.height * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildText("S : ${_cusClient_Id.toString()}"),
                                  SizedBox(
                                    height: data.size.height * 0.02,
                                  ),
                                  buildText(
                                      "S_City : ${_location_Name.toString()}"),
                                  SizedBox(
                                    height: data.size.height * 0.02,
                                  ),
                                  buildText(
                                      "R_Name : ${_recipientName.toString()}"),
                                  SizedBox(
                                    height: data.size.height * 0.02,
                                  ),
                                  buildText(
                                      "R_Address : ${_recipientAddress.toString()}"),
                                  SizedBox(
                                    height: data.size.height * 0.02,
                                  ),
                                  Center(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))), //
                                      width: double.infinity,
                                      height: data.size.height * 0.050,
                                      //  color: Colors.black12,
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: DropdownButton<String>(
                                            underline: Container(),
                                            items: _locations.map((String val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Text(val),
                                              );
                                            }).toList(),
                                            hint: Text(_selectedLocation),
                                            onChanged: (String? val) {
                                              _selectedLocation = val!;
                                              setState(() {});
                                            }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: data.size.height * 0.02,
                                  ),
                                  TextFormField(
                                    controller: _updateController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      hintText: "Re-Mark",
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter article';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: data.size.height * 0.02,
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Update")),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });*/
                },
              ),
              const Divider(
                thickness: 3,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('LogOut'),
                onTap: () {
                  Hive.box('isUserLogin').put('isUserLoggedIn', false);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
            ],
          ),
        ),
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
                                                                SizedBox(
                                                                  height: data
                                                                          .size
                                                                          .height *
                                                                      0.04,
                                                                ),
                                                                Text(
                                                                  "$key",
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

  Text buildText(String txt) {
    return Text(
      txt,
      style: const TextStyle(fontSize: 18),
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
