import 'package:flutter/material.dart';

class MaterialHomePage extends StatefulWidget {
   const MaterialHomePage({super.key});

  @override
  State<MaterialHomePage> createState() => _MaterialHomePage();
}

class _MaterialHomePage extends State<MaterialHomePage> {
  double result = 0.0;

  final TextEditingController textEditingController = TextEditingController();

  void convert() {
    result = double.parse(textEditingController.text) * 284.50;
    setState(() {});
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose(); // in dispose, it should be the last line
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(
        5
      ),
    );


    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: const Text(
          'Currency Convertor', 
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PKR ${result != 0 ? result.toStringAsFixed(2) : result.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              TextField(
                controller: textEditingController,
                style: const TextStyle(
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  hintText: 'Please enter your amount in USD',
                  hintStyle: const TextStyle(
                    color: Colors.black
                  ),
                  prefixIcon: const Icon(
                    Icons.monetization_on_outlined
                  ),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: convert,

                style: TextButton.styleFrom(
                  backgroundColor:  Colors.black,
                  foregroundColor: Colors.white, 
                  minimumSize: const Size(
                    double.infinity, 50
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(
                        5.0
                      ),
                    ),
                ),
                child: const Text(
                  'Convert',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// in the following we cannot change the state(value) of our variable
/*
class MaterialHomePagee extends StatelessWidget {
  const MaterialHomePagee({super.key});
  @override
  Widget build(BuildContext context) {
    
    final border = OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.0,
        style: BorderStyle.solid,
      ),
      borderRadius: BorderRadius.circular(
        5
      ),
    );

    double result = 0.0;

    final TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        title: const Text(
          'Currency Convertor', 
          style: TextStyle(
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result.toString(),
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  hintText: 'Please enter your amount in USD',
                  hintStyle: const TextStyle(
                    color: Colors.black
                  ),
                  prefixIcon: const Icon(
                    Icons.monetization_on_outlined
                  ),
                  prefixIconColor: Colors.black,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  result = double.parse(textEditingController.text) * 284.50;
                }, 
                style: TextButton.styleFrom(
                  backgroundColor:  Colors.black,
                  foregroundColor: Colors.white, 
                  minimumSize: const Size(
                    double.infinity, 50
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(
                        5.0
                      ),
                    ),
                ),
                child: const Text(
                  'Convert',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/