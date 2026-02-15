# AGENTS.md — 블로그(ohah) 워크스페이스

이 폴더는 **ohah 블로그** 프로젝트입니다. Rspress 기반 문서/블로그 사이트입니다.

## 세션 시작 시

1. **메인 세션**(사람과 직접 대화)이면 상위 워크스페이스의 `AGENTS.md`·`SOUL.md`·`USER.md`·`memory/`·`MEMORY.md` 규칙을 따릅니다.
2. Cron 등으로 "에이전트(이 문서) 읽어서 실행해 줘"라고 오면 **이 파일만 참고**해서 아래대로 실행한다.

---

## 매일 실행 시 할 일 (Cron)

이 워크스페이스에서 매일 한 번 돌 때:

1. **`./scripts/today-activity.sh`** 실행 (전날 커밋 이력 md 생성).
2. 아래 **오늘의 커밋** 규칙대로 해당 문서 요약만 채움.
3. 작성된 내용이 있으면 아래 **푸시 전** 절차대로 커밋·푸시.
4. 다 진행하면 `HEARTBEAT_OK` 반환.

---

## 매일 실행 시 상세 (오늘의 커밋)

1. **`./scripts/today-activity.sh`** 실행 (인자 없으면 어제 날짜, author=ohah. 메타만 갱신: `./scripts/today-commit-meta.sh`).
2. 생성된 **`docs/today-commit/{date}.md`**의 **`## 요약 (AI 작성)`** 섹션만 1~3문단으로 채운다.
   - 같은 문서 안 커밋·PR 목록을 보고 요약. 어떤 repo에서 무엇을 했는지, 머지된 PR·진행 중인 작업 있으면 짧게.
   - **금지**: 커밋 목록·PR 테이블·제목·frontmatter는 수정·삭제하지 않는다.
   - 사이드바 노출: `docs/today-commit/_meta.json`에 해당 날짜 추가.
3. 작성된 내용이 있으면 아래 **푸시 전** 절차대로 커밋·푸시.
4. 다 진행하면 `HEARTBEAT_OK` 반환.

## 푸시 전

- 린트 한 번 돌린 뒤 커밋·푸시: `bun run lint` → `git add` · `git commit` · `git push`.

---

## 30분마다 실행 시 (CRD 작성 예정 순차 작성)

- **크론**에서 이 워크스페이스를 30분마다 돌릴 때:
  1. **`CRON_CRD_WRITE.md`** 를 읽고, 지시대로 월간 오픈소스 CRD "작성 예정" 문서 **한 편**만 순차 작성.
  2. [chrome-remote-devtools](https://github.com/ohah/chrome-remote-devtools) 참고, 기존 CRD 글(background, tech-stack) 참고.
  3. 린트 통과 후 커밋·푸시. 끝나면 요약만 반환.
- 크론 등록·상세: 상위 워크스페이스 openclaw 설정 및 **`CRON_CRD_WRITE.md`** 참고.
