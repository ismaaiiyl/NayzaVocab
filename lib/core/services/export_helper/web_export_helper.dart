import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'export_helper.dart';

class WebExportHelper implements ExportHelper {
  @override
  Future<void> downloadJson(String jsonString, String fileName) async {
    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}

ExportHelper getExportHelper() => WebExportHelper();
