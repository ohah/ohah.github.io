# AGENTS.md — 블로그(ohah) 워크스페이스

이 폴더는 **ohah 블로그** 프로젝트입니다. Rspress 기반 문서/블로그 사이트입니다.

## 세션 시작 시
1. 메인세션이면 상위 `AGENTS.md`·`SOUL.md`의 규칙을 따릅니다.
2. 크론으로 "이 스크립트 읽어라"가 오기 전, 먼저 아래 단계를 수행한 뒤 HEARTBEAT_OK 여부 반환.

---

## 매일 실행 시 (단순화)

**크 cron:**
```bash
./scripts/meta-updater.zsh ohah && \
git add docs/today-commit/_meta.json; git commit -m "docs" --allow-empty 2>/dev/null || true;
```

오늘의 커밋 요약(`logs/{YYYY-MM-DD}.md`)는 **아직 자동화되지 않았다**. 필요 시 개별 세션에서 직접 생성한다.

---

## 키워드
- `bun run lint` → 린트 실행 후 commit/push

---