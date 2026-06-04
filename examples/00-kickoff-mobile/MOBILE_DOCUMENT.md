# MOBILE_DOCUMENT.md

## Project Overview

TrailMate is a hiking companion app that lets users browse curated trails, download them for offline use, and track a hike with GPS while disconnected. The MVP ships on iOS and Android from one Expo codebase and consumes an existing TrailMate REST API for trail data and saved hikes.

| Area | Choice |
| --- | --- |
| Framework | React Native via Expo (managed workflow), TypeScript |
| Platforms | iOS 16+, Android 9 (API 28)+ |
| Navigation | React Navigation (bottom tabs + native stack) |
| State | Zustand for app state, TanStack Query for server cache |
| Local storage | SQLite (expo-sqlite) for trails, MMKV for key-value settings |
| Backend | Existing TrailMate REST API (documented below) |
| Services | FCM + APNs for push, Sentry for crash reporting |

## Design System

| Token | Value | Usage |
| --- | --- | --- |
| `forest-900` | `#16301F` | primary headings, active tab |
| `moss-500` | `#4C8C4A` | primary actions, track button |
| `stone-100` | `#F2F0EB` | screen background |
| `slate-300` | `#C9CDD2` | borders, dividers |
| `clay-600` | `#C2562F` | destructive actions, GPS-lost banner |

Typography uses `Inter` for body at weights 400/600 and `Sora` for headings at 600/700. Cards use 12px radius and `0 6px 16px rgba(22, 48, 31, 0.10)`. The app follows platform conventions (iOS HIG vs Material) for navigation gestures and respects safe-area insets. Dark mode is supported via a parallel token set. Accessibility: all interactive elements carry screen-reader labels, text scales with dynamic type up to 200%, body text meets WCAG AA contrast, and touch targets are at least 44pt (iOS) / 48dp (Android).

## Screens & Navigation

Navigation is a 3-tab bottom bar; each tab is a native stack. Deep links use the `trailmate://` scheme.

| Screen | Tab / Stack | Key UI | Behavior |
| --- | --- | --- | --- |
| Explore | Explore › root | search bar, region chips, trail cards | infinite scroll, pull-to-refresh |
| Trail Detail | Explore › push | map preview, stats, elevation chart, Download + Start buttons | `trailmate://trail/:id` deep link |
| Downloads | Saved › root | list of offline trails, storage used | swipe to delete, tap to open detail |
| Active Hike | Saved › modal | live map, distance/time/pace, Pause/Stop | runs with screen-wake lock, foreground location |
| Profile | Profile › root | avatar, stats, settings, sign out | — |

## Device Permissions & Capabilities

| Capability | Requested when | Rationale string | Denied handling |
| --- | --- | --- | --- |
| Location (foreground) | first time starting a hike | "TrailMate uses your location to track distance and show you on the trail." | show "Enable location to track hikes" with Settings deep link |
| Location (background) | after first successful tracked hike | "Keep tracking your hike when the screen is off." | tracking continues foreground-only; banner explains limit |
| Camera | adding a photo to a hike | "Attach photos to your hike log." | fall back to photo-library picker |
| Notifications | after first download completes | "Get notified about trail closures and conditions." | app works without push; no re-prompt |

## Offline & Data Sync

Downloaded trails (geometry, tiles, metadata) are stored in SQLite and a tile cache directory. The Explore feed requires a connection; trail detail and Active Hike work fully offline once downloaded. Hikes recorded offline are queued and synced on next launch with connectivity. Sync is last-write-wins per hike record keyed by client-generated UUID; conflicts are not possible because hikes are append-only and owned by one device. Optimistic updates apply to "save trail" and "delete download" with rollback on API failure.

## Backend Dependencies

Base URLs: `https://api.trailmate.app` (prod), `https://staging-api.trailmate.app` (staging). Auth uses a bearer access token (1h) plus refresh token (30d); the client refreshes on `401` and retries once.

| Method | Path | Purpose | Response |
| --- | --- | --- | --- |
| `GET` | `/v1/trails` | list trails with `region`, `cursor` | `{ trails[], nextCursor }` |
| `GET` | `/v1/trails/:id` | trail detail + geometry | `{ trail, geometry }` |
| `POST` | `/v1/hikes` | upload a recorded hike | `{ hike }` |
| `GET` | `/v1/me` | profile and stats | `{ user, stats }` |

Errors follow `{ code, message, requestId }`. Network timeout is 10s with one retry on idempotent GETs. (If the backend did not exist, it would be built first with the API / Backend Kickoff prompt.)

## Permissions & Access Control

| State | Access |
| --- | --- |
| signed out | Explore browsing and trail detail only; Download and Start prompt sign-in |
| signed in | full access: download, track, save hikes, profile |
| token expired | silent refresh; on refresh failure, route to sign-in and preserve the pending action |

## User Flows

1. Download a trail:
   Open Explore, tap a trail, tap Download, see progress, trail appears in Saved with an offline badge.
2. Track a hike offline:
   In Airplane mode, open a downloaded trail, tap Start, grant location, hike, tap Stop, hike saves locally and syncs later.
3. Sync queued hike:
   Reopen app with connectivity, queued hike uploads in the background, profile stats update.

## Empty States

| Screen | Empty | Loading |
| --- | --- | --- |
| Explore | "No trails in this region yet" with change-region action | skeleton trail cards |
| Downloads | illustration, "No offline trails", CTA to Explore | spinner while reading SQLite |
| Profile stats | "Track your first hike to see stats here" | skeleton stat tiles |

## Error Handling

API errors surface as a toast using `message`, with `requestId` attached to the Sentry breadcrumb. Offline actions that need the network show an "You're offline" banner and queue or block as appropriate. GPS signal loss during a hike shows a non-blocking banner and keeps the last known position. All unhandled errors and native crashes report to Sentry with user ID and screen name.

## Push Notifications

Push uses FCM (Android) and APNs (iOS) via Expo push tokens registered after the first download. Payload: `{ type, trailId, title, body }`. Tapping a `trail_alert` notification deep-links to Trail Detail for `trailId`. Foreground notifications show an in-app banner; background notifications use the system tray. The permission prompt is deferred until the user has shown intent (a completed download), never on first launch.

## Security

Tokens are stored in the platform secure store (Keychain / Keystore via expo-secure-store), never in plain AsyncStorage. The API client pins the TrailMate TLS certificate. All request bodies are validated against Zod schemas before send. No PII is written to logs. Offline trail data is non-sensitive and stored unencrypted; hike GPS tracks stay on-device until the user uploads them.

## Project Structure

```text
app/
  (tabs)/               Expo Router tab screens: explore, saved, profile
  trail/[id].tsx        trail detail route
  hike/active.tsx       active hike modal route
components/
  trails/               trail cards, elevation chart, map preview
  hike/                 live tracking UI
  ui/                   shared buttons, banners, sheets
lib/
  api/                  typed API client, auth refresh
  db/                   SQLite schema and queries
  location/             tracking service and permission helpers
  store/                Zustand stores
docs/                   generated specs and ADRs
```

## Environment Variables

| Name | Scope | Secret | Purpose |
| --- | --- | --- | --- |
| `EXPO_PUBLIC_API_URL` | client build | no | API base URL per environment |
| `EXPO_PUBLIC_SENTRY_DSN` | client build | no | crash reporting endpoint |
| `SENTRY_AUTH_TOKEN` | CI only | yes | source-map upload at build time |
| `EXPO_TOKEN` | CI only | yes | EAS build/submit authentication |

`.env.example` lists all variables with placeholder values and notes that only `EXPO_PUBLIC_*` vars are bundled into the client; CI secrets are never committed.

## App Store & Release

Bundle ID `app.trailmate.ios`, application ID `app.trailmate.android`. Signing is managed by EAS (iOS) and an upload keystore stored in EAS secrets (Android). Builds and store submissions run through EAS Build / EAS Submit from CI. Store metadata (screenshots, descriptions, data-safety form) is versioned in `store/`. Minimum OS: iOS 16, Android 9. Releases use phased rollout (App Store phased release, Play staged 10% → 100%); JS-only fixes ship via EAS Update OTA between store builds.

## Testing Strategy

Unit test the API client, auth refresh, and SQLite queries. Component test trail cards, the download button states, and the active-hike controls. End-to-end test download → offline track → sync on a simulator/emulator with Maestro. First tests to write: token-refresh-and-retry, offline hike queue-and-sync, and permission-denied fallbacks.

## Implementation Order

1. Scaffold Expo app, navigation, and design tokens.
2. Build the API client with auth, token refresh, and TanStack Query.
3. Build Explore feed and Trail Detail.
4. Add SQLite storage and trail download with offline detail.
5. Build location tracking and the Active Hike screen.
6. Add offline hike queue and background sync.
7. Add push notifications, Sentry, and Maestro E2E coverage.
8. Configure EAS build, store metadata, and phased release.
