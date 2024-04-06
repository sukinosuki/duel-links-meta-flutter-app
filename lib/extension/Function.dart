import 'dart:async';
import 'dart:developer';

extension FunctionEx on Function {
  // TODO: execute immediately
  debounce(int milliseconds) {
    Timer? timer;

    log('debounce init $timer');

    return (dynamic args) {
      log('debounce 11111');
      timer?.cancel();

      timer = Timer(Duration(milliseconds: milliseconds), () {
        log('debounce execute, args: $args');
        this(args);
      });
    };
  }

  throttle(int milliseconds) {
    Timer? timer;

    log('throttle init');

    return () {
      if (timer == null) {
        log('throttle execute, this: ${this}');

        timer = Timer(Duration(milliseconds: milliseconds), () {
          timer = null;
          this.call();
        });

        // this.call();
      }
    };
  }

  throttleWith1Parameter(int milliseconds) {
    Timer? timer;

    log('throttle init');

    return (dynamic arg) {
      if (timer == null) {
        log('throttle execute, this: ${this}');

        timer = Timer(Duration(milliseconds: milliseconds), () {
          timer = null;
          this.call(arg);
        });

        // this.call();
      }
    };
  }
}
