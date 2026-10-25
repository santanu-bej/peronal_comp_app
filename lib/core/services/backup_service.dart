import 'dart:convert';
import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import '../db/database.dart';
import '../native/secrets.dart';
import '../utils/time.dart';

const _magic = [0x47, 0x43, 0x42, 0x4B, 0x01]; // "GCBK" v1
const _pbkdf2Rounds = 200000;

class BackupException implements Exception {
  final String message;
  BackupException(this.message);
  @override
  String toString() => message;
}

class BackupService {
  final AppDb db;
  final Secrets secrets;
  BackupService(this.db, this.secrets);

  final _aes = AesGcm.with256bits();

  Future<SecretKey> _derive(String pass, List<int> salt) => Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: _pbkdf2Rounds, bits: 256)
      .deriveKey(secretKey: SecretKey(utf8.encode(pass)), nonce: salt);

  /// Plain JSON of every table (no secrets; they never enter the database).
  Future<Map<String, dynamic>> snapshotJson() async {
    final tables = <String, dynamic>{};
    for (final name in allTableNames) {
      final rows = await db.customSelect('SELECT * FROM $name').get();
      tables[name] = [for (final r in rows) r.data];
    }
    return {'schema': db.schemaVersion, 'at': DateTime.now().millisecondsSinceEpoch, 'tables': tables};
  }

  Future<Uint8List> encrypt(Map<String, dynamic> json, String pass) async {
    final raw = GZipCodec().encode(utf8.encode(jsonEncode(json)));
    final rnd = SecretKeyData.random(length: 28).bytes;
    final salt = rnd.sublist(0, 16), nonce = rnd.sublist(16, 28);
    final box = await _aes.encrypt(raw, secretKey: await _derive(pass, salt), nonce: nonce);
    return Uint8List.fromList([..._magic, ...salt, ...nonce, ...box.cipherText, ...box.mac.bytes]);
  }

  Future<Map<String, dynamic>> decrypt(Uint8List data, String pass) async {
    if (data.length < _magic.length + 16 + 12 + 16 || !_listEq(data.sublist(0, _magic.length), _magic)) {
      throw BackupException('This is not a Goal Compass backup file.');
    }
    var o = _magic.length;
    final salt = data.sublist(o, o += 16);
    final nonce = data.sublist(o, o += 12);
    final cipher = data.sublist(o, data.length - 16);
    final mac = data.sublist(data.length - 16);
    try {
      final clear = await _aes.decrypt(SecretBox(cipher, nonce: nonce, mac: Mac(mac)), secretKey: await _derive(pass, salt));
      return jsonDecode(utf8.decode(GZipCodec().decode(clear))) as Map<String, dynamic>;
    } on SecretBoxAuthenticationError {
      throw BackupException('Wrong passphrase, or the file is damaged.');
    }
  }

  bool _listEq(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<File> exportToFile(String pass) async {
    final bytes = await encrypt(await snapshotJson(), pass);
    final dir = await getTemporaryDirectory();
    final f = File('${dir.path}/goal-compass-${dateKey(DateTime.now().millisecondsSinceEpoch)}.gcbak');
    await f.writeAsBytes(bytes);
    return f;
  }

  /// Replaces the whole DB inside one transaction. Throws on schema mismatch.
  Future<void> restore(Map<String, dynamic> json) async {
    final schema = json['schema'] as int?;
    if (schema == null || schema > db.schemaVersion) {
      throw BackupException('This backup is from a newer app version (schema $schema).');
    }
    final tables = json['tables'] as Map<String, dynamic>;
    await db.transaction(() async {
      for (final name in allTableNames) {
        await db.customStatement('DELETE FROM $name');
      }
      for (final name in allTableNames) {
        for (final row in (tables[name] as List? ?? const [])) {
          final m = Map<String, dynamic>.from(row as Map);
          if (m.isEmpty) continue;
          final cols = m.keys.toList();
          await db.customInsert(
            'INSERT INTO $name (${cols.join(',')}) VALUES (${List.filled(cols.length, '?').join(',')})',
            variables: [for (final c in cols) _variable(m[c])],
          );
        }
      }
    });
  }

  Variable _variable(Object? v) => switch (v) {
        null => const Variable<Object>(null),
        int i => Variable<int>(i),
        double d => Variable<double>(d),
        bool b => Variable<int>(b ? 1 : 0),
        _ => Variable<String>(v.toString()),
      };

  Future<void> importFile(Uint8List bytes, String pass) async => restore(await decrypt(bytes, pass));

  // ---- daily local snapshot (device key in secure storage), keep 14 ----
  Future<Directory> _snapDir() async {
    final base = await getApplicationDocumentsDirectory();
    final d = Directory('${base.path}/snapshots');
    if (!await d.exists()) await d.create(recursive: true);
    return d;
  }

  Future<String> _deviceKey() async {
    var k = await secrets.backupKey();
    if (k == null) {
      k = base64Encode(SecretKeyData.random(length: 32).bytes);
      await secrets.setBackupKey(k);
    }
    return k;
  }

  Future<File> snapshotNow() async {
    final dir = await _snapDir();
    final f = File('${dir.path}/snapshot-${dateKey(DateTime.now().millisecondsSinceEpoch)}.gcbak');
    await f.writeAsBytes(await encrypt(await snapshotJson(), await _deviceKey()));
    final files = (await dir.list().toList()).whereType<File>().toList()..sort((a, b) => a.path.compareTo(b.path));
    for (final old in files.take(files.length > 14 ? files.length - 14 : 0)) {
      await old.delete();
    }
    return f;
  }

  Future<List<File>> snapshots() async {
    final dir = await _snapDir();
    final files = (await dir.list().toList()).whereType<File>().toList()..sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  Future<void> restoreSnapshot(File f) async => restore(await decrypt(await f.readAsBytes(), await _deviceKey()));
}
