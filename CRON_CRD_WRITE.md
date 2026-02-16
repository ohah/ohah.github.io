# 크론잡 가이드 — CRD 작성 예정 순차 작성 (30분마다)

**크론 전용.** 하트비트가 아닌 **크론잡**에서만 이 파일을 읽습니다.  
30분마다 돌리는 크론에서 이 문서를 읽고, 월간 오픈소스 **Chrome Remote Debugger(CRD)** 카테고리의 "작성 예정" 문서를 **한 편씩** 순차 작성합니다.

---

## 1. 목표

- **대상 페이지**: https://ohah.github.io/monthly-opensource/index.html  
  (여기 사이드바/목록에 "작성 예정"으로 표시된 CRD 문서들을 순서대로 채움)
- **작업**: CRD 문서 한 편씩 본문 작성 → 린트 → 커밋·푸시
- **참고 프로젝트**: [ohah/chrome-remote-devtools](https://github.com/ohah/chrome-remote-devtools) (README, CONTRIBUTING, 문서 사이트 등)

---

## 2. 매 턴 할 일 (요약)

1. **작성 예정 후보**에서 다음 한 편 선택: `docs/monthly-opensource/crd/_meta.json`에서 `"tag": "작성 예정"`인 항목 순서(아래 표 참고). 이미 본문이 채워진 파일은 건너뛰기.

   | 순서 | 파일 | 제목 | 기준일 |
   |------|------|------|--------|
   | 1 | development-1 | 3-1. 배민 구현 따라하기 | 2026-02-15 |
   | 2 | development-2 | 3-2. 배민 백로그까지 구현 | 2026-02-15 |
   | 3 | development-3 | 3-3. 욕심 부려보기 | 2026-02-15 |
   | 4 | development-4 | 3-4. React Native | 2026-02-15 |
   | 5 | development-5 | 3-5. 터보모듈 | 2026-02-15 |
   | 6 | development-6 | 3-6. 번들러 학습 | 2026-02-15 |
   | 7 | development-7 | 3-7. 네이티브 걷어내기 | 2026-02-15 |
   | 8 | development-8 | 3-8. 커스텀 패널 구현 | 2026-02-15 |
   | 9 | development-9 | 3-9. 마무리 | 2026-02-15 |
   | 10 | development | 3. 개발 과정 | 2026-02-15 |
2. `docs/monthly-opensource/crd/` 해당 `.mdx` 파일 **본문만** 작성 (frontmatter 수정 금지). **기존 CRD 글의 말투·문체를 유지**한다.
3. [chrome-remote-devtools](https://github.com/ohah/chrome-remote-devtools)와 기존 CRD 글(background, tech-stack) 참고.
4. `bun run lint` 실행 → 통과 시 `git add` · `git commit` · `git push`.
5. 응답: 이번 턴 요약(어떤 문서 작성했는지)만 보낸다.

---

## 3. 참고 링크

| 용도 | URL |
|------|-----|
| CRD 프로젝트 | https://github.com/ohah/chrome-remote-devtools |
| CRD 문서 사이트 | https://ohah.github.io/chrome-remote-devtools/ |
| 월간 오픈소스 목록(작성 예정 확인) | https://ohah.github.io/monthly-opensource/index.html |

---

## 4. 금지 사항 · 유지 사항

- **유지**: 기존 CRD 글(background, tech-stack 등)의 **말투·문체**를 그대로 따른다.
- frontmatter(title, date, description) 수정·삭제 금지.
- 한 턴에 여러 CRD 문서 작성 금지 (한 턴에 한 편만).
- 린트 실패 시 커밋·푸시 금지.

---

## 5. 블로그 기존 크론(today-commit)과의 관계

- **today-commit**: 매일 0시 등 한 번, `./scripts/today-activity.sh` 실행 후 요약 작성·푸시.
- **CRD 작성**: 30분마다, CRD "작성 예정" 문서 한 편씩 작성·푸시.

둘 다 같은 **blog** 워크스페이스에서, 푸시 전에 `bun run lint` 한 번 실행하는 점이 동일합니다.
