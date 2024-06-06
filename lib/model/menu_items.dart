import 'package:flutter/material.dart';
import 'package:vyavasaay/model/menu_details.dart';
import 'package:vyavasaay/screens/pages/drawer_pages/about_this_app.dart';
import 'package:vyavasaay/screens/pages/account_control/access_control.dart';
import 'package:vyavasaay/screens/pages/drawer_pages/account_details.dart';
import 'package:vyavasaay/screens/pages/drawer_pages/dashboard.dart';
import 'package:vyavasaay/screens/pages/doctors/doctor_info.dart';
import 'package:vyavasaay/screens/pages/incentive/generate_incentive_page.dart';
import 'package:vyavasaay/screens/pages/billing/bill_history.dart';
import 'package:vyavasaay/screens/pages/billing/generate_report.dart';
import 'package:vyavasaay/screens/pages/drawer_pages/login_history.dart';
import 'package:vyavasaay/screens/pages/drawer_pages/logout.dart';

class MenuItems {
  List<MenuDetails> adminMenuItems = [
    MenuDetails(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      child: const Dashboard(),
    ),
    MenuDetails(
      title: 'Generate Bills',
      icon: Icons.report_outlined,
      child: const BillHistory(),
    ),
    MenuDetails(
      title: 'Generate Report',
      icon: Icons.report_outlined,
      child: const GenerateReport(),
    ),
    MenuDetails(
      title: 'Doctor Info',
      icon: Icons.person_outlined,
      child: const DoctorInfo(),
    ),
    MenuDetails(
      title: 'Generate Incentive',
      icon: Icons.currency_rupee_outlined,
      child: const GenerateIncentive(),
    ),
    MenuDetails(
      title: 'Account Details',
      icon: Icons.account_circle_outlined,
      child: const AccountDetails(),
    ),
    MenuDetails(
      title: 'Access Control',
      icon: Icons.shield_outlined,
      child: const AccessControl(),
    ),
    MenuDetails(
      title: 'Login History',
      icon: Icons.location_history_outlined,
      child: const LoginHistory(),
    ),
    MenuDetails(
      title: 'About This App',
      icon: Icons.info_outline,
      child: const AboutThisApp(),
    ),
    MenuDetails(
      title: 'Log Out',
      icon: Icons.logout_outlined,
      child: const Logout(),
    ),
  ];
  List<MenuDetails> usersMenuItems = [
    MenuDetails(
      title: 'Dashboard',
      icon: Icons.dashboard_outlined,
      child: const Dashboard(),
    ),
    MenuDetails(
      title: 'Generate Bills',
      icon: Icons.report_outlined,
      child: const BillHistory(),
    ),
    MenuDetails(
      title: 'Generate Report',
      icon: Icons.report_outlined,
      child: const GenerateReport(),
    ),
    MenuDetails(
      title: 'Doctor Info',
      icon: Icons.person_outlined,
      child: const DoctorInfo(),
    ),
    MenuDetails(
      title: 'Account Details',
      icon: Icons.account_circle_outlined,
      child: const AccountDetails(),
    ),
    MenuDetails(
      title: 'Login History',
      icon: Icons.location_history_outlined,
      child: const LoginHistory(),
    ),
    MenuDetails(
      title: 'About This App',
      icon: Icons.info_outline,
      child: const AboutThisApp(),
    ),
    MenuDetails(
      title: 'Log Out',
      icon: Icons.logout_outlined,
      child: const Logout(),
    )
  ];
}
