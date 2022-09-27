import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:post_app/Controller/Export/export_screen.dart';

class UpdateScreen extends StatefulWidget {
  late String? s;
  late String? add;
  late String? rn;
  late String? rd;
  late String? bookingId;
  UpdateScreen({
    String? s,
    String? add,
    String? rn,
    String? rd,
    String? bookingId,
  }) {
    this.s = s;
    this.add = add;
    this.rn = rn;
    this.rd = rd;
    this.bookingId = bookingId;
  }

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

//Controller
final _formKey = GlobalKey<FormState>();
final TextEditingController _updateController = TextEditingController();
final TextEditingController _commentController = TextEditingController();
String _selectedLocation = "Status";
String _selectedSub = "Select Your SubStatus";

var _update = "";

Future<void> fetchUserData({
  required String bookingProcessId,
  required String articleTrackingNo,
  required String transitStateId,
  required String description,
}) async {
  final Response response = await http.post(
    Uri.parse('http://58.65.169.108:999/MobileAPP/AddArticleUpdate'),
    body: {
      "Booking_Process_Id": bookingProcessId.toString(),
      "Article_Tracking_No": articleTrackingNo,
      "Transit_State": transitStateId,
      "Description": description.toString(),
    },
    /* {
        "Booking_Process_Id": "113970014411953",
        "Article_Tracking_No": "UMS60318373",
        "Transit_State": "Delivered",
        "Description": "Adnan"
      }*/
  );
  if (response.statusCode == 200) {
    var data = response.body.toString();
    _update = jsonDecode(data).toString();
    Hive.box('BookingProcessID').put("data", _update).toString();
    print(Hive.box('BookingProcessID').put("data", _update));
    print("ok");
  } else {
    print("No data");
  }
}

class _UpdateScreenState extends State<UpdateScreen> {
  String SelectedCurrentValue = "Change Status";
  String value = "";
  List<DropdownMenuItem<String>> menuitems = [];
  bool disabledropdown = true;

  double opacit = 0.0;

  final delivered = {
    "1": "Others",
  };
  final unDelivered = {
    "1": "Address not found",
    "2": "Bank Closed",
    "3": "Bank Time Out",
    "4": "Deposit",
    "5": "Office Closed",
    "6": "Office Time Out",
    "7": "Receipient Not at Bank",
    "8": "Receipient Not at Home",
    "9": "Receipient Not at Office",
    "10": "Receipient Not at Shop",
    "11": "Redirect",
    "12": "Shop Closed",
    "13": "Others",
  };
  final returned = {
    "1": "Address Changed",
    "2": "Address not found",
    "3": "Refused To Received",
    "4": "Incomplete Address",
    "5": "Addressee not found",
    "6": "Wrong Address",
    "7": "Others",
  };
  final missSent = {
    "1": "MisSent",
    "2": "Others",
  };

  void populateDelivered() {
    for (String key in delivered.keys) {
      menuitems.add(DropdownMenuItem<String>(
        value: delivered[key],
        child: Center(
          child: Text(delivered[key].toString()),
        ),
      ));
    }
  }

  void populateUnDelivered() {
    for (String key in unDelivered.keys) {
      menuitems.add(DropdownMenuItem<String>(
        value: unDelivered[key],
        child: Center(
          child: Text(unDelivered[key].toString()),
        ),
      ));
    }
  }

  void populateReturned() {
    for (String key in returned.keys) {
      menuitems.add(DropdownMenuItem<String>(
        value: returned[key],
        child: Center(
          child: Text(returned[key].toString()),
        ),
      ));
    }
  }

  void populateMissSent() {
    for (String key in missSent.keys) {
      menuitems.add(DropdownMenuItem<String>(
        value: missSent[key],
        child: Center(
          child: Text(missSent[key].toString()),
        ),
      ));
    }
  }

  void selected(_value) {
    if (_value == "Delivered") {
      menuitems = [];
      populateDelivered();
    } else if (_value == "UnDelivered") {
      menuitems = [];
      populateUnDelivered();
    } else if (_value == "Returned") {
      menuitems = [];
      populateReturned();
    } else if (_value == "MissSent") {
      menuitems = [];
      populateMissSent();
    } else {}
    setState(() {
      _selectedLocation = _value;
      disabledropdown = false;
    });
  }

  void secondselected(_value) {
    setState(() {
      _selectedSub = _value;
      if (_value == "Others") {
        opacit = 1.0;
      } else {
        opacit = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                children: [
                  SizedBox(
                    height: data.size.height * 0.04,
                  ),
                  TextFormField(
                    controller: _updateController,
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
                  SizedBox(
                    height: data.size.height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: data.size.height * 0.05,
                          width: data.size.width * 0.30,
                          decoration: BoxDecoration(
                              color: AppColors.kButton,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Search",
                              style: TextStyle(
                                  fontSize: 17, color: AppColors.kWhite),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: data.size.height * 0.04,
                  ),
                  SizedBox(
                    height: data.size.height * 0.22,
                    width: data.size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildText("Sender : "),
                        SizedBox(
                          height: data.size.height * 0.02,
                        ),
                        buildText("S_Address : "),
                        SizedBox(
                          height: data.size.height * 0.02,
                        ),
                        buildText("Recipient : ${widget.rn ?? "Update"}"),
                        SizedBox(
                          height: data.size.height * 0.02,
                        ),
                        buildText("R_Address : ${widget.rd ?? "Update"}"),
                      ],
                    ),
                  ),
                  DropdownButton<String>(
                    items: const [
                      DropdownMenuItem<String>(
                        value: "Delivered",
                        child: Center(
                          child: Text("Delivered"),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "UnDelivered",
                        child: Center(
                          child: Text("UnDelivered"),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "Returned",
                        child: Center(
                          child: Text("Returned"),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "MissSent",
                        child: Center(
                          child: Text("MissSent"),
                        ),
                      ),
                    ],
                    onChanged: (_value) {
                      selected(_value);
                    },
                    hint: Text(_selectedLocation),
                  ),
                  DropdownButton<String>(
                    items: menuitems,
                    onChanged: disabledropdown
                        ? null
                        : (_value) => secondselected(_value),
                    hint: Text(_selectedSub),
                    disabledHint: const Text("First Select Your Field"),
                  ),
                  Opacity(
                    opacity: opacit,
                    child: TextFormField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: AppColors.kButton),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: "Write Something... ",
                      ),
                    ),
                  ),
                  SizedBox(
                    height: data.size.height * 0.04,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            fetchUserData(
                              articleTrackingNo: _updateController.text,
                              bookingProcessId:
                                  Hive.box('BookingProcessID').get("data") ??
                                      widget.bookingId.toString(),
                              description: _selectedSub.toString(),
                              transitStateId: _selectedLocation,
                            );
                            Navigator.of(context).pop();
                            _updateController.clear();
                            _commentController.clear();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const AlertDialog(
                                    title: Text("Update"),
                                    content: Text("Successfully Update... "),
                                  );
                                });
                          }
                        },
                        child: const Text("Update")),
                  ),
                ],
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
}
