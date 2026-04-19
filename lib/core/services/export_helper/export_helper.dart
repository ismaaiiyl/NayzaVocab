/// Common interface for export helper
abstract class ExportHelper {
  Future<void> downloadJson(String jsonString, String fileName);
  Future<void> shareFile(String content, String fileName, String subject, String text);
}

/// Fallback factory to avoid compilation errors
ExportHelper getExportHelper() => throw UnsupportedError('Cannot create export helper');
