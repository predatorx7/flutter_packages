# Magnific core

Common set of core utilities that a flutter app might need for bootstrap, validation, string utility, system orientation/fullscreen mode changes, etc.

## Features

### Debugging
- logger: A powerful logging utility that can be used to send logs to remote servers like Crashlytics. 
- Magnific core adds a `LoggingManager` over the logger of `package:logging` for managing the logs.

### Images

- A simple `cachedImageProviderFactory` that returns a `CachedNetworkImageProvider` of the `package:cached_network_image` in release mode on non-webs. Returns a regular `NetworkImage` while debugging or when target is web. (This can be disabled by setting `doNotCacheInDebug` to `false`).

### Strings

- StringX: A simple but powerful string utility with various different functionalities like checking a string is blank.
- JWTDecoder: A class to read JWT token's values, it's expiry, payload.
- StringValidate: A class that can be used for validation in TextFormFields. Multiple validators can be used together like this: 
`validate: (it) => StringValidate.isEmpty(it) ?? StringValidate.mobilenumber(it)`.
- `encodeQueryParameters` to Encode a map as html query parameters.

### System

- `BootstrapApp` to initialize your app with logging and initial dependencies that are required before app starts up.
- `AppSystemUIOverlayStyle` to change top system status bar and bottom system navigation bar colors.
 
## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
