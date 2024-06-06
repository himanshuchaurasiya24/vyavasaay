import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:vyavasaay/model/menu_items.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/background_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key,
      required this.name,
      required this.logInType,
      required this.centerName});
  final String name;
  final String logInType;
  final String centerName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final adminMenuItems = MenuItems().adminMenuItems;
  final userMenuItems = MenuItems().usersMenuItems;
  int currentIndex = 0;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            widget.centerName,
            style: patientHeader,
          ),
          Expanded(
            child: Row(
              children: [
                background(
                  child: Column(
                    children: [
                      widget.logInType == 'Admin'
                          ? const Center(
                              child: Icon(
                                Icons.admin_panel_settings_outlined,
                                size: 200,
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.person_outlined,
                                size: 200,
                              ),
                            ),
                      Text(
                        widget.logInType == 'Admin'
                            ? '${widget.name}\n(Admin)'
                            : '${widget.name}\n(Technician)',
                        style: TextStyle(
                          fontSize: defaultSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Gap(defaultSize),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            isSelected = currentIndex == index;
                            return Container(
                              margin: EdgeInsets.only(
                                top: index == 0 ? 2 : 0,
                                bottom: 4,
                                left: 3,
                                right: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? btnColor : primaryColorDark,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                                leading: Icon(
                                  widget.logInType == 'Admin'
                                      ? adminMenuItems[index].icon
                                      : userMenuItems[index].icon,
                                ),
                                title: Text(
                                  widget.logInType == 'Admin'
                                      ? adminMenuItems[index].title
                                      : userMenuItems[index].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: widget.logInType == 'Admin'
                              ? adminMenuItems.length
                              : userMenuItems.length,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: background(
                    width: double.infinity,
                    rightMargin: defaultSize,
                    child: PageView.builder(
                      itemCount: widget.logInType == 'Admin'
                          ? adminMenuItems.length
                          : userMenuItems.length,
                      itemBuilder: (context, index) {
                        return widget.logInType == 'Admin'
                            ? adminMenuItems[currentIndex].child
                            : userMenuItems[currentIndex].child;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
