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
