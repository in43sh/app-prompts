# Mobile App Kickoff

I want to start a new mobile app. Help me think through it from scratch — the goal is to produce a complete, AI-ready spec that I can hand to an AI coding assistant to build from.

This prompt is client-focused. If the app talks to a backend, we document the backend it *consumes* (base URLs, auth, endpoints, error contract) but do not design the server here — if the backend does not exist yet, use the API / Backend Kickoff prompt to build it.

Ask me questions in stages — don't dump everything at once. Start with vision and goals, then dig into users, then requirements, then tech stack, then structure. Wait for my answers before moving to the next stage.

If I do not know a materially important detail, help me choose by presenting a small set of sensible options and recommending one with brief reasoning. Do not present a recommendation as a confirmed requirement unless I explicitly accept it. If an important detail remains unresolved, mark it as an explicit assumption or include it in `OPEN_QUESTIONS.md` instead of inventing it.

Output quality bar:

- Use concrete defaults and explicit values wherever possible.
- Do not use vague phrases like "as needed", "etc.", "TBD" in final specs unless the item is truly unresolved and is clearly labeled as an assumption or open question.
- Use tables, bullet lists, and numbered flows whenever they make the spec easier to implement unambiguously.

## Stage 1 — Vision

- What problem does this solve?
- Who is it for? (consumers, internal team, a specific industry, etc.)
- What does success look like at launch?
- Is there an existing app I'm replacing or extending?
- Is there a Figma design or other visual reference?

## Stage 2 — Users & Flows

- Who are the primary users?
- What are the core user flows? (what does a user actually *do* in the app?)
- What are the non-negotiable requirements vs. nice-to-haves?
- How do users sign in and onboard? (account required, guest mode, social login, none)

## Stage 3 — Scope & Constraints

- What is explicitly out of scope for v1?
- What platforms must ship? (iOS, Android, or both) and what minimum OS versions?
- What must work offline, and what can require a connection?
- Any compliance, security, or privacy requirements? (GDPR, HIPAA, COPPA, App Store / Play data-safety disclosures)
- Which device capabilities does the app need? (camera, location, contacts, biometrics, push, microphone, sensors, Bluetooth)

## Stage 4 — Tech Stack

- Native (Swift/SwiftUI, Kotlin/Jetpack Compose) or cross-platform (React Native, Expo, Flutter)?
- Any language/framework preferences or existing expertise?
- Navigation approach? (tabs, stack, drawer — and a library if cross-platform)
- State management and local storage? (e.g. Redux/Zustand/Riverpod; SQLite, MMKV, AsyncStorage, Core Data, Room)
- Backend: is there an existing API, or does one need to be built? (if it must be built, use the API / Backend Kickoff prompt)
- Push notifications, analytics, and crash reporting providers? (FCM/APNs, Firebase, Sentry, etc.)
- Auth strategy on the client? (token storage, refresh, biometric unlock)

## Stage 5 — Project Structure, Release & Testing

- Monorepo (shared with web/backend) or standalone repo?
- App store setup — bundle/application IDs, signing, and who holds the developer accounts?
- Build/release pipeline? (EAS, Fastlane, Xcode Cloud, manual)
- What's the testing strategy? (unit, component, end-to-end on device/simulator)

After I answer, produce the following three documents:

---

### 1. `MOBILE_DOCUMENT.md`

A complete, self-contained implementation spec. Include every section below:

- **Project Overview** — one-paragraph brief and tech stack table (include target platforms and minimum OS versions)
- **Design System** — colors (name, hex, usage), typography (font family, weights), effects (shadows, borders), spacing scale, and platform conventions (iOS Human Interface Guidelines vs Material, safe areas, dark mode support)
- **Screens & Navigation** — every screen with all UI elements, component variants, and behavior described precisely enough to build from, plus a navigation map (tab/stack/drawer structure, screen transitions, and deep-link routes)
- **Device Permissions & Capabilities** — for each capability (camera, location, contacts, biometrics, notifications, etc.): when it is requested, the user-facing rationale string, and how granted, denied, and "denied permanently" states are handled. Omit only if the app requests no device permissions.
- **Offline & Data Sync** — local storage choice, what is cached, per-screen offline behavior, sync and conflict-resolution strategy, and optimistic-update rules. Omit only if the app requires a connection for everything.
- **Backend Dependencies** — base URLs per environment, auth/token handling and refresh flow, every endpoint the app consumes (method, path, purpose, response shape), the error contract, and retry/timeout behavior. If no backend exists yet, note that it must be built (see the API / Backend Kickoff prompt). Omit only if the app is fully offline with no backend.
- **Permissions & Access Control** — app roles, gated screens/actions, and auth states (logged out, logged in, token expired). This is about app authorization, distinct from device permissions above. Omit only if the app has no accounts or privileged actions.
- **User Flows** — numbered step-by-step flows for each primary use case
- **Empty States** — what to show when there is no data, for each relevant screen
- **Error Handling** — error response format, user-facing error messages, offline/network-failure behavior, retry strategy, and logging/crash-reporting approach
- **Push Notifications** — provider, payload shapes, deep-link-on-tap behavior, permission-prompt timing, and foreground vs. background handling. Omit if the app sends no push notifications.
- **Security** — secret/key storage (Keychain/Keystore), token storage, certificate pinning, input validation, and handling of sensitive data on device
- **Project Structure** — full folder/file tree with inline comments explaining each file's role
- **Environment Variables** — build-time config and per-platform secrets handling, `.env.example` with placeholder values, critical rules (e.g. what to never commit)
- **App Store & Release** — bundle/application IDs, signing, build/release pipeline, store metadata, minimum OS versions, and rollout strategy (phased release, OTA updates where applicable)
- **Testing Strategy** — what to test at each level (unit, component, end-to-end on device/simulator), key flows to cover, recommended tools
- **Implementation Order** — numbered build steps in the correct sequence

### 2. `DECISIONS.md`

An architectural decisions record (ADR) for every major technical choice (native vs. cross-platform, navigation library, state management, local storage, push provider, repo structure, etc.). For each decision:

- **Decision:** What was chosen and when
- **Alternatives considered:** Comparison table (option, pros, cons, complexity/cost)
- **Why this choice:** 3–5 specific bullet reasons
- **When to reconsider:** Concrete triggers for revisiting (e.g. "if we add a third platform" or "if offline data exceeds X")

End with a summary table of all decisions.

### 3. `OPEN_QUESTIONS.md`

- Unresolved decisions that must be answered before build starts (placeholders, unknowns, TBDs)
- Edge cases and spec gaps that weren't covered
- Conflicts between requirements or between design and spec
- Post-v1 improvement ideas to revisit later

---

> **Goal:** The documents should be precise enough for an AI coding assistant to implement the entire app from scratch without asking clarifying questions.
