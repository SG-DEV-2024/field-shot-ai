# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**현장촬영AI (FieldShotAI)** - 현장 측정값 사진 촬영 및 AI 데이터 수집 앱

- Android/iOS 지원 (Portrait 고정)
- 버니어 캘리퍼스 등 측정값 촬영 + 수치 입력
- 기울기 센서(SMA 보정)로 수평 가이드 제공
- 로컬 저장 후 서버 일괄 업로드

**GitHub**: https://github.com/SG-DEV-2024/field-shot-ai

## Architecture

### State Management
- **GetX** 사용 (상태 관리, 라우팅, DI)
- Controllers: `GetxController` 확장, `.obs` 반응형 변수

### 폴더 구조
```
lib/
├── pages/
│   ├── main/
│   │   ├── main_page.dart          # 메인 화면
│   │   └── main_controller.dart    # 연결 상태, 업로드, 통계
│   ├── camera/
│   │   ├── camera_page.dart        # 촬영 화면 (가이드박스, 크로스헤어)
│   │   └── camera_controller.dart  # 카메라, 기울기 센서, 줌, 플래시
│   ├── data_input/
│   │   ├── data_input_page.dart    # 수치 입력 화면
│   │   └── data_input_controller.dart
│   ├── archive/
│   │   ├── archive_page.dart       # 보관함 화면
│   │   └── archive_controller.dart
│   └── photo_viewer/
│       └── photo_viewer_page.dart  # 전체화면 사진 뷰어
├── models/
│   └── survey_record.dart          # SurveyRecord, SurveyType, UploadStatus
├── services/
│   ├── storage_service.dart        # 로컬 JSON 저장
│   └── upload_service.dart         # 서버 업로드 (현재 mock)
├── routes/
│   └── app_pages.dart              # GetX 라우팅
├── index.dart                      # 전역 exports
└── global.dart                     # cameras 전역 변수
```

### 데이터 저장 구조
```
Documents/capture/
├── records.json        # 조사 기록 전체 (JSON 배열)
└── photos/
    └── {timestamp}.jpg # 촬영 사진
```

### 기울기 센서 (SMA 방식)
- `accelerometerEventStream()` → 중력벡터 정규화 → SMA 윈도우 5샘플
- 수평 임계값: 15도 (녹색), 잠금 임계값: 16도 (빨간색 + 셔터 잠금)
- 데드존: 1.5도 이하 → 0으로 처리 (미세 떨림 제거)

## Development Commands

```bash
# 개발 실행
flutter run -d R5CN406R15D           # Android 기기

# 릴리즈 빌드
flutter build apk --release

# release 폴더에 복사 + ZIP 생성
mkdir -p release
cp build/app/outputs/flutter-apk/app-release.apk release/FieldShotAI-v{버전}.apk
cd release && zip FieldShotAI-v{버전}.zip FieldShotAI-v{버전}.apk

# 의존성
flutter pub get
flutter clean && flutter pub get
```

**중요: 핫 리로드 미지원** — 변경 후 반드시 `flutter run` 재실행

## Key Technologies

- Flutter SDK 3.2.6+
- GetX ^5.0.0-release-candidate-9.3.2 (상태 관리)
- camera 0.11.3 (camera_android_camerax: 0.6.29 override)
- sensors_plus ^4.0.2 (가속도계)
- connectivity_plus ^6.1.3 (인터넷 상태)
- dio ^5.4.0 (HTTP 업로드)
- path_provider ^2.1.5

## Important Conventions

### 버전 규칙
**형식**: `MAJOR.MINOR.PATCH+N` (빌드번호는 단순 증가)

```yaml
version: 1.0.0+1
```

### Portrait 고정
- AndroidManifest.xml `MainActivity`에 `android:screenOrientation="portrait"` 설정
- `main.dart`에서 `SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])` 이중 설정

### 업로드 Mock
- `UploadService`: `httpbin.org/post`에 multipart 업로드, 1초 delay 포함
- 실제 서버로 교체 시 `upload_service.dart`의 URL과 파라미터 변경

### 메인 화면 통계
- 오늘 날짜 기준 필터링 (`todayRecords`)
- records.json에는 전체 누적 데이터 저장

## Common Gotchas

1. **camera_android_camerax 버전**: 0.6.29 override 필요 (0.6.30 크래시)
2. **GetX snackbar**: GetX 5.x에서 `Get.snackbar` 작동 안 함 → `ScaffoldMessenger.of(Get.context!).showSnackBar()` 사용
3. **Obx 스코프**: observable을 Obx 클로저 내부에서 직접 읽어야 함

## TODO (PDF 기획서 미구현 항목)

> 기준 문서: `현장촬영앱_ver1.0_260316.pdf`

### 촬영 화면
- [ ] **터치 포커스 링**: 화면 터치 시 노란색 링 표시 (AF + 노출 조정 영역 표시)
- [ ] **밝기 경고**: 조도 센서(lux)로 어두운 환경 감지 시 하단에 "플래시를 켜주세요" 팝업 표시
- [ ] **줌 1x~5x 확장**: 현재 1x/2x/3x → 5x까지 지원 (기기 최대 줌에 clamp)
- [ ] **핀치줌 (데이터입력 화면)**: 촬영된 사진에서 두 손가락 확대/축소 지원 (낮은 우선순위)

### 업로드 API
- [ ] **실제 API 연동**: 현재 httpbin.org mock → 실제 서버 URL + API Key 인증 적용
- [ ] **업로드 페이로드 완성**: PDF 기준 필수 필드 추가
  - `record_id`: 고유 식별자 (현재 timestamp ID → UUID 검토)
  - `worker_id`: 작업자/기기 ID (현재 미포함)
  - `device_info`: OS 버전, 앱 버전 정보 (현재 미포함)
  - `ground_truth.measured_value`: 측정값 (현재 `value`로 전송 중)

### 보관함 화면
- [ ] **보관함 내 업로드 버튼**: PDF 기준 보관함에도 "미전송 N건 업로드" 버튼 추가

### 향후 버전 (v2)
- [ ] **배근 간격 조사**: 줄자 수치 인식 (현재 "서비스 준비 중" 비활성화)

---

## 서버 API 명세 (업로드)

> 서버 담당자에게 전달한 스펙 기준 (2026-03-23)

### POST /api/v1/records — 단건 업로드

```
Content-Type: multipart/form-data
Authorization: Bearer {API_KEY}   ← 인증 방식 협의 필요
```

**Request 필드 (multipart/form-data)**

| 필드명 | 타입 | 필수 | 설명 | 예시 |
|--------|------|------|------|------|
| `id` | string | ✅ | 레코드 고유 ID (timestamp 기반, 향후 UUID 전환 예정) | `"1742700123456"` |
| `survey_type` | string | ✅ | 조사 종류: `carbonation` / `rebarSpacing` | `"carbonation"` |
| `values` | string (JSON array) | ✅ | 측정값 목록 | `"[12.5, 13.0]"` |
| `note` | string | ✅ | 비고 (없으면 빈 문자열) | `"3층 북측 벽면"` |
| `timestamp` | string (ISO 8601) | ✅ | 촬영 시각 | `"2026-03-23T14:32:00+09:00"` |
| `photo` | file (JPEG) | ✅ | 촬영 이미지 (파일명: `{id}.jpg`) | binary |
| `worker_id` | string | ⬜ | 작업자/기기 식별자 (추후 추가 예정) | `"device-abc123"` |
| `app_version` | string | ⬜ | 앱 버전 | `"1.0.0"` |
| `os_version` | string | ⬜ | OS 버전 | `"Android 14"` |

**Response**

```json
// 성공 (HTTP 200)
{ "success": true, "record_id": "1742700123456" }

// 실패 (HTTP 400/500)
{ "success": false, "error": "invalid_survey_type" }
```

### 앱 연동 시 변경 필요 사항 (`upload_service.dart`)
- URL: `httpbin.org/post` → 실제 서버 엔드포인트
- `value` (double 단일값) → `values` (JSON array string)로 필드명/타입 변경
- Authorization 헤더 추가
- `worker_id`, `app_version`, `os_version` 필드 추가

### 미확인 사항 (서버 담당자 확인 필요)
1. 인증 방식 — API Key / JWT / 없음?
2. `values` 포맷 — JSON array string vs 별도 필드?
3. HTTP 200이면 성공 처리? 또는 body의 `success` 필드도 체크?
4. 이미지 용량 제한?

---

## Change Log

### 2026-03-17: v1.0.0 최초 릴리즈

**앱 기본 구조:**
- 메인/촬영/데이터입력/보관함/사진뷰어 5개 화면
- GetX 라우팅, 로컬 JSON 저장, mock 서버 업로드

**촬영 화면:**
- 점선 사각형 + 점선 원 가이드박스 (CustomPainter)
- 크로스헤어: 수평 시 녹색, 기울어지면 빨간색
- 기울기 SMA(5샘플) + 중력벡터 정규화 방식
- 줌 1x/2x/3x, 플래시 Auto/On/Off
- 15도 이내 수평 OK, 16도 초과 셔터 잠금
- 썸네일 탭 → 보관함 이동

**메인 화면:**
- 인터넷 ON(녹색)/OFF(회색) 배지
- 오늘 수집 현황 카드 (3칸 구분)
- 미전송 건 일괄 서버 업로드 버튼

**Android:**
- `screenOrientation="portrait"` AndroidManifest 레벨 고정

## 커밋 히스토리

- Android 서명 키스토어 생성 (_keys/field-shot-ai.jks) 및 build_release.sh 추가 (v1.0.1)

---

## 2026-06-04 작업 기록 — 규격조사(dimension) 모듈 구현 + 카메라 버그 규명

> 브랜치: `feat/dimension-survey` (origin 푸쉬됨, HEAD `4d4c00d`). main은 건드리지 않음.
> `_doc/` 은 이번에 `.gitignore` 추가됨(참고 문서, 빌드 무관, git 미추적).

### A. 이번 세션에 구현/커밋된 것 (origin/feat/dimension-survey)

커밋 4개:
1. `feat: 규격조사 모듈 추가 + 탄산화 v0.2 디자인 (S-001~S-009 / C-001~C-003)`
2. `fix(ui): 카메라 폭/간격 가이드 렌더링 버그 수정 + 보관함 모달 chip 색 분기`
3. `refactor(theme): §4 디자인 시스템 12색을 AppColors 전역 토큰으로 분리`
4. `feat(ui): §4 디자인 시스템 SVG 아이콘 적용 (메인/유형선택 카드)`

산출물 (모두 `screen_spec_v0.2.md` 기반):
- **신규 모델**: `lib/models/measurement_subtype.dart`(폭/간격/홀깊이 + cameraHint/description/shortLabel), `lib/models/dimension_annotation.dart`(좌표·수치·QualityFlags). `survey_record.dart` 확장 — `SurveyType.dimension` 추가(`rebarSpacing`→`dimension` 호환 매핑), `measurementSubtype`/`annotation` nullable 필드. JSON은 `.code` 저장(기존 탄산화 레코드 그대로 로드).
- **신규 화면**: `survey_type_select`(S-002), `annotate`(S-004/S-007, 마커 드래그+탭, BoxFit.contain preview↔원본픽셀 변환, 홀깊이 라디오), `dimension_input`(S-005/S-008, 자동계산/단일값, 저장 후 카메라 복귀).
- **카메라 확장**: subtype 인자, 규격조사 자세잠금 미적용(`_initTiltSensor` 조기 return), 모드별 가이드(`GuideBoxMode`), 폭/간격 핸들→사전좌표, 촬영 후 `dart:ui`로 이미지 크기 읽어 subtype별 라우팅. 위젯: `lib/widgets/guide_box_painter.dart`.
- **메인**: 카드 2→3(탄산화/규격/배근), 설정 버튼 제거. **데이터입력**: 단일 "저장 후 계속 촬영"(v0.2). **보관함**: subtype 배지 + 수정 모달 3변형.
- **업로드**: `uploadRecord(SurveyRecord)` + 규격조사 `annotation_json`.
- **색 토큰**: `lib/theme/app_colors.dart` (Tailwind 가중치 네이밍: `blue600/blue800/blue50, red500/red600, yellow400, amber500/amber100, green600/green100, ink900/ink500`). `index.dart`에서 전역 export. §4 12색 + near-dup 5종(0xE0DC2626→red600α, 0F172A/1A2332→ink900, FBBF24→yellow400, 1E3A8A→blue800) 치환. `Color(0x` 리터럴 105→52(나머지는 중립 회색 등 §4 밖). `#22C55E`(크로스헤어)는 `kGuideGreen`로 유지.
- **SVG 아이콘**: `assets/icons/`(6종) + `flutter_svg`. 메인 caliper/tape/crack, 유형선택 subtype_width/gap/hole. HTML mockup 기준 흰박스 없이 투명 슬롯에 네이티브 크기(메인 36, subtype 44) 1:1, 비활성 카드 opacity 0.45.

### B. ✅ [수정 완료 2026-06-05] 규격조사 카메라 "뿌연 막" 버그 — 근본 원인 규명 + 수정·검증 완료

**증상**: 규격조사 카메라 3종(폭/간격/홀깊이) 전부 — 프리뷰 위쪽 일부 band만 정상, 나머지 큰 영역이 연회색으로 뿌옇게 + 가이드/핸들 흐릿. 탄산화 카메라는 **같은 장면에서 완전 정상**.

**근본 원인 (디버그 빌드 빨간 에러 화면으로 확정)**:
> `[Get] the improper use of a GetX has been detected. You should only use GetX or Obx for the specific widget that will be updated...`
> = Obx 빌더 안에서 observable(`.value`)을 **하나도 안 읽으면** 나는 GetX 예외.

위치: `lib/pages/camera/camera_page.dart` 의 `_HintBubble`:
```dart
return Obx(() {
  final locked = !ctrl.isDimension && ctrl.isLocked.value;  // ← 문제
  ...
});
```
- 규격조사: `isDimension==true` → `!isDimension==false` → Dart `&&` **단락평가**로 `ctrl.isLocked.value`를 **안 읽음** → Obx가 추적할 observable 0개 → GetX 예외.
- **릴리즈 모드에선 위젯 빌드 예외가 회색 ErrorWidget로 렌더됨** → 그게 "뿌연 막"의 정체. (디버그에선 빨간 에러 화면)
- 탄산화: `!isDimension==true` → `isLocked.value`를 읽음 → 정상. → **"규격조사 세개만" 깨진 이유 정확히 설명됨.**

**수정안 (내일 적용)**: Obx가 항상 observable을 읽게.
```dart
return Obx(() {
  final lockedNow = ctrl.isLocked.value;          // 항상 읽기
  final locked = !ctrl.isDimension && lockedNow;
  ...
});
```

**같이 점검할 것**: `&&`/`||` 뒤에서만 `.value`를 읽어 단락평가로 안 읽힐 수 있는 Obx 전수 점검(전 화면).
- 카메라 셔터 Obx는 `ctrl.isCapturing.value || (...)` 로 첫 항을 항상 읽어 **안전**.
- **annotate 화면**: 같은 류 확정됨 — 진범은 `_photoArea`가 아니라 **`_hintCard`**. 폭/간격 모드에서 `if (!ctrl.isHole) { text = '정적문구'; }` 분기가 observable을 0개 읽어 throw. 그 `RenderErrorBox`가 `Column`의 무한 세로 제약을 받아 부풀며 위의 `Expanded(_photoArea)`를 높이 0으로 짜부 → "사진 영역이 회색 + BOTTOM OVERFLOWED"로 보였던 것. (`_photoArea`는 `addMarker(startPoint.value,…)` 인자에서 observable을 읽어 원래 정상이나, 방어적으로 상단 읽기 추가함.)

**삽질 기록 (효과 없던 시도 — 반복 금지)**: 원인을 "프리뷰 렌더/리페인트"로 오판하고 시도했으나 전부 무효였음:
1. `_LivePreview` (AnimatedBuilder로 매 프레임 CameraPreview 재빌드)
2. `_CoverPreview` (previewSize 기반 `BoxFit.cover`)
3. `_RepaintTicker` + `_PulsePainter` (전체화면 CustomPaint 매 프레임 paint 강제)
→ 셋 다 무효. 진짜 원인은 GetX Obx 예외.

**수정 완료 내역 (2026-06-05)**:
1. `camera_page.dart`: 실험 위젯 `_RepaintTicker`/`_PulsePainter` + Stack의 child 제거. 프리뷰는 `_CoverPreview`(previewSize 기반 BoxFit.cover) 유지.
2. `camera_page.dart` `_HintBubble`: `final lockedNow = ctrl.isLocked.value;`를 **무조건 먼저 읽고** `locked = !ctrl.isDimension && lockedNow;` — 단락평가 회피.
3. `annotate_page.dart` `_hintCard`: `final step = ctrl.currentStep;`를 상단에서 무조건 호출(두 모드 모두 observable 읽음) 후 switch에서 `step` 사용.
4. `annotate_page.dart` `_photoArea`: 좌표 observable 4종(start/end/lip/tape)을 Obx 상단에서 무조건 읽고 addMarker에 전달(방어).

**전수 점검 결과**: 단락평가로 observable 미접근 위험은 `_HintBubble`/`_hintCard` 둘뿐이었음. 셔터 Obx(`isCapturing.value || …`), archive 업로드(`isUploading.value` 무조건), main(`pendingCount.value` 첫항), dimension_input/data_input(`isValid.value` 상단) 전부 안전.

**기기 검증 완료 (SM-A516N 디버그, `adb` 자동 구동 + 스크린샷)**: 규격 폭 카메라(프리뷰 선명·안내버블·핸들) → 폭 annotate(사진+시작/끝 마커+안내) → 폭 수치입력(자동계산 12−10=2mm reactive) / 홀 카메라(세로타원+십자) → 홀 annotate(기준점지정·단계안내·라디오) / 탄산화 카메라(안내버블+녹색 크로스헤어, 회귀 없음) — **전부 정상, GetX 예외·overflow 0건**.

> 주의: monkey LAUNCHER는 기존 태스크를 **복귀**시킴(메인 재시작 아님). 깨끗한 상태 필요 시 `adb shell am force-stop` 후 `am start -n com.sgits.proj2602a/.MainActivity`.

### C. 빌드/기기/설치 메모
- 기기: **SM-A516N** (adb id `R5CN406R15D`), Android 13. 패키지명 **`com.sgits.proj2602a`** (디렉토리명 proj2603b와 다름).
- 폰의 기존 설치본은 **현재 `_keys/field-shot-ai.jks`와 다른 키로 서명** → `adb install -r`(릴리즈/디버그 모두) **서명 불일치로 덮어쓰기 불가**. 새 빌드 올리려면 `adb uninstall com.sgits.proj2602a` 후 설치(=앱 데이터 삭제). 2026-06-04 사용자 동의로 삭제·재설치함.
- **현재 폰엔 디버그 빌드 설치 상태**(진단용, 빨간 에러 화면 확인됨). 신규 설치라 런타임 권한 재요청 → 카메라 테스트 자동화 전 `adb shell pm grant com.sgits.proj2602a android.permission.CAMERA` 부여(권한 다이얼로그가 input tap 가로채는 것 방지).
- 설치는 항상 `adb install --user 0`(듀얼앱 복제 방지). 빌드만 flutter, 설치는 adb (글로벌 컨벤션).
- 디버그 logcat에 보이는 `flutter`(pid 다름) 로그는 **다른 SG 앱 `com.sgits.proj2605a`(geotick)** 것 — 혼동 주의. 본 앱 로그/예외만 필터링할 것.
- standalone(`am start`/monkey) 실행 시 본 앱 flutter 로그가 logcat에 안 잡힘. monkey LAUNCHER는 기존 태스크 **복귀**(메인 재시작 아님) → 깨끗한 상태는 `am force-stop` 후 `am start -n com.sgits.proj2602a/.MainActivity`.

---

## 2026-06-05 작업 기록 — annotate 마커 개편 + 1:1 정사각 디자인

> 브랜치 `feat/dimension-survey`. annotate(측정점/기준점 지정) 화면을 §A 목업(S-004/S-007)에 맞춰 개편.

### 완료 (미커밋, 검증됨)
- **마커 3요소 분리** (`annotate_page.dart` + `annotate_controller.dart`): 측정 지점(point 16px ●) + 라벨(pill) + stem(점선) 각각 독립. point 드래그=좌표변경+라벨 동반 / label 드래그=라벨만 이동(줄자 가림 회피) / stem 자동 갱신. 컨트롤러에 `startLabel/endLabel/holeLipLabel/tapeReadingLabel` 추가, `_movePair`/`_moveLabel`/`_moveNearestPair`/`_autoLabel`.
- **찍고 이어끌기**: 사진 빈 곳 `onPanStart`=그 자리 생성/선택 + `onPanUpdate`=`dragActiveTo`로 같은 제스처에서 바로 끌기. `onTapUp`=탭 배치(아레나 상호배타로 중복 없음). 컨트롤러 `_activePoint/_activeLabel` + `dragActiveTo`.
- **사진 1:1 정사각 + cover(꽉 채움, 잘림)**: `_photoFrame`이 `AspectRatio(1)` + 둥근 테두리 카드. 좌표변환 `toPreview/toOriginal/scaleFor`를 `math.min`(contain)→`math.max`(cover)로 변경. ⚠️ cover라 잘린 영역엔 측정점 못 찍음(사용자 선택). 세로(portrait) 사진은 상하 크롭이라 폭 마커(중앙)는 보존됨.
- **하단 카드형 개편**: `_StepCard`(번호 원+완료 ✓) — 폭/간격=시작(blue)·끝(red, 항상 done), 홀=①입구·②읽기. 카드는 **미배치=회색톤 / 배치=마커색톤**(①주황·②파랑: 배경·테두리·번호·체크 전부). 홀 `_RadioCard` ③가시성·④접촉(미선택 회색→선택 시 초록). appBar에 subtype 칩 추가.
- **점·라벨 프레임 내 clamp (cover 가시영역)**: 페이지가 `setPreviewSize`로 프레임 크기 전달 → 컨트롤러 `_visibleRect()`(cover 뷰포트)·`_clampPoint`/`_clampLabel`로 점·라벨을 보이는 영역 안에 가둠. `_autoLabel`은 위/아래 중 공간 있는 쪽 선택. **stem이 프레임 밖으로 안 나감**(웹 `toViewBox` clamp 대응). 초기 배치 + 드래그 모두 적용.

### 🔜 다음 작업 예정 (TODO)
- [ ] **메인/유형선택 카드 ink 터치 효과**: 메인(`main_page.dart`) 탄산화·규격 조사 카드 + 유형선택(`survey_type_select`) 폭/간격/홀 3개 카드를 `InkWell`/`Material`로 감싸 탭 시 ripple(잉크) 피드백. (현재 `GestureDetector`라 터치 반응 없음)
- [ ] **annotate 돋보기(확대 보기)**: 규격조사 보정 화면(S-004/S-007)에 탄산화처럼 돋보기 버튼/핀치줌 추가(목업 `.magnify-btn` 우하단, P6 `photo_view` 예정). 작은 측정점 정밀 배치용.
- [x] ~~마커 라벨 이름 정확히 수정~~ → 완료: 폭/간격 `시작면`/`끝면`, 홀 깊이 `홀 입구`/`읽기 위치`.
- [x] ~~(선택) annotate 라벨 초기 위치 cover 보정~~ → 완료: 위 "점·라벨 프레임 내 clamp" 참조.
