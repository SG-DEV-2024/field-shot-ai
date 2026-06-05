/* ============================================================
   _embed.js — 인터랙티브 플로우 프로토타입 임베드 지원
   - mockup HTML을 iframe + #embed 해시로 로드 시 자동 활성
   - page-head/spec/추가 stage 숨기고 phone 영역만 노출
   - 주요 인터랙티브 요소에 파란 점선 강조 + 클릭 시 부모로 postMessage
   - 의존성 없음. file:// 환경에서도 동작 (contentDocument 접근 불필요)
   ============================================================ */
(function () {
  if (window.self === window.top) return;          // iframe 안에서만 동작
  // 해시 형식: #embed (기본 stage) 또는 #embed-N (stage N 강제)
  const hashMatch = location.hash.match(/^#embed(?:-(\d+))?$/);
  if (!hashMatch) return;
  const hashStage = hashMatch[1] ? parseInt(hashMatch[1], 10) : null;

  // ---------- 화면 ID 식별 ----------
  // 일부 호스트(Netlify Pretty URLs 등)는 경로를 소문자로 바꾸고 .html을 떼므로
  // 대소문자 무시(/i)로 매칭한 뒤 대문자로 정규화한다. (s-001_main → S-001)
  const fileName = location.pathname.split('/').pop() || '';
  const m = fileName.match(/^([SC]-\d+)/i);
  const SCREEN_ID = m ? m[1].toUpperCase() : null;
  if (!SCREEN_ID) return;

  // ---------- 화면별 stage 인덱스 ----------
  // 해시로 override 가능. 없으면 화면별 기본값 사용.
  const STAGE_INDEX = {
    'S-001': 2,  // 미전송 12건 (현실적 상태)
    'S-009': 2,  // 데이터 3건
    'C-002': 2,  // 탄산화 보관함 데이터 3건
    'C-003': 2   // 데이터 입력 완료 (저장 활성)
  };
  const stageIdx = hashStage || STAGE_INDEX[SCREEN_ID] || 1;

  // ---------- 헬퍼 ----------
  function findButtonByText(root, text) {
    return Array.from(root.querySelectorAll('button, .btn, .cta, [class*="next"], [class*="primary"]'))
      .filter(function (el) {
        var t = el.textContent.trim();
        return t.includes(text) && el.children.length <= 5;
      })
      .sort(function (a, b) { return a.textContent.length - b.textContent.length; })
      .slice(0, 1);
  }

  function cardsByText(root, text) {
    return Array.from(root.querySelectorAll('.card.enabled, .card'))
      .filter(function (el) { return el.textContent.includes(text); });
  }

  function linksByText(root, text) {
    return Array.from(root.querySelectorAll('.link, a, [class*="link"]'))
      .filter(function (el) { return el.textContent.trim().includes(text); });
  }

  function byAttr(root, attr, value) {
    return Array.from(root.querySelectorAll('[' + attr + '="' + value + '"]'));
  }

  // ---------- 화면별 트리거 정의 ----------
  // 각 트리거: { find: root => Element[], target: 'S-xxx', label: '액션 설명' }
  const TRIGGERS = {
    'S-001': [
      // 탄산화 카드 → C-001 (탄산화 카메라). enabled 카드 중 "규격"이 안 들어간 것이 탄산화.
      { find: function (r) {
          return Array.from(r.querySelectorAll('.card.enabled'))
            .filter(function (el) { return el.textContent.includes('탄산화'); });
        },
        target: 'C-001', label: '탄산화 조사 카드' },
      { find: function (r) { return cardsByText(r, '규격'); },
        target: 'S-002', label: '규격 조사 카드' },
      { find: function (r) { return linksByText(r, '보관함'); },
        target: 'S-009', label: '보관함 보기' }
    ],
    'S-002': [
      { find: function (r) { return byAttr(r, 'data-subtype', 'wall_or_member_width'); },
        target: 'S-003', label: '벽체/기둥/슬라브 폭 카드' },
      { find: function (r) { return byAttr(r, 'data-subtype', 'member_gap'); },
        target: 'S-003', label: '부재 규격 조사 카드' },
      { find: function (r) { return byAttr(r, 'data-subtype', 'hole_depth'); },
        target: 'S-006', label: '홀 깊이 카드' }
    ],
    'S-003': [
      { find: function (r) { var el = r.querySelector('.shutter'); return el ? [el] : []; },
        target: 'S-004', label: '셔터 (촬영)',
        // 셔터 시점에 현재 가이드박스 좌/우 끝(시작·끝점 사전 좌표) 캡쳐 → S-004로 전달.
        // 사용자가 핸들을 드래그해 박스 폭을 조정했다면 그 위치가 그대로 S-004 마커 초기값.
        state: function () {
          var screen = document.querySelector('.screen');
          if (!screen) return null;
          var cs = getComputedStyle(screen);
          var sx = parseFloat(cs.getPropertyValue('--start-x'));
          var ex = parseFloat(cs.getPropertyValue('--end-x'));
          if (isNaN(sx) || isNaN(ex)) return null;
          return { startX: sx, endX: ex };
        } }
    ],
    'S-004': [
      { find: function (r) { return findButtonByText(r, '다음'); },
        target: 'S-005', label: '다음 · 수치 입력' },
      { find: function (r) { return findButtonByText(r, '다시 촬영'); },
        target: 'S-003', label: '다시 촬영' }
    ],
    'S-005': [
      // 저장 후 계속 촬영 → 카메라(S-003) 복귀, 연속 측정. 메인 직행 액션은 의도적 제외.
      { find: function (r) { var el = r.querySelector('#saveBtn'); return el ? [el] : []; },
        target: 'S-003', label: '저장 후 계속 촬영' }
    ],
    'S-006': [
      { find: function (r) { var el = r.querySelector('.shutter'); return el ? [el] : []; },
        target: 'S-007', label: '셔터 (촬영)' }
    ],
    'S-007': [
      { find: function (r) { return findButtonByText(r, '다음'); },
        target: 'S-008', label: '다음 · 수치 입력' },
      { find: function (r) { return findButtonByText(r, '다시 촬영'); },
        target: 'S-006', label: '다시 촬영' }
    ],
    'S-008': [
      // 저장 후 계속 촬영 → 카메라(S-006) 복귀, 연속 측정. 메인 직행 액션은 의도적 제외.
      { find: function (r) { var el = r.querySelector('#saveBtn'); return el ? [el] : []; },
        target: 'S-006', label: '저장 후 계속 촬영' }
    ],
    // ===== 탄산화 (C-) =====
    'C-001': [
      // 셔터 → C-003 (데이터 입력)
      { find: function (r) { var el = r.querySelector('.shutter'); return el ? [el] : []; },
        target: 'C-003', label: '셔터 (촬영)' },
      // 좌하단 갤러리 썸네일 → C-002 (탄산화 보관함)
      { find: function (r) { var el = r.querySelector('.gallery-thumb'); return el ? [el] : []; },
        target: 'C-002', label: '보관함 (갤러리 썸네일)' }
    ],
    // C-002 — stage 2(리스트) / stage 3(수정 모달)
    'C-002': function (stage) {
      if (stage === 3) {
        return [
          { find: function (r) { return Array.from(r.querySelectorAll('.modal-cancel')); },
            target: 'C-002', label: '취소 (모달 닫기)' },
          { find: function (r) { return Array.from(r.querySelectorAll('.modal-save')); },
            target: 'C-002', label: '저장 (모달 닫기)' }
        ];
      }
      // stage 1(빈) or stage 2(데이터있음): edit-btn → C-002E
      return [
        { find: function (r) { return Array.from(r.querySelectorAll('.edit-btn')); },
          target: 'C-002E', label: '수정 (모달 열기)' }
      ];
    },
    'C-003': [
      // 저장 후 계속 촬영 → C-001 카메라 복귀
      { find: function (r) { var el = r.querySelector('#saveBtn'); return el ? [el] : []; },
        target: 'C-001', label: '저장 후 계속 촬영' }
    ],

    // S-009는 stage별 동작 분기:
    //   stage 2 = 리스트 → 각 카드 수정 버튼이 subtype에 맞는 모달로 이동
    //   stage 3/4/5 = 모달 열림 (탄산화/폭간격/홀깊이) → 취소·저장 시 리스트 복귀
    'S-009': function (stage) {
      if (stage === 3 || stage === 4 || stage === 5) {
        return [
          { find: function (r) { return Array.from(r.querySelectorAll('.modal-cancel')); },
            target: 'S-009', label: '취소 (모달 닫기)' },
          { find: function (r) { return Array.from(r.querySelectorAll('.modal-save')); },
            target: 'S-009', label: '저장 (모달 닫기)' }
        ];
      }
      // stage 2: 카드별 subtype에 맞는 모달로 분기
      return [
        // 탄산화 카드 수정 → S-009E
        { find: function (r) { return Array.from(r.querySelectorAll('[data-survey-type="carbonation"] .edit-btn')); },
          target: 'S-009E', label: '수정 (탄산화 모달)' },
        // 폭 측정 또는 간격 측정 카드 수정 → S-009Ed (같은 모달 구조)
        { find: function (r) {
            return Array.from(r.querySelectorAll('[data-survey-type="dimension-width"] .edit-btn, [data-survey-type="dimension-gap"] .edit-btn'));
          },
          target: 'S-009Ed', label: '수정 (폭/간격 모달)' },
        // 홀 깊이 카드 수정 → S-009Eh
        { find: function (r) { return Array.from(r.querySelectorAll('[data-survey-type="dimension-hole"] .edit-btn')); },
          target: 'S-009Eh', label: '수정 (홀 깊이 모달)' }
      ];
    }
  };

  // ---------- CSS 주입 ----------
  // 원본 목업 디자인은 그대로 유지하고, 탭 피드백만 추가
  function injectStyle() {
    var style = document.createElement('style');
    style.id = '__flow_embed_style__';
    style.textContent = [
      'html, body{',
      '  background:transparent !important;',
      '  margin:0 !important; padding:0 !important;',
      '  min-height:0 !important;',
      '  overflow:hidden !important;',
      '  width:360px !important; height:720px !important;',
      '}',
      'body > *{ display:none !important; }',
      'body > .mockup-row{',
      '  display:flex !important;',
      '  margin:0 !important; padding:0 !important;',
      '  gap:0 !important;',
      '  justify-content:flex-start !important;',
      '  align-items:flex-start !important;',
      '  width:360px !important; height:720px !important;',
      '  overflow:hidden !important;',
      '}',
      '.mockup-row .stage{ display:none !important; }',
      '.mockup-row .stage:nth-of-type(' + stageIdx + '){ display:block !important; }',
      '.stage{ margin:0 !important; gap:0 !important; }',
      '.stage .tag, .stage .desc{ display:none !important; }',
      '.screen{',
      '  margin:0 !important;',
      '  border:0 !important;',
      '  border-radius:0 !important;',
      '  box-shadow:none !important;',
      '  width:360px !important; height:720px !important;',
      '}',
      '.page-head{ display:none !important; }',
      /* 탭 피드백 — 누르면 살짝 작아지고 어두워진 후 복귀 */
      '._flow_tappable{ cursor:pointer; -webkit-tap-highlight-color:transparent; }',
      '._flow_pressed{ animation:_flow_tap 220ms cubic-bezier(0.34, 1.56, 0.64, 1); }',
      '@keyframes _flow_tap{',
      '  0%  { transform:scale(1);    filter:brightness(1);    }',
      '  40% { transform:scale(0.94); filter:brightness(0.85); }',
      '  100%{ transform:scale(1);    filter:brightness(1);    }',
      '}'
    ].join('\n');
    (document.head || document.documentElement).appendChild(style);
  }

  // ---------- 보이는 stage 스코프 ----------
  function getRoot() {
    var row = document.querySelector('.mockup-row');
    if (!row) return document;
    var stages = row.querySelectorAll(':scope > .stage');
    if (stages.length === 0) return row;
    var idx = Math.min(stageIdx - 1, stages.length - 1);
    return stages[idx] || stages[0];
  }

  // ---------- 트리거 부착 ----------
  function attach() {
    var root = getRoot();
    var triggers = TRIGGERS[SCREEN_ID] || [];
    // 함수형 triggers: stage 기반 분기 (S-009의 stage 2 vs 3 등)
    if (typeof triggers === 'function') {
      triggers = triggers(stageIdx) || [];
    }
    triggers.forEach(function (trig) {
      var found;
      try { found = trig.find(root) || []; } catch (e) { found = []; }
      Array.prototype.slice.call(found).filter(Boolean).forEach(function (el) {
        el.classList.add('_flow_tappable');
        el.addEventListener('click', function (e) {
          e.preventDefault();
          e.stopPropagation();
          // 탭 시점에 화면 상태 캡쳐 (예: S-003 셔터 → 가이드박스 좌/우 끝 좌표)
          var state = null;
          if (typeof trig.state === 'function') {
            try { state = trig.state(root, el); } catch (err) { state = null; }
          }
          // 탭 피드백 → 약 150ms 후 부모에게 전이 요청
          el.classList.remove('_flow_pressed');
          // 강제로 reflow 시켜 animation 재시작 (연속 탭 대응)
          void el.offsetWidth;
          el.classList.add('_flow_pressed');
          setTimeout(function () {
            window.parent.postMessage({
              type: 'flow:navigate',
              target: trig.target,
              label: trig.label,
              from: SCREEN_ID,
              state: state
            }, '*');
          }, 150);
        }, true);
      });
    });

    // ---------- 상단 ← 뒤로가기 버튼 자동 wiring (모든 화면 공통) ----------
    // 각 mockup은 .back-btn 요소를 가지고 있어 부모가 TRANSITIONS[현재].back으로 이동시킨다.
    // 화면별 트리거 정의 없이도 모든 화면의 ← 버튼이 동작.
    Array.prototype.slice.call(root.querySelectorAll('.back-btn'))
      .filter(Boolean)
      .forEach(function (el) {
        el.classList.add('_flow_tappable');
        el.addEventListener('click', function (e) {
          e.preventDefault();
          e.stopPropagation();
          el.classList.remove('_flow_pressed');
          void el.offsetWidth;
          el.classList.add('_flow_pressed');
          setTimeout(function () {
            window.parent.postMessage({
              type: 'flow:back',
              from: SCREEN_ID
            }, '*');
          }, 150);
        }, true);
      });

    // 부모에게 ready 알림
    try {
      window.parent.postMessage({
        type: 'flow:ready',
        screen: SCREEN_ID,
        triggerCount: triggers.length
      }, '*');
    } catch (e) { /* noop */ }
  }

  // ---------- init ----------
  function init() {
    injectStyle();
    attach();
    // 마커 좌표 재계산 트리거.
    // S-004 / S-007 등은 inline script가 photoFrame.getBoundingClientRect() 기반으로
    // 마커 픽셀 좌표를 한 번 계산해 두지만, 그 시점은 _embed.js의 CSS 주입 이전.
    // 그래서 standalone일 때의 body padding/flex-shrink 영향으로 photoFrame이
    // 줄어든 상태로 측정되고, CSS 주입 후 .screen이 360px로 복원돼도 마커는
    // 이미 잘못된 위치에 stuck. 두 프레임 뒤 resize를 발사해 mockup의
    // window.addEventListener('resize', refresh)가 다시 트리거되게 한다.
    requestAnimationFrame(function () {
      requestAnimationFrame(function () {
        window.dispatchEvent(new Event('resize'));
      });
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
