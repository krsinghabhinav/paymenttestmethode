import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/objecttypeApi.dart';

class ObjectScreen extends StatefulWidget {
  const ObjectScreen({super.key});

  @override
  State<ObjectScreen> createState() => _ObjectScreenState();
}

class _ObjectScreenState extends State<ObjectScreen> {
  final ObjecttypeapiController controller = Get.put(ObjecttypeapiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Object API Data"),
        ),
        body: Obx(() {
          if (controller.objecttype.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final datalist = controller.objecttype.value!.data;
          if (datalist == null || datalist.isEmpty) {
            return const Center(child: Text("No Data"));
          }
          return ListView.builder(
              itemCount: datalist.length,
              itemBuilder: (context, index) {
                final dataitem = datalist[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: dataitem.color != null
                          ? Color(int.parse(dataitem.color!.substring(1, 7),
                                  radix: 16) +
                              0xFF000000)
                          : Colors.grey,
                    ),
                    title: Text(dataitem.name.toString()),
                    subtitle: Text(dataitem.pantoneValue.toString()),
                    trailing: Text(dataitem.year.toString()),
                  ),
                );
              });
        }));
  }
}
