CompleterEx provides a wrapper for a Dart Completer.

Dart Completer's can be hard to diagnose when they don't complete.

There is no active stack visible in the debugger and essentially no trace that the completer is hanging.

CompleterEx helps to detect these problems by logging out any running Completers after a defined time period (10 seconds).

You can directly replace all existing Completer's with CompleterEx.

``` 

var old = Completer<int>();

becomes

var better = CompleterEx<int>();
```

You can change the logging interval globally by calling:

```
CompleterEx.reportInterval(Duration(seconds: 30));
```

#Logging
CompleterEx uses the standard log function from dart:developer.

When it logs an Completer it also logs the Stacktrace showing where the Completer was allocated from.



