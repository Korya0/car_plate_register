# Logging & Errors

## 1. Logging

### One owner

- **One place logs an error — once.** The repository (or the data source when it
  owns the failure) catches the raw exception, logs it, maps it to a `Failure`,
  and returns `Result.failure(...)`.
- Use cases do not log. Notifiers do not log the same error again. Views never
  log.
- `AppLogger` is the only logger. No `print`, no `debugPrint` in feature code, no
  `logger` package calls scattered through the app.
- `AppProviderObserver` reports uncaught Riverpod provider failures through the
  same logger.

### Where it lands

| Level | Use |
|---|---|
| `debug` | flow checkpoints in development |
| `info` | successful high-level operations |
| `success` | user-visible completion worth tracing |
| `warning` | recoverable, expected problem |
| `error` | a failure that reaches the user |

### Crash reporting

- **Crashlytics is not enabled in this release.** It can be added later behind
  `AppLogger`, without touching feature code.
- Until then, errors are visible in debug builds only.
- Never add a second reporting SDK directly in a feature.

### Never log

- The Shared Access PIN or any hash of it.
- Device tokens, device identifiers, or Firebase installation IDs.
- Full brochure dumps or bulk exports.
- Anything that identifies the client or the customer.
- A brochure number is acceptable only as a single debug value when diagnosing a
  specific bug; never log a list of them.

### Shape

```dart
logger.error('Failed to load brochures', error: e, stackTrace: st);
```

A log line answers: **what failed**, **where**, and **why** — without user data.

---

## 2. Errors & results

### The failure set

Every failure is a sealed `Failure` with a user-safe `message`:

| Failure | When |
|---|---|
| `NetworkFailure` | no connection, timeout, unreachable host |
| `CacheFailure` | local read/write failed |
| `DatabaseFailure` | Drift query or transaction failed |
| `SyncFailure` | Firestore push/pull or conflict resolution failed |
| `ValidationFailure` | input rejected before persistence |
| `UnknownFailure` | nothing else fits; always logs the original |

- There is **no** `AuthFailure`. The app has no authentication.
- The Shared Access PIN is a code checked against Firestore data; it is not an
  identity and does not produce an auth session.
- Add a new failure only when it changes how the UI reacts. Otherwise use
  `UnknownFailure`.

### The rule

> **Data and domain return `Result<T>`. Presentation consumes `AsyncValue<T>`.
> A raw exception never crosses a layer boundary.**

```dart
// Data / domain
Future<Result<List<BrochureEntity>>> loadBrochures();

// Presentation
final AsyncValue<List<BrochureEntity>> brochures = ref.watch(brochuresProvider);
```

- `Result<T>` is `Success<T>` or `FailureResult<T>` (see
  `lib/core/error/result.dart`).
- `AsyncValue` is Riverpod's view state: `loading`, `data`, `error`.
- The notifier converts one into the other exactly once:

```dart
Future<List<BrochureEntity>> build() async {
  final result = await ref.watch(loadBrochuresUseCaseProvider).call();
  return switch (result) {
    Success(:final data) => data,
    FailureResult(:final failure) => throw failure,
  };
}
```

### Why both

`Result` keeps the data and domain layers independent of Riverpod and makes
failure explicit at every call site. `AsyncValue` gives the view loading, data,
and error branches without inventing a parallel state machine.

The final decision is recorded in `RESULT_VS_ASYNCVALUE.md` in the project root.
Until that file says otherwise, this is the convention.

### Travel path

```
data source → repository → use case → notifier → view
   throw        log + map    pass Result   AsyncValue   switch
```

- A data source may throw a platform exception.
- A repository catches it, logs once, and returns `Result.failure`.
- A use case passes the `Result` through; it may add validation failures.
- A notifier throws the `Failure` inside `AsyncValue.guard` or `build`, so
  Riverpod stores it as `AsyncError`.
- A view switches on `AsyncValue` and renders `AppErrorView` for the error
  branch.

### Error messages

- The UI never shows `e.toString()`, a stack trace, or an English platform
  message.
- Every failure carries an Arabic, user-safe message sourced from `AppStrings`.
- Debug detail belongs in the log, not on screen.
- A retry is offered only when retrying can succeed.

### Rules of thumb

- Validate before writing; return `ValidationFailure`, not a database error.
- Never swallow an error silently.
- Never catch `Object` without logging what was caught.
- Never rethrow a platform exception from a repository.
- Never let a `Failure` reach a widget as an exception string.
- A cancelled operation is not an error; return success or ignore it explicitly.
