Kotlin(v1.5)의 Collections library 를 porting 한 package.
Kotlin의 Collections library 의 기능을 가져오는데 중점을 둔다.
따라서 같은 기능이라면 이름이 달라도 구현하지 않으며 방계 기능에 대해선 Dart library 에 기반하여 이름을 짓는다.
Kotlin 과 달리 Dart 가 method overloading, union type 을 지원하지 않는 관계로 해당 feature 가 필요한 경우 이름을 조금 변경하여 작성한다.
Dart library 에 기반하여 기본적으로 Iterable 을 반환하도록한다. 단 반환형이 `subclass`로 나올 수 밖에 없다면 `subclass`로 반환하며 기반하여 작성한다. 따라서 어떠한 유사 기능이 Kotlin 에서 List 를 반환하더라도 Dart 에선 기본적으로 Iterable 을 반환하기에 Iterable 을 반환한다.

## Usage

A simple usage example:

```dart
import 'package:ktc_dart/ktc_dart.dart';

main() {
  var awesome = new Awesome();
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
