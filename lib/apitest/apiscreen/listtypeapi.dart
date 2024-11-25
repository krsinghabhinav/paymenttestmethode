import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paymenttestmethode/apitest/controller/listtypeController.dart';

class Listtypeapi extends StatefulWidget {
  const Listtypeapi({super.key});

  @override
  State<Listtypeapi> createState() => _ListtypeapiState();
}

class _ListtypeapiState extends State<Listtypeapi> {
  Listtypecontroller listtypecontroller = Get.put(Listtypecontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Type'),
      ),
      body: Obx(() {
        final listData = listtypecontroller.listtype.value;
        if (listtypecontroller.listtype.value.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: listData.length,
          itemBuilder: ((context, index) {
            final data = listData[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  child: Card(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name.toString()),
                      Text(data.address!.street.toString()),
                      Text(data.company!.catchPhrase.toString()),
                    ],
                  )),
                ),
              ],
            );
          }),
        );
      }),
    );
  }
}
