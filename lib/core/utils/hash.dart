import 'dart:convert';
import 'package:crypto/crypto.dart';

String sha256Hex(String s) => sha256.convert(utf8.encode(s)).toString();

/// Normalised text hash: lowercase, collapsed whitespace, punctuation stripped.
String normText(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'[^\p{L}\p{N}\s]', unicode: true), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

String normHash(String s) => sha256Hex(normText(s));
