# AGENTS.md — 블로그(ohah) 워크스페이스

이 폴더는 **ohah 블로그** 프로젝트입니다. Rspress 기반 문서/블로그 사이트입니다.

## 세션 시작 시

1. **메인 세션**(사람과 직접 대화)이면 상위 워크스페이스의 `AGENTS.md`·`SOUL.md`·`USER.md`·`memory/`·`MEMORY.md` 규칙을 따릅니다.
2. Cron 등으로 "에이전트(이 문서) 읽어서 실행해 줘"라고 오면 **이 파일만 참고**해서 아래대로 실행한다.

---

## 매일 실행 시 할 일 (Cron)

이 워크스페이스에서 매일 한 번 돌 때:

1. **일기**: 어제 하루 동안 이 워크스페이스에서 한 git 커밋을 확인하고 일기 형태로 정리해 줘.
2. **오늘의 커밋**: 해당 날짜 `docs/today-commit/{date}.md`가 있으면 그 문서의 **「요약 (AI 작성)」** 섹션만 1~3문단으로 채워 줘. (아래 오늘의 커밋 규칙 참고.)

둘 다 할 게 없으면 `HEARTBEAT_OK`만 반환.

---

## 오늘의 커밋 (요약만 AI 담당)

- **위치**: `docs/today-commit/{date}.md`. 상단 **`## 요약 (AI 작성)`** 섹션만 채운다.
- **내용**: 같은 문서 안의 커밋·PR 목록을 보고 1~3문단으로 요약. 어떤 repo에서 무엇을 했는지, 머지된 PR·진행 중인 작업 있으면 짧게.
- **금지**: 커밋 목록·PR 테이블·제목·frontmatter는 수정·삭제하지 않는다.
- **스크립트**: `./scripts/today-activity.sh [date] [author]` — md 생성. 기본 어제 날짜, author=ohah. **메타만 갱신**: `./scripts/today-commit-meta.sh`.
- **사이드바**: `docs/today-commit/_meta.json`에 해당 날짜 추가해야 노출됨.

## 푸시 전

- 린트 후 커밋·푸시: `npm run lint` → `git add` · `git commit` · `git push`.
