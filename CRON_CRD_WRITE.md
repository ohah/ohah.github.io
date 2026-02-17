# 크론잡 가이드 — 맞춤법 교정 (30분마다)

**크론 전용.** 하트비트가 아닌 **크론잡**에서만 이 파일을 읽습니다.  
30분마다 돌리는 크론에서 이 문서를 읽고, 블로그 내 **모든 .mdx 파일**을 **한 번에 하나씩** 검사하면서 **맞춤법만** 수정합니다.

---

## 1. 목표

- **대상**: 이 워크스페이스(blog) 안의 모든 `.mdx` 파일 (`docs/` 아래 등).
- **작업**: 매 턴 **mdx 파일 하나**를 골라, **맞춤법·띄어쓰기·오타**만 검사·수정. 내용 추가·삭제·문체 변경은 하지 않는다.
- **순서**: 아래 §7 목록 순서대로, 체크 안 된 파일 하나씩 처리.

---

## 2. 매 턴 할 일 (요약)

1. **다음 mdx 하나** 선택: 아래 **§7 mdx 파일 목록**에서 체크박스가 **비어 있는** `[ ]` 파일 중 **맨 위** 하나를 선택한다.
2. 해당 **.mdx 파일 전체**를 읽고, **맞춤법·띄어쓰기·오타**만 수정한다. 문장 의미·말투·구조는 바꾸지 않는다.
3. **작업 끝날 때마다** 이 파일(`CRON_CRD_WRITE.md`)을 열어, 이번 턴에 검사한 파일 행의 체크박스를 `[ ]` → `[x]`로 바꾼다. (다른 행은 건드리지 않는다.)
4. 수정한 내용이 있으면 `bun run lint` 실행 → 통과 시 `git add` (해당 mdx 파일 + `CRON_CRD_WRITE.md`) · `git commit` · `git push`. 수정한 게 없어도 체크박스는 반드시 갱신하고, `CRON_CRD_WRITE.md`만 커밋·푸시할 수 있다.
5. 수정한 게 없고 체크만 했으면, `CRON_CRD_WRITE.md`만 add·commit·push.
6. 응답: 이번 턴 요약(어떤 파일 검사했는지, 맞춤법 수정 여부)만 보낸다.

---

## 3. 맞춤법 수정 범위

- **한다**: 맞춤법(한글 맞춤법, 표준어), 띄어쓰기, 오타(철자), 중복 띄어쓰기 제거.
- **하지 않는다**: 문장 바꾸기, 내용 추가·삭제, 말투·문체 변경, frontmatter 필드 값 변경(제목·날짜·설명 등).

---

## 4. 금지 사항

- 한 턴에 여러 mdx 파일 수정 금지 (한 턴에 한 파일만).
- 맞춤법·오타가 아닌 내용 수정 금지.
- 린트 실패 시 커밋·푸시 금지.

---

## 5. 블로그 기존 크론(today-commit)과의 관계

- **today-commit**: 매일 0시 등 한 번, `./scripts/today-activity.sh` 실행 후 요약 작성·푸시.
- **맞춤법 교정**: 30분마다, mdx 파일 하나씩 맞춤법만 검사·수정·푸시.

둘 다 같은 **blog** 워크스페이스에서, 푸시 전에 `bun run lint` 한 번 실행하는 점이 동일합니다.

---

## 6. 완료 시 알림

- **설정됨**: 상위 OpenClaw 크론 `blog-crd-write`의 `delivery`가 `mode: announce`, `channel: discord`, `to: 1470349655966744661` 로 되어 있어, 완료 시마다 Discord 채널 **1470349655966744661**로 알림이 간다. (이 문서를 “읽어서” 보내는 게 아니라, 크론 실행 결과가 **자동 전송**된다.)
- **참고**: 해당 크론이 `enabled: false`이면 실행·알림이 나가지 않는다. 사용 시 OpenClaw에서 크론을 켜 두어야 한다.
- 알림·대화는 OpenClaw Control에서 해당 디스코드 세션(채널 1470349655966744661)을 열어 확인하면 된다.

---

## 7. mdx 파일 목록 (검사 완료 시 해당 행 체크)

아래 순서대로 한 턴에 하나씩 검사하고, **끝날 때마다** 해당 파일 행만 `[ ]` → `[x]`로 바꾼다.

- [x] docs/index.mdx
- [x] docs/monthly-opensource/index.mdx
- [x] docs/monthly-opensource/craby/background.mdx
- [x] docs/monthly-opensource/chromium/background.mdx
- [ ] docs/monthly-opensource/chromium/code-review.mdx
- [ ] docs/monthly-opensource/chromium/first-contribution.mdx
- [ ] docs/monthly-opensource/chromium/merge.mdx
- [ ] docs/monthly-opensource/chromium/setup.mdx
- [ ] docs/monthly-opensource/crd/background.mdx
- [ ] docs/monthly-opensource/crd/development.mdx
- [ ] docs/monthly-opensource/crd/development-1.mdx
- [ ] docs/monthly-opensource/crd/development-2.mdx
- [ ] docs/monthly-opensource/crd/development-3.mdx
- [ ] docs/monthly-opensource/crd/development-4.mdx
- [ ] docs/monthly-opensource/crd/development-5.mdx
- [ ] docs/monthly-opensource/crd/development-6.mdx
- [ ] docs/monthly-opensource/crd/development-7.mdx
- [ ] docs/monthly-opensource/crd/development-8.mdx
- [ ] docs/monthly-opensource/crd/development-9.mdx
- [ ] docs/monthly-opensource/crd/tech-stack.mdx
- [ ] docs/monthly-opensource/hwpjs/background.mdx
- [ ] docs/monthly-opensource/hwpjs/development.mdx
- [ ] docs/monthly-opensource/hwpjs/development-1.mdx
- [ ] docs/monthly-opensource/hwpjs/development-2.mdx
- [ ] docs/monthly-opensource/hwpjs/development-3.mdx
- [ ] docs/monthly-opensource/hwpjs/development-4.mdx
- [ ] docs/monthly-opensource/hwpjs/development-5.mdx
- [ ] docs/monthly-opensource/hwpjs/tech-stack.mdx
