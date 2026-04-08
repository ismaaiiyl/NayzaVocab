
import 'dart:io';
import 'package:image/image.dart';

void main() {
  // Create a 256x256 image
  final image = Image(width: 256, height: 256);

  // Fill the image with a transparent background
  fill(image, color: ColorRgb8(0, 0, 0)..a = 0);

  // Define the Electric Gold color
  final electricGold = ColorRgb8(255, 204, 0);

  // Draw a solid circle
  fillCircle(image, x: 128, y: 128, radius: 120, color: electricGold);

  // Save the image to a PNG file
  File('assets/icon/icon.png').writeAsBytesSync(encodePng(image));
}
