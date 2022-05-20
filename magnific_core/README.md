# Magnific core

Common set of core utilities that a flutter app might need for validation, string utility, system orientation/fullscreen mode changes, etc.

## Features

### Images

- A simple `cachedImageProviderFactory` that returns a `CachedNetworkImageProvider` of the `package:cached_network_image` in release mode on non-webs. Returns a regular `NetworkImage` while debugging or when target is web. (This can be disabled by setting `doNotCacheInDebug` to `false`).

### Strings

- StringX: A simple but powerful string utility with various different functionalities like checking a string is blank.
- JWTDecoder: A class to read JWT token's values, it's expiry, payload.
- StringValidate: A class that can be used for validation in TextFormFields. Multiple validators can be used together like this: 
`validate: (it) => StringValidate.isEmpty(it) ?? StringValidate.mobilenumber(it)`.
- `encodeQueryParameters` to Encode a map as html query parameters.
