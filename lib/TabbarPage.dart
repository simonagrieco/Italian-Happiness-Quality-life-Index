import 'package:floating_tabbar/Models/tab_item.dart';
import 'package:floating_tabbar/Widgets/top_tabbar.dart';
import 'package:floating_tabbar/floating_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ItalyMapPage.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({Key? key}) : super(key: key);

  @override
  State<Tabbar> createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {

  /*List<TabItem> topTabbarTabItemlist({required Brightness brightness}) {
    List<TabItem> topTabbarTabItemlist = [
      TabItem(
        onTap: () {},
        title: const Text("Formato mappa"),
        tab: const Center(child: Text("Nautics SideBar", style: TextStyle(fontSize: 30))),
      ),
      TabItem(
        onTap: () {},
        title: const Text("Formato dati"),
        tab: const Center(child: Text("Public Events", style: TextStyle(fontSize: 30))),
      ),
    ];
    return topTabbarTabItemlist;
  } */

  @override
  Widget floatingTabBarPageView({required Brightness brightness}) {
    List<TabItem> tabList() {
      List<TabItem> _list = [
        TabItem(
          onTap: () {},
          selectedLeadingIcon: const Icon(Icons.map_rounded),
          title: const Text("Dashboard"),
          //tab: TopTabbar(tabList: topTabbarTabItemlist(brightness: brightness)),
          tab: ItalyMapPage(),
          showBadge: true,
          badgeCount: 10,
        ),
        TabItem(
          onTap: () {},
          selectedLeadingIcon: const Icon(Icons.table_view),
          title: const Text("Data"),
          tab: const Center(child: Text("Data", style: TextStyle(fontSize: 30))),
        ),
        TabItem(
          onTap: () {},
          selectedLeadingIcon: const Icon(Icons.library_books),
          title: const Text("Report"),
          tab: const Center(child: Text("Report", style: TextStyle(fontSize: 30))),
        ),
        TabItem(
          onTap: () {},
          selectedLeadingIcon: const Icon(Icons.settings),
          title: const Text("Settings"),
          tab: const Center(child: Text("Settings", style: TextStyle(fontSize: 30))),
        ),
      ];
      return _list;
    }

    return FloatingTabBar(
      children: tabList(),
      useNautics: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return floatingTabBarPageView(brightness: brightness);
  }

}
