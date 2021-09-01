import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:sahaayak_app/constants.dart';

class BookServices extends StatefulWidget {
  const BookServices({Key? key}) : super(key: key);

  @override
  _BookServicesState createState() => _BookServicesState();
}

class _BookServicesState extends State<BookServices> {
  final _formKey = GlobalKey<FormState>();
  static String? cityDropDownVal;
  static int? _payPrice = _servicePrice[_serviceNameList[0]];
  static int _payDays = 1;
  static late int selectedRadioTile = 1;
  static int _currentMonth = DateTime.now().month;
  static int _currentYear = DateTime.now().year;
  static int _currentDay = DateTime.now().day;

  findLastDate() {
    return DateTime(_currentYear, _currentMonth == 12 ? 1 : _currentMonth, 0)
        .day;
  }

  findStartDate() {
    if (_currentDay + 1 >
        DateTime(_currentYear, _currentMonth == 12 ? 1 : _currentMonth, 0).day)
      return 1;
    else
      return _currentDay + 1;
  }

  static Map<String, bool> _serviceList = {
    "Standard Cleaning": true,
    "Premium Cleaning": false,
    "Elderly Care": false,
    "Child Care": false,
    "Cooking": false
  };

  static final Map<String, int> _servicePrice = {
    "Standard Cleaning": 30,
    "Premium Cleaning": 55,
    "Elderly Care": 1000,
    "Child Care": 100,
    "Cooking": 80
  };

  static List<String> _serviceNameList = [
    "Standard Cleaning",
    "Premium Cleaning",
    "Elderly Care",
    "Child Care",
    "Cooking"
  ];

  late DateTimeRange _date = DateTimeRange(
    start: DateTime(_currentYear, _currentMonth, findStartDate()),
    end: DateTime(
        _currentYear, _currentMonth == 12 ? 1 : _currentMonth + 1, _currentDay),
  );

  late TimeOfDay _time = TimeOfDay(
      hour: TimeOfDay.now().hour == 12 ? 01 : TimeOfDay.now().hour + 1,
      minute: TimeOfDay.now().minute >= 59 ? 00 : TimeOfDay.now().minute + 1);

  customDivider() {
    return Divider(
      thickness: .5,
      color: HexColor("#01274a"),
    );
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
      priceCalcLogic();
    });
  }

  priceCalcLogic() async {
    dynamic tempPrice=0;
    _serviceList.forEach((key, value) {
      if (value) tempPrice+=_servicePrice[key];
    });
    _payPrice = tempPrice*_payDays;
  }

  setSelectedCheckboxTile(bool val, String s) {
    setState(() {
      _serviceList.update(s, (value) => !_serviceList[s]!);
      priceCalcLogic();
    });
  }

  void _selectDate() async {
    final DateTimeRange? newDate = await showDateRangePicker(

      context: context,
      initialDateRange: _date,
      firstDate: DateTime(_currentYear, _currentMonth, findStartDate()),
      lastDate: DateTime(_currentYear,
          _currentMonth == 12 ? 1 : _currentMonth + 1, _currentDay),
      helpText: 'Select days to hire Sahaayak',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: HexColor("#01274a"),
            colorScheme: ColorScheme.light(
              primary: HexColor("#01274a"),// body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (newDate != null) {
      DateTimeRange tdr = newDate;
      setState(() {
        _payDays = tdr.duration.inDays + 1;
        _date = newDate;
        priceCalcLogic();
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: HexColor("#01274a"),

            colorScheme: ColorScheme.light(
              primary: HexColor("#01274a"),
              secondary: Colors.white// body text color
            ),
          ),
          child: child!,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        priceCalcLogic();
      });
    }
  }

  setPersistentCheck() {
    setState(() {
      _serviceList.update("Standard Cleaning", (value) => true);
      priceCalcLogic();
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#01274a"),
        centerTitle: true,
        title: Text('Book Services'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 320,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  customDivider(),
                  Text(
                    "Location and Gender",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: kFontFamily1,
                    ),
                  ),
                  customDivider(),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.blueGrey,
                        size: 30.0,
                      ),
                      Expanded(
                        child: Container(
                          child: RadioListTile(
                            value: 1,
                            groupValue: selectedRadioTile,
                            title: Text("Male"),
                            onChanged: (dynamic val) {
                              setSelectedRadioTile(val);
                            },
                            activeColor: HexColor("#01274a"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: RadioListTile(
                            value: 2,
                            groupValue: selectedRadioTile,
                            title: Text("Female"),
                            onChanged: (dynamic val) {
                              setSelectedRadioTile(val);
                            },
                            activeColor: HexColor("#01274a"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  DropdownButtonFormField(
                    value: cityDropDownVal,
                    elevation: 10,
                    onChanged: (newValue) {
                      setState(() {
                        cityDropDownVal = newValue.toString();
                        priceCalcLogic();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'City',
                      icon: Icon(
                        Icons.location_city,
                        color: Colors.blueGrey,
                      ),
                    ),
                    items: <String>[
                      'Dummy',
                      'Dumy',
                      'Dumfgmy',
                      'Duggmmy',
                      'Dumxvcvmy',
                      'Dummyyyyyyyyyyyyyyyyy',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  customDivider(),
                  Text(
                    "Services",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: kFontFamily1,
                    ),
                  ),
                  customDivider(),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary: Tooltip(
                      waitDuration: Duration(milliseconds: 20),
                      showDuration: Duration(seconds: 5),
                      message:
                          'This package includes house floor cleaning, dish & clothes washing',
                      child: Icon(
                        Icons.info,
                        size: 30.0,
                        color: HexColor("#01274a"),
                      ),
                    ),
                    value: _serviceList[_serviceNameList[0]]! ||
                            _serviceList[_serviceNameList[1]]! ||
                            _serviceList[_serviceNameList[2]]! ||
                            _serviceList[_serviceNameList[3]]! ||
                            _serviceList[_serviceNameList[4]]!
                        ? _serviceList[_serviceNameList[0]]
                        : setPersistentCheck(),
                    title: Text(_serviceNameList[0]),
                    subtitle: Text("\u{20B9}" +
                        _servicePrice[_serviceNameList[0]].toString() +
                        " per day"),
                    onChanged: (dynamic val) {
                      setSelectedCheckboxTile(val, _serviceNameList[0]);
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _serviceList[_serviceNameList[1]],
                    subtitle: Text("\u{20B9}" +
                        _servicePrice[_serviceNameList[1]].toString() +
                        " per day"),
                    secondary: Tooltip(
                      waitDuration: Duration(milliseconds: 20),
                      showDuration: Duration(seconds: 5),
                      message:
                          'This package contains premium cleaning services, lavatory, fan & furniture cleaning',
                      child: Icon(
                        Icons.info,
                        size: 30.0,
                        color: HexColor("#01274a"),
                      ),
                    ),
                    title: Text(_serviceNameList[1]),
                    onChanged: (dynamic val) {
                      setSelectedCheckboxTile(val, _serviceNameList[1]);
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _serviceList[_serviceNameList[2]],
                    subtitle: Text("\u{20B9}" +
                        _servicePrice[_serviceNameList[2]].toString() +
                        " per day"),
                    title: Text(_serviceNameList[2]),
                    onChanged: (dynamic val) {
                      setSelectedCheckboxTile(val, _serviceNameList[2]);
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _serviceList[_serviceNameList[3]],
                    title: Text(_serviceNameList[3]),
                    subtitle: Text("\u{20B9}" +
                        _servicePrice[_serviceNameList[3]].toString() +
                        " per day"),
                    onChanged: (dynamic val) {
                      setSelectedCheckboxTile(val, _serviceNameList[3]);
                    },
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _serviceList[_serviceNameList[4]],
                    subtitle: Text("\u{20B9}" +
                        _servicePrice[_serviceNameList[4]].toString() +
                        " per day"),
                    title: Text(_serviceNameList[4]),
                    onChanged: (dynamic val) {
                      setSelectedCheckboxTile(val, _serviceNameList[4]);
                    },
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  customDivider(),
                  Text(
                    "Date and Time",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: kFontFamily1,
                    ),
                  ),
                  customDivider(),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.blueGrey,
                        size: 23.0,
                      ),
                      Expanded(
                        child: Text(
                          _payDays == 1
                              ? " Needed for 1 Day"
                              : _payDays > 1
                                  ? "Needed for $_payDays Days"
                                  : " Select Days",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: kFontFamily1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  HexColor("#01274a")),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(
                                    color: HexColor("#01274a"),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              _selectDate();
                            },
                            child: const Text('Select Date'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Colors.blueGrey,
                        size: 23.0,
                      ),
                      Expanded(
                        child: Text(
                          "Time ${_time.format(context)}",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: kFontFamily1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  HexColor("#01274a")),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: BorderSide(
                                    color: HexColor("#01274a"),
                                  ),
                                ),
                              ),
                            ),
                            onPressed: () {
                              _selectTime();
                            },
                            child: const Text('Select Time'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  Text(
                    "Total : ${_payPrice == null ? 'Calculating' : NumberFormat.simpleCurrency(name: 'INR',decimalDigits: 0).format(_payPrice)}",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontFamily: kFontFamily1,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightForFinite(
                            height: 40.0, width: double.maxFinite),
                        child: ElevatedButton(
                            child: Text("Search".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20.0, fontFamily: kFontFamily1)),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  HexColor("#01274a")),
                            ),
                            onPressed: () => null),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}