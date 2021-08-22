## 1.0.0

* Initial release with Futures support

## 1.1.0

* Breaking: Migrate to null-safety

## 1.2.0

* Breaking: Add a future creation function for lazy future building instead of taking a future as a value in Widget constructor.
* Breaking: Rename FutureSensitiveWidget to [WhenFutureBuilder].

## 1.2.0+1

* Add initial snapshot state with uninitialized in [WhenFutureNotifierMixin]

## 1.2.0+2

* Fix [WhenFutureNotifier.update] to refresh the future instead of using the old future's snapshots.