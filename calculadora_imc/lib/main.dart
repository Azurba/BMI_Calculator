import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

/*it has to be a stateful instead of stateless because the app will be dynamic 
and will modify according to the data we will put in. It will change states
*/
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
/*
TextEditingController is a class available for us to use. It is a controller
for an editable text field. More at: 
https://api.flutter.dev/flutter/widgets/TextEditingController-class.html\
*/

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  /*
  GlobalKey is a class that will check if the textField has been typed.
  We just created a "Key", now we have to use it where we want to check if it 
  has been typed or not
  https://api.flutter.dev/flutter/widgets/GlobalKey-class.html
   */
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText =
      "Please, type your Height (centimeters) and Weight (Kilograms)";

  /*
  This is the function that will be called once the AppBar's refresh button is 
  pressed. It will erase everything in the textFields
   */
  void _resetFields() {
    weightController.text = "";
    //this is the text of the textFields. This is whatever the user typed
    heightController.text = "";
    setState(() {
      /*setState is a function that notify the framework that the state has
      changed and it has to be refreshed.We have to call this because we
      want to change the infoText.
      https://api.flutter.dev/flutter/widgets/State/setState.html
      */
      _infoText = "Type your data";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      if (imc < 18.6) {
        _infoText = "Underweight (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = "Normal (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = "Slightly overweight (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "Obese - Class I (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = "Obese - Class II (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40) {
        _infoText = "Obese - Class III (${imc.toStringAsPrecision(4)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*
      Scaffold is the support for the tabs, appbar and everything
      that goes on the top of your app. So everything must go inside of it
     */
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"), //the title of the app
        centerTitle: true, //centralize the title
        backgroundColor: Colors.green, //the background color of the Text
        actions: <Widget>[
          IconButton(
            //Inside the appBar, we can add actions to it(the refresh button)
            icon: Icon(Icons.refresh),
            //Icons can be choose at:
            //https://api.flutter.dev/flutter/material/Icons-class.html
            onPressed: _resetFields, //passing the function that must be called
            // once the button is passed
          )
        ],
      ),
      backgroundColor: Colors.white,
      /*
      SingleChildScrollView allows the user to scroll the content of the app.
      Add this will avoid the app to crash due to lack of screen space.
      This is a single child, therefore it can only hold one thing, in this
      case, the column
       */
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          //Using the Key to check if the form has been typed. This has been
          //instantiated at line 33
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person_outline, size: 120.0, color: Colors.green),
              TextFormField(
                keyboardType: TextInputType.number,
                //can only accept number
                decoration: InputDecoration(
                    labelText: "Weight (kg)", //text of the field
                    labelStyle: TextStyle(color: Colors.green)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25.0),
                //style of the text
                controller: weightController,
                //specifying which controller will be used. This was
                //instantiated at line 24
                // ignore: missing_return
                validator: (value) {
                  //This function will validate the typed value. It is a
                  //paramether of the TextFormField
                  if (value.isEmpty) {
                    return "Type your weight!";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Height (cm)",
                    labelStyle: TextStyle(color: Colors.green)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25.0),
                controller: heightController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Type your height!";
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: ElevatedButton(
                    //RaisedButton is Deprecated. Used ElevatedButton instead.
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    child: Text(
                      "Calculate",
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                ),
              ),
              Text(
                _infoText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green, fontSize: 25.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
