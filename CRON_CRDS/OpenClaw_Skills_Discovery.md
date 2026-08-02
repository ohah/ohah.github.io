# R-WEEK7 - Agent Skills Discovery Guide

---

**Date:** Sat, Aug 1st‑2026  
**(UTC):)** Fri, July 31 at **22:00 UTC**

## Tags
- #skills-guide @blog-crd openclaw-skills discovery catalog taskflow-inbox-triage agent-browser github gh_issues discord meme_maker find_skills

---

**Summary**
This guide catalogs OpenClaw skills and their typical use cases (e.g., browser automation, GitHub issue handling). It shows where to look for them in the workspace (`/agents` vs `/openclaw/skills`) so blog-crd can pick relevant tools quickly. Notes: always read SKILL.md at exact location before using a skill.

## Status
In Progress - Documentation

---

### 📝 Quick Summary (3 lines)
이 가이드는 OpenClaw 사용 가능한 스킬(예시 브라우저 자동화, GitHub 이슈 처리)과 그 용도를 정리합니다. /agents/skills와 ~/.openclaw/plugin-skills에서 위치 정보가 제공되며 SKILL.md 항목을 반드시 읽어서 사전 확인할 것.

---

### 📚🔗🔍🔎📖📝📌💡 References

**Primary Skill Files**
1) agent-browser (/~/.agents/skills/agent-browser/SKILL.md, / ~/.openclaw/plugin-skills/browser-automation/)
   - 용도: 웹페이지 탐색|폼 작성 버튼 클릭 스크린샷 데이터 추출 로그인 자동화
2) github (/~/.local/share/mise/installs/node/*/lib/openclaw/skills/github/SKILL.md)
   - 용도: 이슈 PR CI 체크로그 검색 리뷰 브랜치 릴리스 gh CLI 활용(이름은 SKILLS.MD에 github 표기로, 실제 패키지는 openclaw/skills/github)

**Use Cases (examples)**
- agent-browser: 웹사이트 자동화
- browser-skills/taskflow-inbox-triage 이메일 함 분류 대기 응답 집계

## 📝 Task History / Week Notes | Last Updated: