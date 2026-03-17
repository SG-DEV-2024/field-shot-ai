# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**사진모아 (Photo More)** - 간단한 사진 촬영 및 관리 앱

- iOS/Android 지원
- 날짜별 폴더로 사진 자동 정리
- 촬영 시 플래시 효과 + 진동 피드백
- 사진 뷰어 (확대/축소, 이전/다음 탐색)

**GitHub**: https://github.com/SG-DEV-2024/photo-more

## Architecture

### State Management
- **GetX** 사용 (상태 관리, 라우팅, DI)
- Controllers: `GetxController` 확장, `.obs` 반응형 변수

### 폴더 구조
```
lib/
├── pages/camera/
│   ├── photo.dart              # 메인 카메라 화면
│   ├── photo.controller.dart   # 카메라 컨트롤러
│   ├── photo_viewer.dart       # 사진 뷰어 화면
│   ├── date_folders.dart       # 사진 보관함 (앨범+날짜 통합, 최신순)
│   ├── albums/
│   │   ├── albums_store.dart   # 앨범 메타데이터 관리
│   │   └── move_dialog.dart    # 사진 이동 대화상자
│   ├── capture/
│   │   ├── manifests_store.dart  # 날짜 폴더 메타데이터 관리
│   │   └── shot_saver.dart       # 사진 저장 로직
│   ├── dropbox/
│   │   └── dropbox_service.dart  # Dropbox OAuth + 업로드
│   └── gdrive/
│       └── gdrive_service.dart   # Google Drive OAuth + 업로드
├── index.dart                  # 전역 exports
├── global.dart                 # 전역 변수/상수
└── routes/                     # GetX 라우팅
```

### 사진 저장 구조
```
Documents/capture/
├── manifests.json              # 날짜 폴더 메타데이터
├── dates/
│   ├── 2026-02-11/
│   │   ├── items.jsonl         # 사진 메타데이터
│   │   └── 20260211_143052_xxx.jpg
│   └── 2026-02-10/
│       └── ...
└── albums/
    ├── albums.json             # 앨범 메타데이터
    ├── 여행/
    │   └── 20260211_143052_xxx.jpg
    └── 가족/
        └── ...
```

## Development Commands

```bash
# 개발
flutter run                          # 연결된 기기에서 실행
flutter run -d R5CN406R15D           # Android 기기 지정
flutter run -d 00008110-xxx          # iPhone 기기 지정

# 빌드
flutter build ios --release
flutter build apk --release

# 의존성
flutter pub get
flutter clean && flutter pub get     # 문제 시 클린 빌드
```

**중요: 핫 리로드 미지원**
- 이 프로젝트에서는 핫 리로드가 동작하지 않음
- 코드 변경 후 반드시 앱 재실행 필요 (`flutter run` 다시 실행)

### iOS 빌드 문제 해결
```bash
cd ios && rm -rf Pods Podfile.lock && pod install && cd ..
```

### Release Build

릴리즈 파일 요청 시 아래 절차를 따른다:

```bash
# 1. Android 빌드
flutter build apk --release

# 2. release 폴더에 복사 + ZIP 생성
mkdir -p release
cp build/app/outputs/flutter-apk/app-release.apk release/PhotoMore-v{버전}.apk
cd release && zip PhotoMore-v{버전}.zip PhotoMore-v{버전}.apk
```

| 파일 | 경로 |
|------|------|
| APK | `release/PhotoMore-v{버전}.apk` |
| ZIP | `release/PhotoMore-v{버전}.zip` |

```bash
# iOS 빌드 (필요시)
flutter build ios --release
```

## Key Technologies

- Flutter SDK 3.2.6+
- GetX (상태 관리)
- camera 0.11.3 (카메라)
- path_provider (파일 경로)
- permission_handler (권한)

## Important Conventions

### 버전 규칙

**버전 형식**: `MAJOR.MINOR.PATCH+YYMMDDHH`

```yaml
version: 1.0.0+26021107
```

| 부분 | 예시 | 의미 |
|------|------|------|
| `1.0.0` | 앱 버전 | 사용자에게 보이는 버전 (시맨틱 버저닝) |
| `26` | 2026년 | 연도 (YY) |
| `02` | 2월 | 월 (MM) |
| `11` | 11일 | 일 (DD) |
| `07` | 7시 | 시 (HH) |

**주의**: Android versionCode는 2,147,483,647 이하여야 함 (10자리 불가, 8자리 사용)

**프로젝트명 규칙**: `proj{YYMM}{순서}`
- 예: `proj2602a` → 2026년 2월 첫 번째 프로젝트

### 촬영 효과
```dart
// 플래시 + 사운드 + 진동
_showFlash.value = true;
SystemSound.play(SystemSoundType.click);
HapticFeedback.mediumImpact();
Future.delayed(const Duration(milliseconds: 150), () {
  _showFlash.value = false;
});
```

### 날짜 폴더 관리
```dart
// 오늘 폴더 가져오기/생성
final folder = await ManifestsStore.I.getOrCreateTodayFolder();

// 사진 저장
final result = await ShotSaver.I.ingest(srcPath: file.path, text: '');

// 파일 시스템과 동기화 (reload 시 자동 실행)
await ManifestsStore.I.reload();
```

### 앨범 관리
```dart
// 앨범 생성
await AlbumsStore.I.createAlbum('여행');

// 앨범 목록 (최신순)
final albums = AlbumsStore.I.listAlbumsNewestFirst();

// 앨범 이름 변경
await AlbumsStore.I.renameAlbum('여행', '2026 여행');

// 앨범 삭제
await AlbumsStore.I.deleteAlbum('여행');

// 파일 시스템과 동기화
await AlbumsStore.I.reload();
```

## Common Gotchas

1. **camera_android_camerax 버전**: 0.6.29 override 필요 (0.6.30은 크래시)
2. **iOS 설치 느림**: 첫 연결 시 심볼 캐시 복사로 오래 걸림
3. **SystemSound**: Android에서 잘 안 들림, iOS는 정상

## Dropbox 연동

### 구현 완료 (2026-02-11)
- **인증**: OAuth 2.0 + PKCE (client_secret 불필요)
- **패키지**: `dio`, `flutter_web_auth_2`
- **저장 경로**: `/사진모아/{날짜}/파일명.jpg`

### 주요 파일
```
lib/pages/camera/dropbox/
└── dropbox_service.dart    # OAuth + 업로드 API
```

### 설정
- **App Key**: Dropbox App Console에서 발급
- **Redirect URI**: `proj2602a://oauth`
- Android: `AndroidManifest.xml`에 `CallbackActivity` 추가
- iOS: `Info.plist`에 `CFBundleURLTypes` 추가

### 주의사항
- **HTTP 헤더 한글**: `Dropbox-API-Arg` 헤더에 한글 사용 시 `\uXXXX`로 이스케이프 필요
- **토큰 만료**: Access Token은 4시간, Refresh Token으로 자동 갱신

## Google Drive 연동

### 구현 완료 (2026-02-11)
- **인증**: `google_sign_in` 패키지 (네이티브 OAuth)
- **패키지**: `google_sign_in`, `googleapis_auth`, `dio`
- **저장 경로**: `사진모아/{날짜}/파일명.jpg`

### 주요 파일
```
lib/pages/camera/gdrive/
└── gdrive_service.dart    # Google Sign-In + Drive API
```

### 설정

#### Google Cloud Console
1. OAuth 동의 화면 설정 (테스트 사용자 추가)
2. OAuth 2.0 클라이언트 생성:
   - **Android**: 패키지명 + SHA-1 지문
   - **iOS**: Bundle ID

#### Android 설정
- `AndroidManifest.xml`에 OAuth 콜백 intent-filter 추가
```xml
<intent-filter android:label="google_oauth">
    <action android:name="android.intent.action.VIEW"/>
    <category android:name="android.intent.category.DEFAULT"/>
    <category android:name="android.intent.category.BROWSABLE"/>
    <data android:scheme="com.googleusercontent.apps.{CLIENT_ID}"/>
</intent-filter>
```

#### iOS 설정
1. `GoogleService-Info.plist`를 Xcode 프로젝트에 추가
2. `Info.plist`에 reversed client ID URL scheme 추가
```xml
<dict>
    <key>CFBundleURLSchemes</key>
    <array>
        <string>com.googleusercontent.apps.{CLIENT_ID}</string>
    </array>
</dict>
```

### 주의사항
- **Android**: Client ID가 코드에 없음 (패키지명 + SHA-1로 자동 식별)
- **iOS**: `GoogleService-Info.plist` 필수 (Xcode에서 직접 추가)
- **Scope**: `drive.file` (앱이 생성한 파일만 접근)

## Change Log

### 2026-02-12: UI 통합 및 로그인 개선

**UI 변경:**
- 탭 제거: 날짜별/앨범 탭을 통합 리스트로 변경 (최신순 정렬)
- 아이콘 통일: 날짜폴더 🗓️, 앨범 📁 이모지 사용
- FAB 스타일: "새 앨범" 버튼을 서비스 버튼과 동일한 스타일로 변경 (#F57F17 진한 노랑)
- 갱신 버튼 제거: AppBar에서 불필요한 새로고침 버튼 제거

**로그인 개선:**
- 로그인 중 취소 버튼 추가 (Dropbox, Google Drive)
- 로그아웃 시 모든 대화상자 닫기 (return 'logout' → 부모 대화상자도 종료)
- `_isLoggedIn` 플래그 추가: OAuth 콜백 후 `currentUser`가 바로 설정되지 않는 문제 해결
  - `GDriveService`: `_isLoggedIn` 플래그로 로그인 상태 즉시 반영
  - `DropboxService`: 동일한 패턴 적용
- `flutter_web_auth_2` 버전 업그레이드: ^4.0.0 → ^5.0.1

**기능 개선:**
- Google Drive 세션 복원: `tryRestoreSession()` 메서드 추가
- 앨범 `updatedAt` 추적: 파일 추가 시 자동 업데이트, 최신순 정렬에 반영
- 폴더명 검증: `sanitizeFolderName()` 함수로 금지 문자/길이 제한
  - 금지 문자: `/ \ < > : " | ? *`, 제어 문자 (0-31, 127)
  - 길이 제한: 80자
- 클라우드 경로 단순화: `사진모아/앨범/{앨범명}/` → `사진모아/{앨범명}/`
- 갤러리 내보내기: 단일 폴더 선택 시 해당 폴더명을 앨범명으로 사용

**수정된 파일:**
- `lib/pages/camera/date_folders.dart`: 통합 리스트, FAB 스타일, 폴더명 검증, 로그인 대화상자 개선
- `lib/pages/camera/albums/albums_store.dart`: `updatedAt` 필드, `touchAlbum()` 메서드
- `lib/pages/camera/albums/move_dialog.dart`: 통합 리스트 적용
- `lib/pages/camera/gdrive/gdrive_service.dart`: `tryRestoreSession()`, `_isLoggedIn` 플래그
- `lib/pages/camera/dropbox/dropbox_service.dart`: `_isLoggedIn` 플래그
- `pubspec.yaml`: flutter_web_auth_2 ^5.0.1로 업그레이드

### 2026-02-11: 앨범 기능 추가

**새 기능:**
- 앨범 생성/삭제/이름변경
- 사진 보관함 탭 UI (날짜별 / 앨범)
- 사진 선택 모드 (길게 눌러 진입)
- 선택한 사진 이동 (날짜폴더 ↔ 앨범)
- 선택한 사진 일괄 삭제
- 메타데이터 자동 동기화 (실제 파일 수 반영)

**새 파일:**
- `lib/pages/camera/albums/albums_store.dart`
- `lib/pages/camera/albums/move_dialog.dart`

**수정된 파일:**
- `lib/pages/camera/date_folders.dart`: 탭 구조, 선택 모드 추가
- `lib/pages/camera/photo_viewer.dart`: 삭제 후 결과 반환
- `lib/pages/camera/capture/manifests_store.dart`: 파일 시스템 동기화

### 2026-02-11: Google Drive 연동

**새 기능:**
- Google Drive OAuth 로그인 (`google_sign_in` 패키지)
- 사진 Google Drive 업로드 (날짜별 폴더)
- 대화상자 크기 확대 (화면 80% 높이, 95% 너비)

**새 파일:**
- `lib/pages/camera/gdrive/gdrive_service.dart`
- `lib/pages/camera/date_folders.dart` (photo.dart에서 분리)
- `ios/Runner/GoogleService-Info.plist`

**수정된 파일:**
- `pubspec.yaml`: google_sign_in, googleapis_auth 추가
- `AndroidManifest.xml`: Google OAuth 콜백 추가
- `Info.plist`: Google reversed client ID URL scheme 추가
- `ios/Runner/AppDelegate.swift`: BlockNetworkProtocol 제거 (네트워크 차단 코드)

### 2026-02-11: Dropbox 연동 + 갤러리 내보내기

**새 기능:**
- Dropbox OAuth 2.0 + PKCE 로그인
- 사진 Dropbox 업로드 (날짜별 폴더)
- 갤러리 내보내기 (`gal` 패키지)

**새 파일:**
- `lib/pages/camera/dropbox/dropbox_service.dart`

**수정된 파일:**
- `pubspec.yaml`: dio, flutter_web_auth_2, gal 추가
- `AndroidManifest.xml`: CallbackActivity 추가
- `Info.plist`: CFBundleURLTypes 추가

### 2026-02-10: 사진모아 앱으로 리팩토링

**주요 변경:**
- 프로젝트명: `proj2601a` → `proj2602a`
- 앱 이름: `Oasis Cam` → `사진모아`
- GitHub: `proj2601a-camera` → `photo-more`

**기능 변경:**
| 제거됨 | 추가됨 |
|--------|--------|
| HTTP 서버 | 날짜별 폴더 저장 |
| Bonjour 광고 | 사진 뷰어 (확대/축소) |
| 네트워크 전송 | 썸네일 미리보기 |
| 촬영 확인 대화상자 | 즉시 저장 + 플래시 효과 |

**삭제된 파일:**
- `lib/pages/camera/http/` 폴더 전체 (5개 파일)

**새 파일:**
- `lib/pages/camera/photo_viewer.dart` - 사진 뷰어

**촬영 피드백:**
- 플래시 효과 (alpha 0.75, 150ms)
- 시스템 클릭음
- 진동 (mediumImpact)

**camera 패키지:**
```yaml
dependencies:
  camera: 0.11.3

dependency_overrides:
  camera_android_camerax: 0.6.29  # 0.6.30 크래시 방지
```
