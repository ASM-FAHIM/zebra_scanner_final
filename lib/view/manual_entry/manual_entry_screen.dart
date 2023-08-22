import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zebra_scanner_final/constants/const_colors.dart';
import 'package:zebra_scanner_final/controller/login_controller.dart';
import 'package:zebra_scanner_final/controller/manual_entry_controller.dart';
import 'package:zebra_scanner_final/controller/offline_controller.dart';
import 'package:zebra_scanner_final/controller/online_controller.dart';
import 'package:zebra_scanner_final/widgets/appBar_widget.dart';
import 'package:get/get.dart';
import '../../widgets/reusable_alert.dart';

class ManualEntry extends StatefulWidget {
  final String? mode;
  final String? tagNum;
  final String? storeId;
  const ManualEntry({
    this.mode,
    this.tagNum,
    this.storeId,
    Key? key,
  }) : super(key: key);

  @override
  State<ManualEntry> createState() => _ManualEntryState();
}

class _ManualEntryState extends State<ManualEntry> {
  LoginController login = Get.find<LoginController>();
  ManualController manual = Get.put(ManualController());
  OnlineController online = Get.put(OnlineController());
  OfflineController offline = Get.put(OfflineController());

  //controlling the scanner button
  Future<void> initScanner() async {
    FlutterDataWedge.initScanner(
        profileName: 'FlutterDataWedge',
        onScan: (result) async {
          manual.lastCode.value = result.data;
          manual.productCode.text = manual.lastCode.value;
          print('Product code: ${manual.productCode.text}');
        },
        onStatusUpdate: (result) {
          ScannerStatusType status = result.status;
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    initScanner();
    super.initState();
    if(widget.mode == 'Online'){
      manual.getManualAddedProduct(widget.tagNum.toString(), login.userId.value);
    }else{

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () async{
              if(widget.mode == 'Online'){
                Get.back();
                await online.productList(online.tagNumber.value, login.serverIp.value, online.storeID.value);
              }else{
                Get.back();
                await offline.getScannerTable();
              }
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Manual Scan",
            style: GoogleFonts.urbanist(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Obx((){
        return manual.entryDone.value
            ? Container()
            : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: double.maxFinite,
                padding:
                const EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(
                    left: 10, top: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: manual.isEmptyField.value ==
                        true
                        ? Colors.red
                        : Colors.grey,
                    width:
                    manual.isEmptyField.value ==
                        true
                        ? 2.0
                        : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: TextFormField(
                  controller: manual.productCode,
                  inputFormatters: [
                    //FilteringTextInputFormatter.deny(RegExp(r'^0')),
                    FilteringTextInputFormatter.deny(
                        RegExp(r'-')),
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\.')),
                    FilteringTextInputFormatter.deny(
                        RegExp(r',')),
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\+')),
                    FilteringTextInputFormatter.deny(
                        RegExp(r'\*')),
                    FilteringTextInputFormatter.deny(
                        RegExp(r'/')),
                    FilteringTextInputFormatter.deny(
                        RegExp(r'=')),
                    FilteringTextInputFormatter.deny(
                        RegExp(r'%')),
                    FilteringTextInputFormatter.deny(
                        RegExp(r' ')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter product code',
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                height: 50,
                width: double.maxFinite,
                padding:
                const EdgeInsets.only(left: 10, right: 10),
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(
                    left: 10, top: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: manual.isEmptyField.value ==
                        true
                        ? Colors.red
                        : Colors.grey,
                    width:
                    manual.isEmptyField.value ==
                        true
                        ? 2.0
                        : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: TextFormField(
                  controller: manual.qtyController,
                  inputFormatters: [
                    //FilteringTextInputFormatter.deny(RegExp(r'^0')),
                    FilteringTextInputFormatter.deny(RegExp(r'-')),
                    FilteringTextInputFormatter.deny(RegExp(r',')),
                    FilteringTextInputFormatter.deny(RegExp(r'\+')),
                    FilteringTextInputFormatter.deny(RegExp(r'\*')),
                    FilteringTextInputFormatter.deny(RegExp(r'/')),
                    FilteringTextInputFormatter.deny(RegExp(r'=')),
                    FilteringTextInputFormatter.deny(RegExp(r'%')),
                    FilteringTextInputFormatter.deny(RegExp(r' ')),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter quantity',
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                height: 50,
                width: 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0)),
                clipBehavior: Clip.hardEdge,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: ConstantColors.uniGreen,
                    ),
                    onPressed: () {
                      if(manual.productCode.text.length == 5 || manual.productCode.text.length == 7){
                        if(widget.mode == 'Online'){
                          //online logic
                          manual.addItemManually(
                            context,
                            login.serverIp.value,
                            login.deviceID.value,
                            login.userId.value,
                            widget.tagNum.toString(),
                            widget.storeId.toString(),
                          );
                        }else{
                          manual.addManuallyOffline(context);
                        }
                      }else{
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => ReusableAlerDialogue(
                            headTitle: "Warning!",
                            message: "Invalid code",
                            btnText: "OK",
                          ),
                        );
                      }
                    },
                    child:  const Text('Submit', style: TextStyle(fontSize: 16),)
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text('Last added product', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              if(widget.mode == 'Online')...[
                if(manual.manualAddedProduct == null)...[
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.blueGrey,
                    child: Container(
                      height: 100,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Center(
                        child: Text('No product added yet'),
                      ),
                    ),
                  ),
                ]else...[
                  _manualAddedProduct(
                    title: manual.manualAddedProduct!.itemDesc,
                    subTitle: manual.manualAddedProduct!.itemCode,
                    quantity: manual.manualAddedProduct!.scanQty.toString(),
                  )
                ]
              ]else...[
                if(manual.manualAddedProduct == null)...[
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.blueGrey,
                    child: Container(
                      height: 100,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Center(
                        child: Text('No product added yet'),
                      ),
                    ),
                  ),
                ]else...[]
              ]
            ],
          ),
        );
      })
    );
  }

  Widget _manualAddedProduct({
  required String title,
  required String subTitle,
  required String quantity,
  }){
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)),
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.blueGrey,
      child: Container(
        height: 100,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              subTitle,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Total quantity : $quantity',
              style: GoogleFonts.urbanist(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
