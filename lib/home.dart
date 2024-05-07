import 'package:flutter/material.dart';
import 'package:flutter_xy/config/xy_data_config.dart';
import 'package:flutter_xy/config/xy_info.dart';

import 'application.dart';

///DEMO案例-首页
class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);
  final List<UIGroupInfo> groupList = UIGroupDataConfig.getAllXY();

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    App.get().context = context;
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F9),
      appBar: AppBar(
        title: const Text("Flutter小样"),
        leading: null,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _buildBodyWidget(),
    );
  }

  Widget _buildBodyWidget() {
    if (widget.groupList.isEmpty) {
      return Container();
    }
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: SingleChildScrollView(
            child: ExpansionPanelList(
                dividerColor: Colors.red,
                animationDuration: const Duration(milliseconds: 500),
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    widget.groupList[index].isExpand = !isExpanded;
                  });
                },
                children: widget.groupList.map((group) {
                  return ExpansionPanel(
                    canTapOnHeader: true,
                    isExpanded: group.isExpand,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Text(group.groupName),
                      );
                    },
                    body: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: group.children?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              group.children?[index]?.onClick!(context);
                            },
                            child: Column(
                              children: [
                                const Divider(
                                  height: 1,
                                  indent: 0.0,
                                  color: Colors.red,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    group.children?[index]?.groupName ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                }).toList())));
  }
}
