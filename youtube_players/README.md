# youtube_players

A Flutter package which provides various youtube players depending on your requirement

## Installation

For Android, Add below line in `AndroidManifest.xml` 
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

For IOS, add below lines to your `Info.plist` file.
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>youtube</string>
</array>
<key>io.flutter.embedded_views_preview</key>
<true/>
```
