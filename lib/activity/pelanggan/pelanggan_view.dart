import 'package:flutter/material.dart';
import 'package:mizanmobile/activity/pelanggan/pelanggan_controller.dart';
import 'package:mizanmobile/helper/utils.dart';

class PelangganView extends StatefulWidget {
  const PelangganView({Key? key}) : super(key: key);

  @override
  State<PelangganView> createState() => _PelangganViewState();
}

class _PelangganViewState extends State<PelangganView> {
  late PelangganController ctrl;

  @override
  void initState() {
    ctrl = PelangganController(context, setState);
    ctrl.dataPelanggan = ctrl.getData();
    super.initState();
  }

  Icon customIcon = Icon(Icons.search);
  Widget customSearchBar = Text("Daftar Pelanggan");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Utils.widgetSetter(() {
        if (Utils.hakAkses["MOBILE_EDITDATAMASTER"] == 0) {
          return Container();
        }
        return FloatingActionButton(
            child: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () => ctrl.showModalInputPelanggan());
      }),
      appBar: AppBar(
        title: customSearchBar,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (customIcon.icon == Icons.search) {
                    customIcon = Icon(Icons.clear);
                    customSearchBar = Utils.appBarSearch((keyword) {
                      setState(() {
                        ctrl.dataPelanggan = ctrl.getData(keyword: keyword);
                      });
                    }, hint: "Cari");
                  } else {
                    customIcon = Icon(Icons.search);
                    customSearchBar = Text("Daftar Pelanggan");
                  }
                });
              },
              icon: customIcon)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.sync(() {
            setState(() {
              customIcon = Icon(Icons.search);
              customSearchBar = Text("Daftar Pelanggan");
              ctrl.dataPelanggan = ctrl.getData();
            });
          });
        },
        child: Container(
          child: FutureBuilder<List<dynamic>>(
            future: ctrl.dataPelanggan,
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext contex, int index) {
                      dynamic dataList = snapshot.data![index];
                      return Container(
                        child: Card(
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext content) {
                                    return Container(
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      height: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () => ctrl.editData(dataList),
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.black54,
                                                  )),
                                              Text("Edit")
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                  onPressed: () => ctrl.deleteData(dataList),
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.black54,
                                                  )),
                                              Text("Delete")
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.bagde(
                                    dataList["NAMA"].toString().substring(0, 1),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Utils.labelSetter(dataList["NAMA"].toString(),
                                              bold: true),
                                          Utils.labelSetter(dataList["KODE"].toString()),
                                          Utils.labelValueSetter(
                                            "GOL 1",
                                            dataList["NAMA_GOLONGAN"].toString(),
                                          ),
                                          Utils.labelValueSetter(
                                            "GOL 2",
                                            dataList["NAMA_GOLONGAN2"].toString(),
                                          ),
                                          Utils.labelValueSetter(
                                            "Klasifikasi",
                                            dataList["NAMA_KLASIFIKASI"].toString(),
                                          ),
                                          Utils.labelValueSetter(
                                            "Department",
                                            dataList["NAMA_DEPT"].toString(),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            }),
          ),
        ),
      ),
    );
  }
}
