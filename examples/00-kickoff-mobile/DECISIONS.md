# DECISIONS.md

## ADR-001: Cross-platform with Expo (React Native)

| Option | Pros | Cons | Complexity/Cost |
| --- | --- | --- | --- |
| Expo (React Native) | one codebase, OTA updates, fast iteration, TS reuse | some native modules need config plugins | low |
| Flutter | great performance, single codebase | Dart, separate ecosystem from web team | medium |
| Native (Swift + Kotlin) | best platform fidelity | two codebases, double the work | high |

- Decision: Use Expo managed workflow on 2026-06-03.
- Why this choice:
  - Team already writes TypeScript on the web side.
  - One codebase ships both platforms for a small MVP.
  - EAS Update enables JS hotfixes without a store review.
- When to reconsider:
  - If a required capability has no maintained Expo module.
  - If performance on low-end Android falls short.

## ADR-002: SQLite for offline trail storage

| Option | Pros | Cons | Complexity/Cost |
| --- | --- | --- | --- |
| SQLite (expo-sqlite) | relational queries, handles large trail sets | schema migrations to manage | low |
| AsyncStorage/MMKV only | trivial setup | poor for large, queryable data | low |
| WatermelonDB | reactive, scales well | heavier dependency than MVP needs | medium |

- Decision: Use SQLite for trails and MMKV for settings.
- Why this choice:
  - Offline trail lists need filtering and joins.
  - SQLite is well supported in Expo.
  - MMKV is fastest for small key-value settings.
- When to reconsider:
  - If reactive queries across many screens become a pain point.

## Summary

| ADR | Choice |
| --- | --- |
| 001 | Expo (React Native) cross-platform |
| 002 | SQLite for trails, MMKV for settings |

Ship the smallest hiking app that works reliably with no signal on the trail.
