# 규격조사 모듈 화면설계서 v0.2 (개발자 작업용)

> **상태**: v0.1 와이어프레임(HTML)을 기반으로 **현 코드베이스(v1.0.1)에 통합 가능한 수준**으로 확장한 개발자용 명세서다.
> v0.1 와이어프레임: [`_inbound/규격조사_화면설계서_와이어프레임_명세_v0.1.html`](_inbound/규격조사_화면설계서_와이어프레임_명세_v0.1.html)
> 작성일: 2026-05-28

---

## 1. 문서 목적

v0.1 와이어프레임은 화면 시안과 JSON 매핑만 정의한다. v0.2는 다음을 추가로 정의한다.

- v1.0 앱의 기존 화면/모델/라우팅과 **어떻게 통합**되는지
- 개발자가 바로 구현 가능한 **Flutter 위젯/컨트롤러/라우트** 레벨 스펙
- **터치 좌표 → 원본 이미지 픽셀 좌표 변환** 알고리즘
- **subtype 별 분기 처리** 정책 (카메라 가이드 박스, 입력 필드, 검증 규칙)
- v1.0 업로드 API와 충돌 없이 **새 페이로드(annotation_json)를 흡수**하는 방식

## 2. v0.1 → v0.2 주요 갭 (이번 문서에서 해결)

| 갭 | v0.1 상태 | v0.2 조치 |
|----|----------|----------|
| 메인화면 메뉴 통합 | "규격조사" 카드 시안만 존재 | v1 `MainPage`의 카드 2개 → 3개로 재편 정의 |
| SurveyType enum | `carbonation`, `rebarSpacing`만 존재 | `dimension` 추가 + `MeasurementSubtype` 신설 |
| 측정점 지정 화면 | 와이어 박스만 표시 | 위젯 트리 / 마커 / 좌표 변환식 명세 |
| 가이드 박스 모양 | 화면별 그림 다름 | `GuideBoxMode` enum으로 통합 |
| 데이터 저장 | JSON 매핑만 정의 | `SurveyRecord` 모델 확장 + 호환성 보장 |
| 업로드 API | `image_file + annotation_json` 언급 | 기존 `upload_service.dart`와의 마이그레이션 경로 |
| 좌표 보정 | "원본 픽셀 환산"이라는 한 줄 | preview ↔ original 변환식 명시 |

---

## 3. 메인 화면 메뉴 재편 (v1 → v2)

### 현재 (v1.0.1)
```
[탄산화 조사]            ← enabled
[배근 간격 조사 (줄자)]   ← disabled "서비스 준비 중"
```

### v2 목표
```
[탄산화 조사]                                 ← enabled (변경 없음)
[규격 조사]                                   ← enabled (신규)
   └ 부제: 줄자 기반 폭 / 간격 / 깊이 측정
[배근 간격 조사]                              ← disabled (향후)
   └ 부제: 서비스 준비 중...
```

> **결정**: v1의 "배근 간격 조사"는 v2의 "규격 조사" 카드로 흡수(줄자 기반 측정으로 분류상 동일). 메인의 3번째 카드 자리에는 향후 추가 예정 항목으로 "배근 간격 조사" 표기(비활성). 명칭만 노출, 구현은 향후.

### 카드 탭 동작
| 카드 | 라우팅 |
|------|--------|
| 탄산화 조사 | `Get.toNamed('/camera', arguments: {surveyType: carbonation})` (v1과 동일) |
| 규격 조사 | `Get.toNamed('/survey-type-select')` ← **신규 화면 S-002** |
| 배근 간격 조사 | disabled |

---

## 4. 라우트 / 화면 흐름

### 신규 라우트
```dart
abstract class AppRoutes {
  // 기존
  static const main = '/';
  static const camera = '/camera';
  static const dataInput = '/data-input';
  static const archive = '/archive';
  static const photoViewer = '/photo-viewer';

  // 신규 (v2)
  static const surveyTypeSelect = '/survey-type-select';   // S-002
  static const annotate         = '/annotate';             // S-004 (폭/간격 공통) · S-007 (홀 깊이)
  static const dimensionInput   = '/dimension-input';      // S-005 (폭/간격 공통) · S-008 (홀 깊이)
}
```

### 화면 흐름 (규격조사)
```
[S-001 메인]
   │ "규격 조사" 카드 탭
   ▼
[S-002 유형 선택]   subtype ∈ {wall_or_member_width | member_gap | hole_depth}
   │
   ▼
[S-003 촬영 가이드 (폭/간격 공통) · S-006 촬영 가이드 (홀 깊이)]   ← /camera (subtype별 가이드 박스 + 안내 문구)
   │ 셔터
   ▼
[S-004 측정점 지정 (폭/간격 공통) · S-007 기준점 지정 (홀 깊이)]   ← /annotate
   │ 마커 입력 완료
   ▼
[S-005 수치 입력 (폭/간격 공통) · S-008 수치 입력 (홀 깊이)]    ← /dimension-input
   │ 저장
   ▼
[S-001 메인] (또는 "계속 촬영" 시 카메라로)
```

규격조사는 정의된 측정 방식(폭/간격/홀깊이)으로 수집한 데이터만 학습 가치를 갖기 때문에, v0.1 와이어프레임의 "기타 측정(`manual_other`)" 항목은 v0.2에서 제외한다.

---

## 5. 데이터 모델 확장

### 5.1 enum 신설

```dart
// lib/models/measurement_subtype.dart
enum MeasurementSubtype {
  wallOrMemberWidth('wall_or_member_width', '벽체/기둥/슬라브 폭 측정'),
  memberGap        ('member_gap',           '부재 규격 조사'),
  holeDepth        ('hole_depth',           '홀 깊이 측정');

  const MeasurementSubtype(this.code, this.label);
  final String code;   // 서버 전송용
  final String label;  // UI 표시용
}
```

### 5.2 SurveyType 확장

```dart
enum SurveyType {
  carbonation('탄산화 조사', 'carbonation'),
  dimension  ('규격 조사',   'dimension');   // ← rebarSpacing 대체

  const SurveyType(this.label, this.code);
  final String label;
  final String code;
}
```

> **마이그레이션**: 기존 `rebarSpacing`은 코드상 더 이상 생성되지 않지만, 보관함 호환을 위해 `SurveyRecord.fromJson`에서 `rebarSpacing` 문자열 입력 시 `dimension`으로 매핑하거나 enum에 deprecated 유지한다. 실제 데이터는 사실상 없으므로 `dimension` 매핑 권장.

### 5.3 SurveyRecord 확장

```dart
class SurveyRecord {
  final String id;
  final SurveyType surveyType;
  final MeasurementSubtype? measurementSubtype;  // ← 신규 (carbonation은 null)
  final String photoPath;
  final double value;                            // ← 호환용: measured_value 결과
  final DimensionAnnotation? annotation;         // ← 신규 (규격조사만)
  final String note;
  final DateTime timestamp;
  UploadStatus uploadStatus;
  // ...
}
```

### 5.4 DimensionAnnotation 신설

```dart
// lib/models/dimension_annotation.dart
class DimensionAnnotation {
  // 측정점 좌표 (원본 이미지 픽셀 기준, 좌상단 [0,0])
  final List<double>? startPointPixel;     // [x, y]
  final List<double>? endPointPixel;
  final List<double>? holeLipPixel;        // holeDepth 전용 (홀 입구 기준점)
  final List<double>? tapeReadingPixel;    // holeDepth 전용 (줄자 읽기 위치) — v0.2에서 필수로 승격

  // 수치
  final double? startValue;       // mm
  final double? endValue;         // mm
  final double? visibleReadingValue;  // holeDepth 전용 (mm)
  final double  measuredValue;    // 계산 결과 (mm)

  // 속성
  final String? startSurfaceType;     // wall_edge | column_edge | beam_edge ...
  final String? endSurfaceType;
  final String  tapeDirection;        // horizontal | vertical
  final String? startVisibility;      // visible | hidden_behind_lip
  final String? contactConfirmation;  // yes | no | unknown (holeDepth)

  // 품질 플래그 (저장 시점 기록, 사용자 입력 + 자동 판정)
  final QualityFlags qualityFlags;

  // 원본 이미지 크기 (좌표 환산용 메타)
  final int imageWidth;
  final int imageHeight;

  Map<String, dynamic> toJson();
  factory DimensionAnnotation.fromJson(Map<String, dynamic> j);
}

class QualityFlags {
  final bool digitsClear;
  final bool startEdgeVisible;
  final bool endEdgeVisible;
  final bool tapeStraight;
  final String perspectiveDistortion;  // low | medium | high
  final bool occlusion;
}
```

### 5.5 records.json 저장 예시

```json
{
  "id": "1748427000000",
  "surveyType": "dimension",
  "measurementSubtype": "member_gap",
  "photoPath": "/.../photos/1748427000000.jpg",
  "value": 300.0,
  "annotation": {
    "startPointPixel": [690, 418],
    "endPointPixel":   [1190, 408],
    "startValue": 120,
    "endValue":   420,
    "measuredValue": 300,
    "startSurfaceType": "wall_edge",
    "endSurfaceType":   "wall_edge",
    "tapeDirection":    "horizontal",
    "qualityFlags": {
      "digitsClear": true,
      "startEdgeVisible": true,
      "endEdgeVisible": true,
      "tapeStraight": true,
      "perspectiveDistortion": "medium",
      "occlusion": false
    },
    "imageWidth": 1440,
    "imageHeight": 1080
  },
  "note": "줄자 처짐 없음, 숫자 선명",
  "timestamp": "2026-05-28T14:32:00+09:00",
  "uploadStatus": "pending"
}
```

탄산화 레코드는 `measurementSubtype`, `annotation` 필드가 누락(또는 null)되어 v1 코드와 호환된다. `SurveyRecord.fromJson`은 두 필드를 nullable로 처리한다.

---

## 6. 화면별 상세 명세

### S-001 메인 선택 (기존 화면 수정)

| 항목 | 내용 |
|------|------|
| 파일 | [lib/pages/main/main_page.dart](../../lib/pages/main/main_page.dart) |
| 변경 | `_SurveyCard` 2개 → 3개. v1 "배근 간격 조사" → "규격 조사"로 명칭/콜백 변경, 3번째 자리에 "배근 간격 조사" 비활성 카드(향후) 추가 |
| 콜백 | 규격 조사 카드: `Get.toNamed(AppRoutes.surveyTypeSelect)` |
| 아이콘 | "줄자" 이미지 자산 추가 필요 → [spec/origin_assets/현장촬영앱어셋/5.버튼이미지어셋/](../origin_assets/현장촬영앱어셋/5.버튼이미지어셋) 또는 신규 자산 (담당자 확인) |

### S-002 규격조사 유형 선택 (신규)

| 항목 | 내용 |
|------|------|
| 라우트 | `/survey-type-select` |
| 페이지 | `SurveyTypeSelectPage` |
| 컨트롤러 | `SurveyTypeSelectController` (선택 후 카메라 라우팅만 담당, 상태 거의 없음) |
| 진입 인자 | 없음 |
| 종료 시 | `Get.toNamed('/camera', arguments: {surveyType: dimension, subtype: <선택값>})` |

**위젯 트리 (요약)**
```
Scaffold
├ AppBar(title: '규격 조사', leading: back)
├ Body: ListView
│  ├ Padding('측정 유형을 선택하세요')
│  ├ _SubtypeCard(wallOrMemberWidth, thumbnail)
│  ├ _SubtypeCard(memberGap, thumbnail)
│  └ _SubtypeCard(holeDepth, thumbnail)
```

각 카드는 `MeasurementSubtype.label` + 한 줄 설명 + 썸네일. 디자인은 `_SurveyCard`와 동일 스타일 재사용.

### S-003 (폭/간격 공통) / S-006 (홀 깊이) 촬영 가이드 (기존 카메라 페이지 확장)

> **v0.2 화면 통합 (2026-06-01)**: 폭(`wall_or_member_width`)과 간격(`member_gap`)은 화면 구조·인터랙션이 100% 동일하므로 **하나의 mockup(S-003)** 으로 통합. 차이는 안내 문구뿐 (subtype 인자에 따라 동적 분기). 이전에 별도였던 S-009/S-010/S-011은 폐기되고 S-003/S-004/S-005가 두 케이스를 모두 커버한다.

| 항목 | 내용 |
|------|------|
| 파일 | [lib/pages/camera/camera_page.dart](../../lib/pages/camera/camera_page.dart) |
| 변경 | (1) `subtype`(nullable `MeasurementSubtype`) 인자 추가, 가이드박스 모드 분기. (2) **가이드박스 좌/우 핸들 드래그로 시작/끝점 사전 좌표 확보** (S-003 폭/간격 공통) |
| 다음 화면 | `surveyType == dimension` → `/annotate` (사전 좌표 + 이미지 전달)<br>탄산화 → 기존대로 `/data-input` |

**핸들 드래그 사양 (S-003 폭·간격 측정 — 단일 화면 통합)**
- 시작 핸들 (32×32 원형, 파랑 `#2563EB`, 흰 외곽 3px) — 가이드박스 좌측 끝 **외곽**에 위치
- 끝 핸들 (32×32 원형, 빨강 `#ef4444`, 흰 외곽 3px) — 가이드박스 우측 끝 **외곽**에 위치
- **핸들 위치 = 컨트롤 그립 / 박스 좌·우 끝 = 측정 시작·끝점 실제 좌표** (v0.2 결정 2026-06-01)
  - 좌측 핸들: `left: calc(var(--start-x) - 18px)`
  - 우측 핸들: `left: calc(var(--end-x) + 18px)`
  - 이유: 핸들 원이 측정 영역(박스 안쪽)을 가리지 않도록 분리
- 핸들 드래그 → 박스 가로 폭 자동 조정 (세로 위치는 화면 중앙 고정)
- 제약: 최소 폭 80px, 화면 좌/우 가장자리 36px 이내까지만 이동 (핸들이 가장자리에 닿지 않도록)
- 핸들 좌표(preview px) → 셔터 시 BoxFit.contain 환산식 적용해 원본 픽셀로 저장 후 `/annotate`로 전달
- **측정 구간선(span-line) 제거** (v0.2 결정 2026-06-01) — 사진의 줄자(가로) 위에 노란 점선이 겹쳐 줄자 숫자 가독성을 떨어뜨림
- **측정점 표시선(measure-line) 추가** (v0.2 결정 2026-06-01) — 얇은 2px 세로선이 가이드박스 좌/우 끝 정확히 위치 (시작 `#2563EB` / 끝 `#ef4444`). 작업자가 박스 끝의 정확한 측정점 위치를 시각적으로 확인. 핸들(외곽 그립)과 시각적으로 분리

S-006(홀 깊이)는 핸들 드래그 미적용 — 홀 입구는 단일 점이므로 S-007에서 한 번에 지정.

**폭 vs 간격 — 줄자 시작 위치 차이 (v0.2 정의 2026-06-01, 단일 S-003 화면 내에서 subtype 분기)**

두 화면의 핵심 차이는 **줄자의 어느 눈금을 측정 시작점에 맞추는지**다. 측정 대상의 실제 사이즈 계산 결과는 같지만, 줄자 사용 케이스가 다르므로 학습 데이터로서 각각 의미가 있다.

| 구분 | `wall_or_member_width` (폭) | `member_gap` (간격) |
|------|----------------------------------|---------------------------|
| 줄자 시작 | 줄자 `0` = 측정 시작면 | 줄자 **임의 눈금** (예: 120) = 측정 시작점 |
| 안내 문구 | "측정 시작면에 맞추고 촬영하세요" | "줄자 양 끝의 눈금이 모두 보이게 촬영하세요" |
| 시작값 입력 (S-005) | 일반적으로 `0` | 임의 값 (예: 120) |
| 끝값 입력 | 부재 사이즈 (예: 300) | 임의 끝 눈금 (예: 420) |
| 측정값 계산 | `= end - 0 = end` | `= end - start` (둘 다 임의값) |
| 가이드박스/핸들/줌/플래시 | 완전 동일 (코드 공유) | (동일) |

- **학습 데이터 가치**: 폭(`wall_or_member_width`)은 "줄자 0이 항상 측정 시작" 케이스, 간격(`member_gap`)은 "줄자 임의 위치에서 시작" 케이스를 분리 수집해 모델이 줄자 0 의존 없이 학습 가능
- **현장 시나리오**: 폭은 부재 끝에 줄자 0을 정확히 맞출 수 있을 때 / 간격은 부재 모서리 손상·접근 어려움 등으로 줄자 0이 아닌 임의 눈금에서 시작해야 할 때
- 작업자는 S-002에서 subtype을 선택해 어떤 케이스를 수집할지 결정

**안내 문구 (subtype별)**
| subtype | 문구 |
|---------|------|
| `wall_or_member_width` | "측정 시작면에 맞추고 촬영하세요" |
| `member_gap` | "줄자 양 끝의 눈금이 모두 보이게 촬영하세요" |
| `hole_depth` | "홀 입구와 줄자 숫자가 함께 보이게 촬영하세요" |

**자세(기울기) 잠금 정책 (v0.2 결정 2026-05-29)**
- 규격 조사 카메라(S-003 폭/간격 공통 · S-006 홀 깊이)에서는 **자세 잠금 미적용**. 천장·구조물 등 다양한 각도 측정이 필요하기 때문.
- 셔터·핸들·줌·플래시는 항상 활성. 가이드박스 색상도 노랑 단일 (빨강 잠금 상태 없음).
- 코드: `CameraController2._initTiltSensor()` 진입 시 `surveyType == SurveyType.dimension`이면 조기 return. 탄산화는 기존 동작 유지(영향 없음).
- v1의 SMA 5샘플 + 1.5° 데드존 + 15°/16° 임계값 알고리즘은 탄산화 전용으로 보존.

**가이드 박스 모드 enum**
```dart
enum GuideBoxMode {
  rectHorizontalShort,   // 탄산화 (기존 기본)
  rectHorizontalWide,    // wallOrMemberWidth, memberGap (가로 긴 박스)
  ovalVertical,          // holeDepth (세로 타원)
}

GuideBoxMode resolveGuideBoxMode(SurveyType t, MeasurementSubtype? s) {
  if (t == SurveyType.carbonation) return GuideBoxMode.rectHorizontalShort;
  switch (s) {
    case MeasurementSubtype.wallOrMemberWidth:
    case MeasurementSubtype.memberGap:
      return GuideBoxMode.rectHorizontalWide;
    case MeasurementSubtype.holeDepth:
      return GuideBoxMode.ovalVertical;
    default:
      return GuideBoxMode.rectHorizontalShort;
  }
}
```

**상단 안내 문구 (subtype별)**
| subtype | 문구 |
|---------|------|
| `wall_or_member_width` | "측정 시작면과 끝면이 모두 보이게 촬영하세요." |
| `member_gap` | "시작과 끝의 단면이 모두 포함되게 촬영하세요." |
| `hole_depth` | "홀 입구와 줄자 숫자가 함께 보이게 촬영하세요." |
| 탄산화 | (기존 문구 유지) |

**저장 시 추가 메타**: 촬영 직후 이미지의 `width`, `height`를 읽어 다음 화면으로 전달 (`image_size: Size(w, h)`).

### S-004 (폭/간격 공통) / S-007 (홀 깊이) 측정점 지정 (신규)

> **v0.2 결정 (2026-05-29)**: S-003 카메라 핸들로 시작/끝점이 사전 확정되므로, S-004는 "처음 찍기" 화면이 아니라 **정밀 지정 화면**으로 작동한다. 진입 시 이미 마커가 표시되어 있고, 사용자는 드래그/탭으로 미세 조정만 한다. S-007(홀 깊이)는 사전 좌표 없이 처음 찍기 모드로 유지.
>
> **마커 디자인 (외주 와이어 반영)**: 단순 원형 마커가 아닌 **라벨 pill + 점선 stem + 측정 지점(작은 원)** 의 합성 구조. 라벨이 측정 지점에서 수직으로 떨어져 있어 사진 위 측정 지점이 답답하지 않게 시각화. 시작=파랑 `#2563EB`, 끝=빨강 `#ef4444`로 일관 적용. 사진 위 두 마커 사이 연결선은 두지 않음(실제 사진에 줄자가 있어 시각적 연결은 자명).
>
> **라벨 자유 드래그 (v0.2 결정 2026-05-29)**: 마커를 단순 위/아래 토글이 아니라 **측정 지점(point)과 라벨(label) 별도 요소로 분리**하여 각각 독립 드래그 가능. stem(점선)은 두 점을 잇는 SVG line으로 자동 갱신. 사진의 줄자가 가로로 펼쳐진 영역, 측정 대상 위 정보 표시 영역 등 가림 회피를 위해 작업자가 라벨 위치를 자유롭게 결정 가능. 측정 지점 드래그 시 라벨도 오프셋 유지하며 동반 이동 (좌표 변경 의도). 사진 빈 곳 탭 시 가장 가까운 측정 지점이 이동(라벨 동반). 초기 라벨 위치는 측정 지점에서 위 50px(상단 가까이면 아래 50px).
>
> **단계 안내 카드**: 사진 영역 아래에 1단계(파랑 톤) · 2단계(빨강 톤) 카드 2장 배치. 각 카드 = 번호 원 + 한 줄 제목 ("측정 시작/끝점을 선택하세요"). 우측 일러스트는 의미 모호하여 두지 않음. 어느 마커가 어떤 단계에 해당하는지 색상으로 매핑.

| 항목 | 내용 |
|------|------|
| 라우트 | `/annotate` |
| 페이지 | `AnnotatePage` |
| 컨트롤러 | `AnnotateController` |
| 진입 인자 | `{ photoPath, surveyType, subtype, imageWidth, imageHeight, prefilledStart?, prefilledEnd? }` |
| 종료 시 | `Get.toNamed('/dimension-input', arguments: { ..., annotationPartial })` |

**상태 (Rx)**
```dart
final startPoint = Rxn<Offset>(); // 원본 픽셀 좌표 (UI 표시는 preview로 환산)
final endPoint   = Rxn<Offset>();
final currentStep = 1.obs;        // S-007(홀깊이) 전용: 1단계 진행 표시
// 부수 입력
final startSurfaceType = Rxn<String>();      // memberGap만
final endSurfaceType   = Rxn<String>();
final startVisibility  = Rxn<String>();      // holeDepth만
final contactConfirm   = Rxn<String>();      // holeDepth만

@override
void onInit() {
  super.onInit();
  // S-003 핸들에서 받은 사전 좌표를 초기값으로 채움
  final args = Get.arguments as Map<String, dynamic>?;
  if (args?['prefilledStart'] != null) {
    startPoint.value = args!['prefilledStart'];
  }
  if (args?['prefilledEnd'] != null) {
    endPoint.value = args!['prefilledEnd'];
  }
}
```

**위젯 트리 (subtype별 분기)**
```
Scaffold
├ AppBar(title: '측정점 보정' / '측정점 지정', back)
├ Column
│  ├ Expanded (사진 영역, AspectRatio = image w/h)
│  │  └ Stack
│  │     ├ Image.file(photoPath)
│  │     ├ _DraggableMarker(start: blue, drag → startPoint 갱신)
│  │     ├ _DraggableMarker(end: red,  drag → endPoint 갱신)   ← S-004 (폭/간격)
│  │     └ _DraggableMarker(holeLip: yellow)                     ← S-007
│  ├ _HintCard
│  │   ├ S-004 (폭/간격): "핸들 위치를 정밀하게 조정하세요. 탭으로 즉시 이동도 가능."
│  │   └ S-007:        "1단계. 홀 입구 기준점을 터치하세요."
│  └ (holeDepth) _RadioGroup(시작점 상태) + _RadioGroup(접촉 여부)
└ BottomBar [다시 촬영 / 다음]
```

**조작 방식**
- 사진 위 마커는 드래그로 미세 이동 (메인 방식)
- 빈 곳을 탭하면 가장 가까운 마커가 그 위치로 즉시 이동 (보조 방식)
- 핀치 줌은 P6에서 photo_view 패키지로 추가 예정

**터치 좌표 → 원본 픽셀 변환 (필수)**
```dart
// AnnotateController
Offset toOriginalPixel(Offset previewTap, Size previewSize, Size originalSize) {
  // BoxFit.contain 기준 (사진을 영역에 fit해서 표시한다고 가정)
  final scale = math.min(
    previewSize.width / originalSize.width,
    previewSize.height / originalSize.height,
  );
  final renderedW = originalSize.width * scale;
  final renderedH = originalSize.height * scale;
  final offsetX = (previewSize.width  - renderedW) / 2;
  final offsetY = (previewSize.height - renderedH) / 2;

  final x = ((previewTap.dx - offsetX) / scale).clamp(0.0, originalSize.width);
  final y = ((previewTap.dy - offsetY) / scale).clamp(0.0, originalSize.height);
  return Offset(x, y);
}
```

> 사진을 zoom/pan하려면 `photo_view: ^0.15.x` 의존성 추가 후 `PhotoViewController`의 `scale`/`position`을 사용해 보정. 핀치 줌은 후속(낮은 우선순위).

**저장 데이터 (AnnotateController → DimensionInputController 전달)**
```dart
final partial = {
  'photoPath':     photoPath,
  'subtype':       subtype,
  'imageWidth':    imageWidth,
  'imageHeight':   imageHeight,
  'startPointPixel': [startOriginal.dx, startOriginal.dy],
  'endPointPixel':   [endOriginal?.dx, endOriginal?.dy],
  'holeLipPixel':       holeDepth ? [holeOriginal.dx, holeOriginal.dy] : null,
  'tapeReadingPixel':   holeDepth ? [tapeOriginal.dx, tapeOriginal.dy] : null,
  'startSurfaceType':   startSurfaceType.value,
  'endSurfaceType':     endSurfaceType.value,
  'startVisibility':    startVisibility.value,
  'contactConfirm':     contactConfirm.value,
};
```

**검증 규칙**
- `wallOrMemberWidth`, `memberGap`: 시작점과 끝점 둘 다 입력되어야 "다음" 활성화
- `holeDepth`: `holeLipPixel` + `tapeReadingPixel` + `startVisibility` + `contactConfirm` **4단계 모두 입력 필수** (v0.2에서 tapeReadingPixel을 옵션 → 필수로 승격)
- 두 점이 동일 좌표(distance < 5px)일 경우 경고

### S-005 (폭/간격 공통) / S-008 (홀 깊이) 수치 입력 (신규 — v1 DataInputPage와 분리)

> **v0.2 결정 (2026-05-29)**: 이 화면에 사진 미니뷰(좌표 컨텍스트 표시)와 quality_flags 자가 체크 섹션은 **모두 제거**. 학습 품질 메타데이터는 비고 자유 기입 + 후처리 큐레이션 단계에서 채우는 방식으로 통일. 작업자 입력 부담 최소화가 일관성 ↑보다 우선.

| 항목 | 내용 |
|------|------|
| 라우트 | `/dimension-input` |
| 페이지 | `DimensionInputPage` |
| 컨트롤러 | `DimensionInputController` |
| 진입 인자 | `partial`(앞 화면에서 전달) |

**컨트롤러 상태**
```dart
final startValueCtrl  = TextEditingController();
final endValueCtrl    = TextEditingController();   // holeDepth는 미사용
final visibleValueCtrl = TextEditingController();  // holeDepth 전용
final noteCtrl        = TextEditingController();

final measuredValue = 0.0.obs;
final isValid       = false.obs;

// 자동 계산
void recompute() {
  if (subtype == holeDepth) {
    final v = double.tryParse(visibleValueCtrl.text);
    measuredValue.value = v ?? 0;
    isValid.value = v != null && v > 0;
  } else {
    final s = double.tryParse(startValueCtrl.text);
    final e = double.tryParse(endValueCtrl.text);
    if (s == null || e == null) { isValid.value = false; return; }
    if (e <= s) {
      isValid.value = false;  // 에러 메시지 표시
      return;
    }
    measuredValue.value = e - s;
    isValid.value = true;
  }
}
```

**위젯 트리 (subtype별 분기)**
```
Scaffold
├ AppBar('수치 입력' + subtype chip)
├ Column (scrollable)
│  ├ (wall/gap) InputCard('1. 줄자 시작값', 'mm') + TextField
│  ├ (wall/gap) InputCard('2. 줄자 끝값', 'mm') + TextField
│  ├ (holeDepth) InputCard('1. 보이는 줄자 숫자', 'mm') + TextField
│  ├ ResultCard('자동 계산 측정값 = ${measuredValue} mm')
│  └ MemoCard('비고 (선택)') + TextField multiline (140+ height, 이상사항 자유 기입 placeholder)
└ BottomBar [다시 촬영] [저장]
```

> 사진 미니뷰 카드, quality_flags 자가 체크 카드(체크박스 5개 + 원근 왜곡 3칩), memberGap의 surfaceType/tapeDirection 요약 표시는 v0.2에서 모두 제거. 작업자 입력 부담 최소화 정책.

**모바일 입력 편의 (v0.2 결정)**
- TextField는 `keyboardType: TextInputType.numberWithOptions(decimal: true)` 사용 (Flutter)
- HTML 기준 `type="text" inputmode="decimal"` — 숫자 스피너(상하 토글) 노출 안 함
- 입력 필드 height 56, 폰트 20 monospace — 모바일 터치 영역 확보
- 입력란 우측 내부에 **클리어 버튼 (×)** 위치 (값 있을 때만 표시) — `suffixIcon: IconButton(Icons.cancel, ...)` 패턴
- placeholder는 "줄자 시작 눈금" / "줄자 끝 눈금" (구체 숫자 예시 안 함 — 학습 데이터 다양성 유도)
- **빠른 입력 칩(0, 10, 50, 100 등)은 의도적으로 제외** — 특정 값 유도가 학습 다양성 ↓

**저장 동작 — 단일 "저장 후 계속 촬영" (v1 패턴 일치)**

카메라 촬영 흐름에서 메인 직행 액션은 의도적 제외. 저장 시 카메라(같은 subtype 유지)로 복귀해 연속 측정이 기본. 메인으로 가려면 카메라(S-003·S-006) 상단 ← 뒤로가기 사용. 이는 v1 탄산화 데이터 입력의 단순화된 패턴([data_input_controller.dart:42-58](../../lib/pages/data_input/data_input_controller.dart#L42-L58))과 동일.

```dart
Future<void> save() async {
  final annotation = DimensionAnnotation(
    startPointPixel:  partial['startPointPixel'],
    endPointPixel:    partial['endPointPixel'],
    holeLipPixel:     partial['holeLipPixel'],
    tapeReadingPixel: partial['tapeReadingPixel'],   // v0.2 필수
    startValue:      _parseOrNull(startValueCtrl.text),
    endValue:        _parseOrNull(endValueCtrl.text),
    visibleReadingValue: _parseOrNull(visibleValueCtrl.text),
    measuredValue:   measuredValue.value,
    startSurfaceType: partial['startSurfaceType'],
    endSurfaceType:   partial['endSurfaceType'],
    tapeDirection:   subtype == holeDepth ? 'vertical' : 'horizontal',
    startVisibility:  partial['startVisibility'],
    contactConfirmation: partial['contactConfirm'],
    qualityFlags: null,  // 현장 입력 단계에선 비워둠 (후처리 큐레이션에서 채움)
    imageWidth:  partial['imageWidth'],
    imageHeight: partial['imageHeight'],
  );
  final record = SurveyRecord(
    id: '${DateTime.now().millisecondsSinceEpoch}',
    surveyType: SurveyType.dimension,
    measurementSubtype: subtype,
    photoPath: photoPath,
    value: measuredValue.value,
    note: noteCtrl.text.trim(),
    timestamp: DateTime.now(),
    annotation: annotation,
  );
  await StorageService.I.addRecord(record);
  // dimension은 스택이 [main, /survey-type-select, /camera, /annotate, /dimension-input].
  // /camera로 복귀하기 위해 /annotate + /dimension-input 2장 pop.
  // v1 탄산화는 [main, /camera, /data-input] 구조라 Get.back() 한 번으로 충분.
  Get.until((r) => r.settings.name == AppRoutes.camera);
}
```

**카메라(S-003/S-006) 측 처리**
- `Get.toNamed('/annotate', ...)`만 호출. result 처리 불필요.
- **카메라 상단 ← 뒤로가기 = 메인 직행** (`Get.until((r) => r.settings.name == AppRoutes.main)`). v1 탄산화 카메라도 동일 패턴으로 통일 ([camera_page.dart](../../lib/pages/camera/camera_page.dart)). 이는 사이의 `/survey-type-select`(v0.2 규격조사) 한 장을 건너뛰어 한 번에 메인으로 가게 한다.

### S-009 보관함 (기존 화면 수정 · 이전 ID S-012)

| 항목 | 내용 |
|------|------|
| 파일 | [lib/pages/archive/archive_page.dart](../../lib/pages/archive/archive_page.dart) |
| 변경 | 카드에 `surveyType + subtype` 함께 표시. `dimension` 레코드는 측정값 옆에 subtype label 뱃지 |
| TODO | CLAUDE.md "보관함 내 업로드 버튼" TODO를 v2에서 같이 해결 (전체 미전송 N건 업로드) |

**수정 모달 — subtype별 분기 (v0.2 변경 2026-06-01)**

v0.1까지는 단일 모달(측정값 + 비고)이었으나, v0.2부터 레코드의 `surveyType + measurementSubtype` 조합에 따라 **3가지 모달 변형**으로 분기. 각 변형은 원본 입력 화면 구조와 일치.

| 카드 종류 | 모달 변형 | 입력 필드 | 원본 입력 화면 |
|----------|-----------|----------|----------------|
| `carbonation` | 탄산화 모달 | 단일 측정값(mm) + 비고 | v1 데이터 입력 |
| `dimension` + `wallOrMemberWidth` 또는 `memberGap` | 폭/간격 모달 | 시작값(mm) + 끝값(mm) + 자동 계산 측정값 + 비고 | S-005 |
| `dimension` + `holeDepth` | 홀 깊이 모달 | 줄자 읽은 값(mm) + 비고 | S-008 |

**구현 방향**
```dart
// archive_card.dart - 수정 버튼 onTap
Future<void> _openEditDialog(SurveyRecord record) async {
  if (record.surveyType == SurveyType.carbonation) {
    await Get.dialog(_CarbonationEditDialog(record: record));
  } else if (record.measurementSubtype == MeasurementSubtype.holeDepth) {
    await Get.dialog(_HoleDepthEditDialog(record: record));
  } else {
    // wallOrMemberWidth 또는 memberGap → 동일 다이얼로그
    await Get.dialog(_DimensionEditDialog(record: record));
  }
}
```

- **저장 동작**: 각 다이얼로그에서 `StorageService.I.updateRecord(updated)` 호출 후 모달 닫음.
- **편집 가능 필드**: 측정값 + 비고. dimension의 경우 시작값/끝값 분리 편집 가능 (자동으로 measuredValue 재계산).
- **편집 불가**: 사진(`photoPath`), 좌표(`startPointPixel` 등), subtype, timestamp — 보관함에서 변경 불가. 다시 측정하려면 재촬영 필요.

---

## 7. 공통 컴포넌트 사양

### 7.1 가이드 박스 (`GuideBoxPainter`)

`camera_page.dart`에 이미 존재하는 점선 페인터를 mode 인자로 분기.

```dart
class GuideBoxPainter extends CustomPainter {
  final GuideBoxMode mode;
  final bool isLevel;  // 수평이면 yellow, 기울면 red
  ...
  void paint(Canvas c, Size s) {
    switch (mode) {
      case rectHorizontalShort: _drawDashedRect(c, s, ratio: Size(0.8, 0.2)); break;
      case rectHorizontalWide:  _drawDashedRect(c, s, ratio: Size(0.9, 0.15)); break;
      case ovalVertical:        _drawDashedOval(c, s, ratio: Size(0.4, 0.55)); break;
    }
  }
}
```

라벨 텍스트("시작면 / 끝면 / 측정 영역")는 별도 `Positioned` 위젯으로 가이드 박스 모서리에 배치.

### 7.2 측정점 마커

```dart
class _Marker extends StatelessWidget {
  final Offset position;   // preview 좌표
  final Color color;       // start=blue, end=red, holeLip=yellow
  final String label;      // '시작', '끝', '입구'
}
```

크기: 직경 24, 라벨은 마커 우상단 배지 형태.

### 7.3 자동계산 결과 카드 (`ResultCard`)

```
┌───────────────────────────────┐
│  자동 계산                     │
│  ┌───────────────────────────┐ │
│  │   측정값 = 300 mm         │ │  ← isValid=false이면 회색 + "값 입력 대기"
│  └───────────────────────────┘ │
└───────────────────────────────┘
```

### 7.4 surface_type 선택 위젯 (`memberGap` 전용)

`start_surface_type`, `end_surface_type` 입력. 칩 그룹:
`wall_edge`, `column_edge`, `beam_edge`, `slab_edge`, `other`

기본값은 `wall_edge`. v0.2 우선순위: **선택 옵션은 노출하되 기본값으로 통과 가능**.

---

## 8. 업로드 API 마이그레이션

### 8.1 v1 (현재)
```
POST httpbin.org/post (mock)
multipart fields: id, surveyType, value, note, timestamp, photo
```

### 8.2 v2 (서버 담당자 협의 후)
```
POST {SERVER_BASE}/api/v1/records
Authorization: Bearer {API_KEY}
Content-Type: multipart/form-data

[탄산화]
  fields: 동일 + worker_id, app_version, os_version

[규격조사]
  fields:
    image_file: <file>
    annotation_json: <stringified JSON>   ← v0.1 §9 전송 템플릿
```

### 8.3 `UploadService` 마이그레이션 코드
```dart
Future<bool> uploadRecord(SurveyRecord r) async {
  final formData = FormData.fromMap({
    'id':           r.id,
    'survey_type':  r.surveyType.code,
    'subtype':      r.measurementSubtype?.code,
    'note':         r.note,
    'captured_at':  r.timestamp.toIso8601String(),
    'image_file':   await MultipartFile.fromFile(r.photoPath, filename: '${r.id}.jpg'),
    'annotation_json': r.annotation == null
        ? null
        : jsonEncode({
            'schema_version': '1.0',
            'survey_type':    r.surveyType.code,
            'measurement_subtype': r.measurementSubtype!.code,
            'device_id':      await _deviceId(),
            'captured_at':    r.timestamp.toIso8601String(),
            'image': { 'file_name': '${r.id}.jpg',
                        'width':  r.annotation!.imageWidth,
                        'height': r.annotation!.imageHeight,
                        'mime_type': 'image/jpeg' },
            'unit': 'mm',
            'annotation': r.annotation!.toJson(),
          }),
    'worker_id':    await _deviceId(),
    'app_version':  await _appVersion(),
    'os_version':   await _osVersion(),
  });
  ...
}
```

탄산화 레코드는 `annotation_json`이 null이므로 서버가 무시한다.

### 8.4 미확인 사항 (서버 담당자 확인)
v0.1 §10 그대로 + 다음을 추가:
- 한 endpoint(`/records`)에서 탄산화/규격조사 둘 다 처리할지, 분리할지
- `annotation_json`을 별도 form-field로 받을지 vs JSON request body로 보낼지

---

## 9. 검증/예외 처리 (S-013, 신규 표시 기준)

v0.1 §8 표를 그대로 사용하되, **표시 방식**을 명세한다.

| 검증 | 표시 방식 | 차단 여부 |
|------|----------|----------|
| `digits_clear=false` (사용자 자가 체크 또는 향후 자동) | `Get.dialog` 경고, [다시 촬영] / [계속 저장] 2개 버튼 | 비차단 |
| `both_edges_visible=false` | 측정점 지정 화면 진입 시 토스트 | 비차단 |
| `hole_lip_visible=false` | 기준점 미선택 시 "다음" 비활성화 | 차단 |
| `end_value <= start_value` | 수치 입력 화면 인라인 에러 + 측정값 카드 회색 | 차단 |
| 오프라인 | 메인 ON/OFF 배지 + 저장 시 토스트 "오프라인 상태입니다. 보관함에 저장합니다." | 비차단 |

---

## 10. 폴더 구조 (v2 완성 시)

```
lib/
├── pages/
│   ├── main/                      ← 카드 3개로 수정
│   ├── survey_type_select/        ← 신규
│   │   ├── survey_type_select_page.dart
│   │   └── survey_type_select_controller.dart
│   ├── camera/                    ← subtype 인자 추가
│   ├── annotate/                  ← 신규
│   │   ├── annotate_page.dart
│   │   └── annotate_controller.dart
│   ├── data_input/                ← 탄산화 전용 (변경 없음)
│   ├── dimension_input/           ← 신규
│   │   ├── dimension_input_page.dart
│   │   └── dimension_input_controller.dart
│   ├── archive/                   ← subtype 배지 추가
│   └── photo_viewer/
├── models/
│   ├── survey_record.dart            ← 확장
│   ├── measurement_subtype.dart      ← 신규
│   └── dimension_annotation.dart     ← 신규
├── services/
│   ├── storage_service.dart           ← 변경 없음 (fromJson 호환 처리)
│   └── upload_service.dart            ← annotation_json 추가
└── widgets/
    ├── guide_box_painter.dart         ← 모드 분기
    ├── marker_overlay.dart            ← 신규
    └── result_card.dart               ← 신규
```

---

## 11. 구현 단계 분할 (제안)

| Phase | 범위 | 산출물 |
|-------|------|-------|
| **P1** 모델/라우팅 골격 | enum/모델/라우트 추가, 메인 카드 3개 재편, S-002 화면 | 새 카드 클릭 시 빈 라우트로 이동까지 |
| **P2** 측정점 지정 | S-004 (폭/간격 공통) + 좌표 변환 + 마커 + S-003→S-004 사전 좌표 전달 (prefilledStart/End) | 두 점 찍고 다음으로 데이터 전달 |
| **P3** 수치 입력 (폭/간격) | S-005 (폭/간격 공통) + DimensionAnnotation 저장 + 키보드 buffer 처리 | 보관함에 dimension 레코드 노출 |
| **P4** 홀 깊이 | S-006/S-007/S-008 + ovalVertical 가이드 + visibleReadingValue | hole_depth subtype 전체 동작 |
| **P5** 업로드/보관함 | UploadService v2 마이그레이션, 보관함 subtype 배지, **수정 모달 subtype별 3종 분기 (탄산화/폭간격/홀깊이)**, 보관함 내 업로드 버튼 | 서버 일괄 전송 + subtype별 편집 |
| **P6** 품질/검증 강화 | 핀치 줌(photo_view), edge 인접 자동 플래그, 후처리 큐레이션 파이프라인 | 학습데이터 품질 ↑ |

P1~P3까지 통과하면 v2.0 MVP 릴리즈 가능. P4~P5는 v2.1, P6는 v2.2 권장.

---

## 12. 미해결 이슈 / 협의 필요

1. **메인 화면 메뉴 명칭**
   - "규격 조사"로 단일화 vs "규격 조사 (줄자 기반)"로 부제 표기? → 현 안: 단일 "규격 조사" + 부제 한 줄
2. **이미지 자산**
   - 메인/유형선택 카드 아이콘은 v0.2_design/assets/icons/ 에서 SVG로 제공됨. PNG 필요 시 변환 가이드는 [assets/README.md](v0.2_design/assets/README.md)
3. **photo_view 도입**
   - 측정점 지정 화면에서 핀치 줌 지원을 P2에 포함할지 P6로 미룰지
4. **서버 endpoint 분리 여부**
   - 탄산화/규격조사 한 API로 합칠지 분리할지 — 서버 담당자 회신 필요

---

## 부록 A. v0.1 → v0.2 화면 ID 매핑

| v0.1 ID | v0.2 라우트 | 비고 |
|---------|------------|------|
| S-001 | `/` (MainPage) | 기존 |
| S-002 | `/survey-type-select` | 신규 |
| S-003 (폭/간격) · S-006 (홀 깊이) | `/camera` (subtype arg) | 기존 + 확장 · 폭/간격 mockup 통합 (v0.2) |
| S-004 (폭/간격) · S-007 (홀 깊이) | `/annotate` (subtype arg) | 신규 · 폭/간격 mockup 통합 (v0.2) |
| S-005 (폭/간격) · S-008 (홀 깊이) | `/dimension-input` (subtype arg) | 신규 · 폭/간격 mockup 통합 (v0.2) |
| S-009 보관함 | `/archive` | 기존 + subtype 배지 + 수정 모달 3변형 분기 |

---

## 부록 B. 산출물 인덱스 (인도 자료)

| 파일 | 용도 | 비고 |
|------|------|------|
| [`v0.2_design/화면설계서_v0.2.html`](v0.2_design/화면설계서_v0.2.html) | 마스터 화면설계서 (9 mockup + 명세 통합) | 기획·디자인·개발 공통 |
| [`v0.2_design/플로우_v0.2.html`](v0.2_design/플로우_v0.2.html) | 인터랙티브 플로우 프로토타입 (postMessage 기반) | UX 검토·QA·개발자 동작 확인 |
| [`v0.2_design/mockups/S-001 ~ S-009.html`](v0.2_design/mockups/) | 9개 화면 단독 mockup + 명세 | 개발자 픽셀·코드 값 참조 |
| [`v0.2_design/mockups/_embed.js`](v0.2_design/mockups/_embed.js) | **프로토타입 전용** 임베드 스크립트 | 실제 앱 코드에 포함하지 않음 |
| [`v0.2_design/assets/icons/`](v0.2_design/assets/icons/) | SVG 아이콘 6종 + [`README.md`](v0.2_design/assets/README.md) | 메인 카드·가이드 분기 |
| [`screen_spec_v0.2.md`](screen_spec_v0.2.md) (이 문서) | 코드 레벨 명세 (Flutter 위젯 트리·데이터 모델·라우팅·좌표 변환) | 개발자 구현 기준 |

**인터랙티브 프로토타입 사용 방법**
1. 브라우저에서 [`플로우_v0.2.html`](v0.2_design/플로우_v0.2.html) 열기 (file://, 또는 로컬 HTTP 서버)
2. 좌측 사이드바·우측 액션 패널·중앙 폰 모두 인터랙션 가능
3. **S-003에서 좌·우 핸들을 안쪽으로 드래그** → 셔터 탭 → **S-004 화면에 그 좌표 그대로 마커·edge 선이 표시되는지 확인** (사전 좌표 연속성)
4. **S-009 보관함에서 카드의 "수정" 탭** → 카드 subtype별로 다른 모달 (S-009E/Ed/Eh)이 열리는지 확인

**프로토타입과 실제 앱의 차이**
- 프로토타입은 HTML/JS만으로 시각화. 실제 앱은 Flutter 위젯으로 구현
- 좌표 변환은 프로토타입에서 viewBox(360×380) 기준의 단순화. 실제 앱은 BoxFit.contain 기반 원본 이미지 좌표(예: 1440×1080) 변환 적용
- 사전 좌표 전달: 프로토타입은 URL 쿼리(`?startX=80&endX=280`), 실제 앱은 Get 인자 (`prefilledStart` / `prefilledEnd`)
