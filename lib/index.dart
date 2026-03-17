// ignore_for_file: depend_on_referenced_packages

//* Basic Package
export 'package:flutter/material.dart';
export 'package:flutter/cupertino.dart' hide RefreshCallback;

//* Dart Package
export 'dart:core';
export 'dart:io' show Platform, File, Directory;
export 'dart:async';
export 'dart:convert';

//* Flutter Package
export 'package:flutter/services.dart';

//* Route
export 'package:ai_camera/routes/app_pages.dart';

//* Main
export 'package:ai_camera/global.dart';

//* Package
export 'package:get/get.dart'
    hide HeaderValue, IterableExtensions, Node, VoidCallback, ListEquality, Worker, Translations;
export 'package:path_provider/path_provider.dart';
export 'package:utils/utils.dart' hide Translations;
