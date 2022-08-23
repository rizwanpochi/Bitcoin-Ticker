import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  //12. Create a variable to hold the value and use in our Text Widget. Give the variable a starting value of '?' before the data comes back from the async methods.
  String bitcoinValue = '?';
  // ignore: non_constant_identifier_names
  String ETHValue = '?';
  // ignore: non_constant_identifier_names
  String LTCValue = '?';
  // ignore: non_constant_identifier_names
  String BTC = 'BTC';
  // ignore: non_constant_identifier_names
  String ETH = 'ETH';
  // ignore: non_constant_identifier_names
  String LTC = 'LTC';

  //11. Create an async method here await the coin data from coin_data.dart
  void getData(String selCurrency) async {
    try {
      CoinData coinData = CoinData();
      double bitcoinData = await coinData.getCoinData(selCurrency, BTC);
      double ETHData = await coinData.getCoinData(selCurrency, ETH);
      double LTCData = await coinData.getCoinData(selCurrency, LTC);
      //13. We can't await in a setState(). So you have to separate it out into two steps.
      setState(() {
        bitcoinValue = bitcoinData.toStringAsFixed(0);
        ETHValue = ETHData.toStringAsFixed(0);
        LTCValue = LTCData.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //14. Call getData() when the screen loads up. We can't call CoinData().getCoinData() directly here because we can't make initState() async.
    getData(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildPadding(BTC, bitcoinValue, selectedCurrency),
          buildPadding(ETH, ETHValue, selectedCurrency),
          buildPadding(LTC, LTCValue, selectedCurrency),
          SizedBox(height: 250),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }

  Padding buildPadding(String coinName, String coinType, String currency) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            //15. Update the Text Widget with the data in bitcoinValueInUSD.
            '1 $coinName = $coinType $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
