---
title: "Webhook Discord Blog CRD Delivery"
date: 2026/08/03
tags:
 - cron-delivery,
 - webhook-discord,
 - blog-cron-subagent-schedule-forums-and-wiki-channels.
status: completed

# Usage Context (Korean)
- 배포 환경을 위한 웹훅 + 서브에이전트 구성 가이드
1. cron-job의 delivery.mode="none" 시 Discord 전용 announce를 통해 알림 트리거 가능하며, webhook 대신 channel-based 메시지 방식 사용.
2. 주기적으로 생성되는 블로그 콘텐츠(주간 요약 등)에 대해 정확한 타임존 기반 배포 계획이 필요할 때 활용 가능.

# Summary
- 웹훅 대신 Discord announce delivery 모드를 통해 blog-crd 서브 에이전트가 생성하는 주기적 블로그 문서(주간 요약 등)의 알림을 트리거하고 배포되었음.
1. cron-delivery: none/announce/webhook 중 `none` → Discord로 announce 전달하여 안정적인 메시지 발송이 수행됨.

# Notes
- delivery.target="discord" channel에 정기 알림 문구(예:"W32 Weekly Blog Cron doc generated.")가 성공적으로 도착했으며, webhook 구성 대신 보다 가벼운 방식으로 배포 지원.