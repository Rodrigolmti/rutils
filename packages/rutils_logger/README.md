# rutils_logger

This package uses [logging_appenders](https://pub.dev/packages/logging_appenders) to log messages.

With it you can setup a logz appender and use it to log messages to a logz.io account.

### Usage

Call the setup method before to initialize the logger as you want.


```
RUtilsLogger.I.setup(...)
```

```
RUtilsLogger.I.e('Sample error')
```