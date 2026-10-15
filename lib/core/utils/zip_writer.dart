// Dart imports:
import 'dart:convert';
import 'dart:typed_data';

/// One file inside a zip: its path (with `/` separators) and its bytes.
class ZipItem {
  const ZipItem(this.path, this.bytes);

  final String path;
  final Uint8List bytes;
}

final Uint32List _crcTable = () {
  final table = Uint32List(256);
  for (var n = 0; n < 256; n++) {
    var c = n;
    for (var k = 0; k < 8; k++) {
      c = (c & 1) != 0 ? (0xEDB88320 ^ (c >> 1)) : (c >> 1);
    }
    table[n] = c;
  }
  return table;
}();

int _crc32(Uint8List data) {
  var c = 0xFFFFFFFF;
  for (final b in data) {
    c = _crcTable[(c ^ b) & 0xFF] ^ (c >> 8);
  }
  return (c ^ 0xFFFFFFFF) & 0xFFFFFFFF;
}

/// Builds a standard .zip archive (entries stored, not compressed, which is
/// plenty for source files) without any package. Names are written as UTF-8.
Uint8List buildZip(List<ZipItem> items, {DateTime? modified}) {
  final when = modified ?? DateTime.now();
  final dosTime = (when.hour << 11) | (when.minute << 5) | (when.second ~/ 2);
  final dosDate =
      (((when.year < 1980 ? 1980 : when.year) - 1980) << 9) |
          (when.month << 5) |
          when.day;

  final out = BytesBuilder();
  final central = BytesBuilder();

  void u16(BytesBuilder b, int v) =>
      b.add([v & 0xFF, (v >> 8) & 0xFF]);
  void u32(BytesBuilder b, int v) => b.add(
        [v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF],
      );

  for (final item in items) {
    final name = utf8.encode(item.path);
    final crc = _crc32(item.bytes);
    final offset = out.length;

    // Local file header, then the data.
    u32(out, 0x04034B50);
    u16(out, 20); // version needed
    u16(out, 0x0800); // flags: names are UTF-8
    u16(out, 0); // method: stored
    u16(out, dosTime);
    u16(out, dosDate);
    u32(out, crc);
    u32(out, item.bytes.length);
    u32(out, item.bytes.length);
    u16(out, name.length);
    u16(out, 0); // extra field length
    out.add(name);
    out.add(item.bytes);

    // Central directory entry.
    u32(central, 0x02014B50);
    u16(central, 20); // version made by
    u16(central, 20); // version needed
    u16(central, 0x0800);
    u16(central, 0);
    u16(central, dosTime);
    u16(central, dosDate);
    u32(central, crc);
    u32(central, item.bytes.length);
    u32(central, item.bytes.length);
    u16(central, name.length);
    u16(central, 0); // extra
    u16(central, 0); // comment
    u16(central, 0); // disk number
    u16(central, 0); // internal attributes
    u32(central, 0); // external attributes
    u32(central, offset);
    central.add(name);
  }

  final centralOffset = out.length;
  final centralBytes = central.toBytes();
  out.add(centralBytes);

  // End of central directory.
  u32(out, 0x06054B50);
  u16(out, 0);
  u16(out, 0);
  u16(out, items.length);
  u16(out, items.length);
  u32(out, centralBytes.length);
  u32(out, centralOffset);
  u16(out, 0);
  return out.toBytes();
}
