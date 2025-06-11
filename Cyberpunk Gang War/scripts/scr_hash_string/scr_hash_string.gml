/// @function scr_hash_string(nameStr)
/// @description Returns a hash-based pseudorandom integer from a string (e.g. gangster name)
/// @param {string} nameStr – the input string to hash
/// @returns {real} integer hash value

function scr_hash_string(nameStr) {
    var hash = 0;

    for (var i = 1; i <= string_length(nameStr); i++) {
        var c = ord(string_char_at(nameStr, i));
        hash = (hash * 31 + c) mod 2147483647; // Keep it in 32-bit int range
    }

    return abs(hash); // Ensure non-negative
}
