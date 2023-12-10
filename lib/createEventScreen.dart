import 'dart:convert';

import 'package:chase_map/Event.dart';
import 'package:chase_map/dbFunction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mappls_gl/mappls_gl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class CreateEvent extends StatefulWidget {
  final SupabaseClient supabaseClient;
  final W3MService w3mService;
  //final LatLng latLng;

  const CreateEvent(
      {Key? key,
      required this.supabaseClient,
      required this.w3mService,
      //required this.latLng
      })
      : super(key: key);

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController field1Controller = TextEditingController();
  TextEditingController field2Controller = TextEditingController();
  TextEditingController field3Controller = TextEditingController();
  TextEditingController field4Controller = TextEditingController();
  bool switchValue = true;
  late Client httpClient;

  late Web3Client ethClient;

//Ethereum address
  late String myAddress = "";

  final String blockchainUrl =
      "https://polygon-mumbai.g.alchemy.com/v2/flqN2RhogTAiTZImj7_utEG3UMX8Hnxz";

  @override
  void initState() {
    setState(() {
      myAddress = widget.w3mService.address!;
      httpClient = Client();
      ethClient = Web3Client(blockchainUrl, httpClient);
    });
    ethClient
        .getBalance(EthereumAddress.fromHex(myAddress))
        .then((value) => print("eth $value"));
    // print("eth ${ethClient.getBalance(EthereumAddress.fromHex(myAddress)).}");

    callFunction("createChaser");

    // initContract();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Heading Text',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Subheading Text',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextFieldWithLabel(
                controller: field1Controller,
                label: 'Name of your event',
                hint: 'Event name'),
            TextFieldWithLabel(
                controller: field2Controller,
                label: 'Location Drop',
                hint: 'Latitude-Longitude'),
            TextFieldWithLabel(
                controller: field3Controller,
                label: 'Token Amounts',
                hint: 'Token amount'),
            TextFieldWithLabel(
                controller: field4Controller,
                label: 'Number of Collecties',
                hint: 'Number of people which can claim'),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Some Text'),
                const SizedBox(width: 8),
                Switch(
                  value: switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                createEventInDb();
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void createEventInDb() async {
    // Access the entered values using the controller.text
    String fieldValue1 = field1Controller.text;
    String fieldValue2 = field2Controller.text;
    String fieldValue3 = field3Controller.text;
    String fieldValue4 = field4Controller.text;

    final SupabaseServiceDB supabaseServiceDB =
        SupabaseServiceDB(widget.supabaseClient);
    final EventDetails eventDetails = EventDetails(
        claimedWalletAddress: 123,
        eventId: 23,
        walletAddress: '3BoatSLRHtKNngkdXEeobR76b53LETtpyT',
        latitude: 13.0564,
        longitude: 14.0892,
        timeDeadline: 24,
        members: 5,
        eventName: 'Atul Ka event',
        tokenValue: 4.056);
    await supabaseServiceDB.postEvent(eventDetails);
  }

  Future<DeployedContract> getContract() async {
    String abiChaseFactory =
        await rootBundle.loadString("assets/smartContract/ChaseFactory.json");
    final jsonAbi = jsonDecode(abiChaseFactory);
    String abiCode = jsonEncode(jsonAbi['abi']);
    String contractAddress = "0xd8F16a1f6878134dDE6879df196CeCC469B4086a";

    DeployedContract contract = DeployedContract(
      ContractAbi.fromJson(abiCode, "ChaseFactory"),
      EthereumAddress.fromHex(contractAddress),
    );
    print("contract $contract");

    return contract;
  }

  Future<void> callFunction(String name) async {
    final contract = await getContract();
    print("abc contract ${contract.functions.first.name}");
    for (ContractFunction i in contract.functions) {
      print('func name ${i.name}');
    }

    final function = contract.function(name);

    final transaction = await Transaction(
      from: EthereumAddress.fromHex(widget.w3mService.address!),
      to: contract.address,
      value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 5),
      data: function.encodeCall([BigInt.from(5)]),
    );

    //print("func name ${function.name}");
    // final result = await ethClient.sendTransaction(
    //     ethClient.,
    //     Transaction.callContract(
    //         contract: _contract!,
    //         function: _setMessage!,
    //         parameters: [message]));
    ethClient.sendRawTransaction(transaction as Uint8List);
    final result = widget.w3mService.launchConnectedWallet().hashCode;
    print("Transaction hash: ${result}");
    // final result = await ethClient
    //     .call(contract: contract, function: function, params: [BigInt.from(5)]);
    print("abc 1");
    print("abc ${result}");
    // return result;
  }
}

//   Future<DeployedContract> getContract() async {
// //obtain our smart contract using rootbundle to access our json file
//     // String abiFile = await rootBundle.loadString("assets/contract.json");
//     // String abiChase =
//     //     await rootBundle.loadString("assets/smartContract/Chase.json");
//     // String abiChaseFactory =
//     //     await rootBundle.loadString("assets/smartContract/ChaseFactory.json");

//     // String contractAddress = "0xd8F16a1f6878134dDE6879df196CeCC469B4086a";
//     // late DeployedContract contract;

//     // final ContractAbi contractAbi = ContractAbi.fromJson(jsonDecode(abiChaseFactory), "ChaseFactory");

//     // contract = DeployedContract(
//     //     contractAbi,
//     //     EthereumAddress.fromHex(contractAddress));

//      try {
//     String abiChaseFactory =
//         await rootBundle.loadString("assets/smartContract/ChaseFactory.json");
//         // print("abi $abiChaseFactory");

//     String contractAddress = "0xd8F16a1f6878134dDE6879df196CeCC469B4086a";
//     Map<String, dynamic> abiJson = jsonDecode(abiChaseFactory);
//     String abiJsonString = jsonEncode(abiJson);
//      final Map<String, dynamic> abiMap = jsonDecode(abiChaseFactory);
//     final ContractAbi contractAbi = ContractAbi.fromJson(abiChaseFactory, "ChaseFactory");

//     final DeployedContract contract = DeployedContract(
//         contractAbi,
//         EthereumAddress.fromHex(contractAddress));

//     print("cont ${contract.functions.map((func) => func.name)}");
//     return contract;
//   } catch (ex) {
//     print("errrr $ex");
//     rethrow; // Re-throw the exception after printing it
//   }

//     //BigInt valueToSendInWei = BigInt.from(1000000000000000000);

//     //     final message = Message.call(to: contract.address, value: EtherAmount.inWei(valueToSendInWei), function: function, parameters: params);

//     // // Send the transaction
//     // final result = await ethClient.sendTransaction(
//     //   await ethClient.credentials,
//     //   message,
//     //   chainId: 1, // Replace with the appropriate chain ID
//     // );

//     // final transaction = contract.function('createChase').callWith(
//     //     value: EtherAmount.inWei(BigInt.from(0)),
//     //     maxGas: 6721975,
//     //     gasPrice: EtherAmount.inWei(BigInt.from(1000000000)),
//     //     parameters: [param1, param2]);
//     // print("cont ${contract.functions}");
//     // return contract;
//   }

//   Future<List<dynamic>> callFunction(String name) async {
//     print("abc contract 1");
//     try {
//       final cont = await getContract();
//       print("cont ${cont.functions.map((func) => func.name)}");
//     } catch(ex) {
//         print("errrr $ex");
//     }
//     final contract = await getContract();
//     print("abc contract $contract");

//     final function = contract.function(name);
//     final result = await ethClient
//         .call(contract: contract, function: function, params: []);
//         print("abc 1");
//         print("abc $result");
//     return result;
//   }
// }

// // class CreateEvent extends StatelessWidget {
// //   final SupabaseClient supabaseClient;
// //   final W3MService w3mService;

// //   const CreateEvent({super.key, required this.supabaseClient, required this.w3mService});
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0, // Remove shadow
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back),
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Heading Text',
// //               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               'Subheading Text',
// //               style: TextStyle(fontSize: 18, color: Colors.grey),
// //             ),
// //             SizedBox(height: 16),
// //             TextFieldWithLabel(label: 'Field 1', hint: 'Enter value'),
// //             TextFieldWithLabel(label: 'Field 2', hint: 'Enter value'),
// //             TextFieldWithLabel(label: 'Field 3', hint: 'Enter value'),
// //             TextFieldWithLabel(label: 'Field 4', hint: 'Enter value'),
// //             SizedBox(height: 16),
// //             Row(
// //               children: [
// //                 Text('Some Text'),
// //                 SizedBox(width: 8),
// //                 Switch(
// //                   value: true,
// //                   onChanged: (bool value) {
// //                     // Handle switch state change
// //                   },
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 16),
// //             ElevatedButton(
// //               onPressed: () {
// //                 createEventInDb();
// //               },
// //               child: Text('Submit'),
// //             ),
// //           ],
// //         ),
// //       ),
// //       backgroundColor: Colors.white,
// //     );
// //   }

// //   void createEventInDb() async{
// //     final SupabaseServiceDB supabaseServiceDB = SupabaseServiceDB(supabaseClient);
// //     final EventDetails eventDetails = EventDetails(claimedWalletAddress: 123, eventId: 23, walletAddress: '3BoatSLRHtKNngkdXEeobR76b53LETtpyT', latitude: 13.0564, longitude: 14.0892, timeDeadline: 24, members: 5, eventName: 'Atul Ka event', tokenValue: 4.056);
// //     await supabaseServiceDB.postEvent(eventDetails);
// //   }
// // }

class TextFieldWithLabel extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  const TextFieldWithLabel(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
