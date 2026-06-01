# v0.2 디자인 자산 — 개발자 인도용

화면설계서 v0.2에 사용된 아이콘 자산을 표준 SVG 파일로 정리한 폴더다. 개발자는 이 폴더의 자산을 그대로 가져다 Flutter 프로젝트에 적용한다.

## 폴더 구조

```
assets/
├── icons/
│   ├── icon_caliper.svg          ← 탄산화 조사 (디지털 버니어 캘리퍼스)
│   ├── icon_tape.svg             ← 규격 조사 (줄자)           ← v0.2 신규
│   ├── icon_crack.svg            ← 균열 폭 조사               ← v0.2 신규 (disabled 톤)
│   ├── icon_subtype_width.svg    ← 규격조사 ▸ 벽/기둥/부재 폭  ← S-002
│   ├── icon_subtype_gap.svg      ← 규격조사 ▸ 부재 간 간격     ← S-002
│   └── icon_subtype_hole.svg     ← 규격조사 ▸ 홀 깊이          ← S-002
└── README.md
```

viewBox 규격:
- 메인 카드 아이콘 (S-001) — **36×36**
- subtype 카드 아이콘 (S-002) — **44×44** (메인 대비 더 큰 시각 비중)

모든 SVG는 정사각형 영역에 안전 여백을 두고 작도되었다.

## Flutter 적용 방법

### 권장 옵션 ①: SVG 그대로 사용 (해상도 무관, 권장)

`pubspec.yaml`에 `flutter_svg` 추가:
```yaml
dependencies:
  flutter_svg: ^2.0.10+1
```

자산을 프로젝트로 복사:
```
lib/
  assets/
    image/
      icon_caliper.svg
      icon_tape.svg
      icon_crack.svg
```

`pubspec.yaml`의 `flutter.assets`에 등록:
```yaml
flutter:
  assets:
    - assets/image/icon_caliper.svg
    - assets/image/icon_tape.svg
    - assets/image/icon_crack.svg
```

위젯 사용:
```dart
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture.asset(
  'assets/image/icon_caliper.svg',
  width: 36,
  height: 36,
)
```

### 옵션 ②: PNG로 변환 후 사용 (v1 기존 패턴 유지)

v1 코드는 `Image.asset('assets/image/icon_ruler.png')` 형태로 PNG를 사용한다.
같은 방식을 유지하려면 SVG → PNG 변환이 필요하다.

Inkscape CLI:
```bash
inkscape icon_caliper.svg --export-filename=icon_caliper.png --export-width=144
```

ImageMagick:
```bash
magick -background none -density 400 icon_caliper.svg -resize 144x144 icon_caliper.png
```

권장 PNG 사이즈: **144×144** (4x 기준, Flutter가 자동 다운스케일).
Android 멀티 해상도가 필요한 경우 `1.5x/2x/3x/4x` 폴더에 각각 54/72/108/144px 분리 배치.

## 메인 화면(S-001) 카드 매핑

| 카드 | 자산 | 활성/비활성 |
|------|------|------------|
| 탄산화 조사 | `icon_caliper.svg` | enabled |
| 규격 조사 (v0.2 신규) | `icon_tape.svg` | enabled |
| 균열 폭 조사 | `icon_crack.svg` | disabled (이미 톤다운된 회색 상태) |

> 비활성 시 추가 처리: 기존 v1 코드는 `Image.asset(..., color: Colors.grey[400], colorBlendMode: BlendMode.srcIn)`로 PNG에 그레이 틴트를 입혔다. `icon_crack.svg`는 이미 disabled 톤(#cbd5e1 / #e2e8f0)으로 그려져 있어 별도 틴트 불필요. SVG 사용 시 colorFilter 미적용 권장.

## 규격조사 유형 선택(S-002) 카드 매핑

| 카드 | 자산 | MeasurementSubtype |
|------|------|--------------------|
| 벽 / 기둥 / 부재 폭 측정 | `icon_subtype_width.svg` | `wall_or_member_width` |
| 부재 간 간격 측정 | `icon_subtype_gap.svg` | `member_gap` |
| 홀 깊이 측정 | `icon_subtype_hole.svg` | `hole_depth` |

> S-002 카드는 모두 선택 가능하다. 카드 탭 시 `Get.toNamed('/camera', arguments: {surveyType: dimension, subtype: <code>})`로 이동.
> 규격조사는 정의된 측정 방식의 데이터만 학습 가치를 갖기 때문에 "기타 측정"(자유 입력)은 의도적으로 제외한다.

### S-002 카드 상태 규칙 (기본 vs 선택)

S-001과 달리 S-002의 3개 카드는 모두 동등하게 선택 가능하므로, **기본(미선택)** 상태가 별도로 정의된다. 탭 피드백(ink ripple) 또는 짧은 강조 후 즉시 다음 화면으로 이동한다.

| 상태 | 배경 | 외곽선 | 제목색 | 부제색 |
|------|------|--------|--------|--------|
| 기본 (default) | `#FFFFFF` | 1px `#E5E7EB` | `#111827` | `#6B7280` |
| 선택 (selected) | `#EFF6FF` | 1.5px `#2563EB` | `#111827` | `#2563EB` |

> 참고: S-001(메인) 카드는 "활성/비활성" 이분 상태만 사용한다 (배경/외곽선 규칙은 v1 코드 그대로). S-002는 선택형 리스트라 상태 패턴이 다르다.

## 디자인 토큰 (아이콘 색)

| 용도 | 값 |
|------|---|
| Light fill (빔/케이스) | `#cbd5e1` |
| Outline | `#94a3b8` |
| Detail line (눈금) | `#64748b` |
| Dark fill (캘리퍼스 슬라이더) | `#64748b` |
| Dark outline | `#334155` |
| LCD 배경 | `#f8fafc` |
| 액센트 (오렌지 버튼) | `#f59e0b` |
| Disabled track | `#cbd5e1` / `#e2e8f0` |

## v1 기존 자산과의 관계

기존 자산 (계속 사용 또는 v0.2 자산으로 대체 선택):

| v1 자산 | v0.2 권장 |
|---------|-----------|
| `lib/assets/image/icon_ruler.png` (탄산화) | `icon_caliper.svg`로 **교체** 권장 (액정 컨셉 표현) |
| `lib/assets/image/icon_triangle_ruler.png` (배근 간격) | **제거** — v0.2에서 카드 자체 변경됨 |

## 변경 이력

- **2026-05-28**: v0.2 초기 자산 3종(caliper/tape/crack) 등록
