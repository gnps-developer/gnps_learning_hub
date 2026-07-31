class DebugConfig {
  DebugConfig._();

  /// How many times the user must tap the app version to trigger the unlock dialog.
  static const developerModeTapCount = 10;

  /// SHA-256 hash of the secret code to unlock developer mode / debug tools.
  ///
  /// NOTE: Hashing is one-way. You cannot "unhash" this string.
  /// To change the code, generate a new hash and replace this value.
  ///
  /// How to generate a new hash (e.g. for code "my_secret"):
  /// Terminal (macOS/Linux): echo -n "my_secret" | shasum -a 256
  /// Windows (PS): [System.BitConverter]::ToString((new-object System.Security.Cryptography.SHA256Managed).ComputeHash([System.Text.Encoding]::UTF8.GetBytes("my_secret"))).Replace("-","").ToLower()
  ///
  static const developerModeUnlockHash =
      'afeaea6c9ba0ff09595663481861e9c89f196de432383d5b2f695cf5fed8ff35';
}
