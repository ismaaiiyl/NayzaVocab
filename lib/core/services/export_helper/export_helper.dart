/// Common interface for export helper
abstract class ExportHelper {
  Future<void> downloadJson(String jsonString, String fileName);
}

/// Fallback factory to avoid compilation errors
ExportHelper getExportHelper() => throw UnsupportedError('Cannot create export helper');
