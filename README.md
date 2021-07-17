`Kotlin`(v1.5)의 `Collections` library 를 porting 한 `package`.
`Kotlin`의 `Collections` library 의 기능을 가져오는데 중점을 둔다.

따라서 이하의 조건으로 작성해나간다.
- 제네릭 타입 이름 혹은 파라미터 이름등에서 같은 기능을 하는 것이 있다면 `Dart` 의 네이밍을 다른다.
- 같은 기능이라면 이름이 달라도 구현하지 않는다.
- 유사 기능의 방계에 대해선 `Dart` library 에 기반하여 이름을 짓는다.
- 유사 기능의 방계의 반환형은 `Dart` library 의 반환형을 따른다.
- `Kotlin`과 달리 `Dart`에는 `method overloading`, `union type`을 지원하지 않는 관계로 해당 feature 가 필요한 경우 이름을 조금 변경하여 작성한다.
