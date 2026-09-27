// app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

final ThemeData appTheme = ThemeData.dark().copyWith(
  // background default
  scaffoldBackgroundColor: AppColors.darkBackgroundBodyColor,
  textTheme: GoogleFonts.nunitoTextTheme().apply(
    bodyColor: Colors.white,
  ),
);
