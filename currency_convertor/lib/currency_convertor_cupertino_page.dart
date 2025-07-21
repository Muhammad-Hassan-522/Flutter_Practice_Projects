import 'package:flutter/cupertino.dart';

class CurrencyConvertorCupertinoPage extends StatefulWidget {
  const CurrencyConvertorCupertinoPage({super.key});

  @override
  State<CurrencyConvertorCupertinoPage> createState() => _CurrencyConvertorCupertinoPageState();
}

class _CurrencyConvertorCupertinoPageState extends State<CurrencyConvertorCupertinoPage> {
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


    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey3,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemGrey3,
        middle: Text(
          'Currency Convertor',
        ),
      ),
      child: Center(
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
              CupertinoTextField(
                controller: textEditingController,
                style: const TextStyle(
                  color: CupertinoColors.black,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                  color: CupertinoColors.white,
                ),
                placeholder: 'Please enter your amount in USD',
                prefix: const Icon(CupertinoIcons.money_dollar),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CupertinoButton(
                onPressed: convert,
                color: CupertinoColors.black,
                child: const Text(
                  'Convert',
                  style: TextStyle(
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}