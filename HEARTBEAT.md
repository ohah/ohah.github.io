# 오늘의 커밋 — 하트비트 (OpenClaw용)

> 이 문서는 "오늘의 커밋" 섹션을 OpenClaw에게 맡길 때 사용하는 참조/명세입니다.

## 1. 목적

- **오늘의 커밋**: 당일(또는 최근)에 했던 커밋을 짧게 정리해서 블로그에 올리는 코너.
- 위치: 이 블로그(ohah) 상단 탭 **오늘의 커밋** → `/today-commit/` 페이지 및 하위 문서.

## 2. 범위 · AI 역할

- **스크립트**: `scripts/today-activity.sh`가 커밋·PR 목록을 채운 **마크다운 파일**을 생성한다.
- **AI(OpenClaw) 역할**: 작성된 마크다운에서 **요약만** 담당한다.
  - 해당 문서의 **「요약 (AI 작성)」** 섹션만 1~3문단으로 채운다.
  - 아래 커밋·PR 목록은 읽기만 하고 **수정·삭제·이동하지 않는다.**
- **톤**: 블로그에 맞게 간단·명료. 어떤 repo에서 무엇을 했는지 한눈에 보이게.

## 3. 요약 작성 가이드 (AI용)

- **위치**: 문서 상단의 `## 요약 (AI 작성)` 섹션.
- **내용**: 아래 커밋·PR 목록을 보고 오늘 하루 활동을 1~3문단으로 요약.
  - 어떤 저장소에서 무엇을 했는지, 머지된 PR이나 진행 중인 작업이 있으면 짧게 언급.
- **금지**: 커밋 목록·PR 테이블·제목·frontmatter는 건드리지 않는다.

## 4. gh로 커밋·PR → md 파일 생성

- **스크립트**: `scripts/today-activity.sh`
- **사용**: `./scripts/today-activity.sh [date] [author]`
  - 인자 없음 → **어제** 날짜, author=ohah (0시에 돌려서 방금 지난 날 커밋 정리하는 용도)
  - 예: `./scripts/today-activity.sh` (어제), `./scripts/today-activity.sh 2026-02-11`
  - 인수 생략 시 author=ohah, date=오늘.
- **동작**: 해당 날짜 커밋(repo별 그룹) + 해당일 생성/머지된 PR을 조회해 **`docs/today-commit/{date}.md`** 를 생성. (브랜치 pull 없이 `gh`만 필요.)
- **출력 경로**: `OUT_DIR`·`OUT_FILE` 환경변수로 변경 가능. 기본값 `docs/today-commit/{date}.md`.
- **_meta.json**: 같은 날짜 md 생성 시 해당 날짜를 `_meta.json`에 추가함. **메타만 따로 갱신**하려면 `./scripts/today-commit-meta.sh` 실행 (폴더 안의 `YYYY-MM-DD.md` 목록으로 `_meta.json` 재생성).

## 5. 기술/환경

- 문서 위치: `docs/today-commit/` 아래.
- 포맷: `.md` 또는 `.mdx` (Rspress 기준).
- 사이드바에 넣으려면 `docs/today-commit/_meta.json`에 해당 파일명 추가.

## 6. OpenClaw에게 시킬 때

- 지시 내용은 **항상 동일**: 해당 날짜 md에서 **커밋·PR 목록을 보고 요약만** 채운다.
- 전달할 것: 요약할 문서 경로 (예: `docs/today-commit/2026-02-11.md`). 필요하면 이 하트비트(`HEARTBEAT.md`)를 컨텍스트로 함께 전달.

## 7. 유지보수

- "오늘의 커밋" 규칙이나 형식을 바꿀 때는 이 하트비트를 먼저 수정한 뒤 OpenClaw에 다시 전달하면 됨.

## 8. 푸시 전

- 푸시 전에는 **하트비트(OpenClaw)에게 린트 돌리고, 이어서 커밋 및 푸시하라고** 지시한다. (예: `npm run lint` 후 `git add` · `git commit` · `git push`.)
