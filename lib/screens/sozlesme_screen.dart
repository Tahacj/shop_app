import 'package:flutter/material.dart';

class SozlesmeScreen extends StatefulWidget {
  static const routeName = "/sozlesme";

  @override
  State<SozlesmeScreen> createState() => _SozlesmeScreenState();
}

class _SozlesmeScreenState extends State<SozlesmeScreen> {
  bool checkedValue = false;
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController tc = TextEditingController();
  TextEditingController adress = TextEditingController();
  TextEditingController phone1 = TextEditingController();
  TextEditingController phone2 = TextEditingController();
  RentalDates rentDate = RentalDates.hafta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sozlesme",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildContent(),
            _buildCheckBox(),
            _buildInputFieldView(fName, TextInputType.streetAddress, "Isim"),
            _buildInputFieldView(lName, TextInputType.streetAddress, "Soyisim"),
            _buildInputFieldView(
                tc, TextInputType.phone, "T.C kimlik numarasi"),
            _buildInputFieldView(adress, TextInputType.streetAddress, "Adres"),
            _buildInputFieldView(
                phone1, TextInputType.phone, "Birnci Telefon numarasi"),
            _buildInputFieldView(
                phone2, TextInputType.phone, "Ikinci Telefon numarasi"),
            _buildRentDatesDropDown(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputFieldView(
    var contronller,
    var keyboard,
    var lable,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: contronller,
        textAlign: TextAlign.center,
        keyboardType: keyboard,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          border: const OutlineInputBorder(),
          labelStyle:
              TextStyle(fontSize: 16, color: Colors.deepPurpleAccent.shade400),
          labelText: lable,
        ),
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildCheckBox() {
    return CheckboxListTile(
      title: Text("Okudum Onayliyorum"),
      value: checkedValue,
      onChanged: (newValue) {
        setState(() {
          checkedValue = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Text(
        "Sozlesme metni",
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRentDatesDropDown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            "Kiralama süresi :",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          SizedBox(width: 25),
          DropdownButton<RentalDates>(
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 15,
              elevation: 16,
              style: TextStyle(color: Colors.grey),
              underline: Container(
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
              ),
              value: rentDate,
              onChanged: (RentalDates newValue) {
                setState(() {
                  rentDate = newValue;
                });
              },
              items: RentalDates.values.map((RentalDates dates) {
                return DropdownMenuItem<RentalDates>(
                  value: dates,
                  child: Text(dates.toString().replaceFirst("RentalDates.", ""),
                      style: TextStyle(color: Colors.greenAccent.shade400)),
                );
              }).toList()),
        ],
      ),
    );
  }
}

enum RentalDates {
  hafta,
  ikiHafta,
  ay,
  ucAy,
  altiAy,
  yil,
}
