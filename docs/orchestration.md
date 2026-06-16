# The orchestration, annotated

One command in. A reviewed, tested change out. The `product-lead` skill runs this pipeline; you appear twice — to ask, and to review the final diff.

```mermaid
flowchart TD
  H1(["👤 You: /product-lead — 'build X'"]):::human
  P1["Lead · capture & scope<br/>reads CLAUDE.md · existing code · runtime signals"]:::lead
  Q1{"UI change?"}:::gate
  DES["Designer<br/>flows + all 5 states"]:::designer
  Q2{"new data model /<br/>architecture?"}:::gate
  ARCH["Architect<br/>options matrix → decision record"]:::architect
  ENG["Senior software engineer<br/>plan → implement → unit tests → lint"]:::engineer
  P5["Spec check · the designer & architect come back<br/>does the build match the spec THEY wrote?"]:::review
  QA["QA<br/>risk-based test plan → tests<br/>runs the suite itself via MCP"]:::qa
  P7["Final review · code reviewer ∥ security<br/>fresh-eyes audit on stable code"]:::review
  H2(["👤 You review the diff — only human commit"]):::human

  H1 --> P1 --> Q1
  Q1 -- yes --> DES --> Q2
  Q1 -- no --> Q2
  Q2 -- yes --> ARCH --> ENG
  Q2 -- no --> ENG
  ENG --> P5
  P5 -- "diverged → fix → re-verify · ≤2 rounds" --> ENG
  P5 -- matches spec --> QA
  QA --> P7
  P7 -- "P0 / P1 → fix → re-verify · ≤2 rounds" --> ENG
  P7 -- clean --> H2

  MCP["MCP rail: database · toolchain (lint, tests, runtime errors) · preview or device control"]:::mcp
  ENG -.-> MCP
  QA -.-> MCP

  classDef human fill:#F2F6FF,stroke:#F2F6FF,color:#0B1220,font-weight:bold
  classDef lead fill:#18243A,stroke:#2F6BFF,color:#F2F6FF,stroke-width:2px
  classDef gate fill:#111B2E,stroke:#7E8BA6,color:#B8C4DA
  classDef engineer fill:#16223B,stroke:#2F6BFF,color:#F2F6FF
  classDef designer fill:#1d1830,stroke:#C084FC,color:#F2F6FF
  classDef architect fill:#111B2E,stroke:#B8C4DA,color:#F2F6FF
  classDef review fill:#251f10,stroke:#FBBF24,color:#F2F6FF
  classDef qa fill:#0f241e,stroke:#2DD4A3,color:#F2F6FF
  classDef mcp fill:#0e1c2e,stroke:#60A5FA,color:#B8C4DA
```

## Reading it in one breath

- **The two white nodes are you.** You confirm scope at the start and review the diff at the end. Everything between is agents.
- **Diamonds are the lead's judgment calls.** Phases get *skipped* when they'd add nothing — a backend-only change skips the designer; a copy tweak skips almost everything. Right-sizing is the point, not running all eight phases mechanically.
- **The two amber boxes are review passes.** The first is the **designer & architect coming back to check the build against the spec they wrote** — spec drift caught before QA wastes effort. The second is fresh-eyes code review + security on stable code.
- **Each amber box loops back to the engineer** if it finds P0/P1 problems — capped at **2 rounds**, then it escalates to you instead of grinding forever.
- **The dotted rail is how agents touch the real world.** Wire MCP tools to your stack — your database, your lint/test toolchain, a preview server or device — and the engineer and QA can verify their own work instead of guessing.

## Why this order

1. **Scope before spawning.** The lead mines your `CLAUDE.md` and existing code first, so specialists start oriented (and cheap).
2. **Design/architecture before code**, but only when the change warrants it.
3. **Spec-compliance review before QA**, so tests are written against a target that won't shift under them.
4. **Code review + security last**, on stable code, so the audit reflects what actually ships.
5. **Human gate always.** No agent commits. You review the diff.

## Right-sizing

| Change type | Phases that typically run |
|---|---|
| Copy / one-line tweak | engineer → code review |
| New screen / component | designer → engineer → spec check → light QA → code review |
| Feature with backend work | the full pipeline |
| Auth / payments / data-integrity | full pipeline + mandatory security + heavier QA |
| Refactor | architect (if structural) → engineer → regression-focused QA → code review |

The orchestrator decides per task. The goal is to invoke a phase only when its specialist would catch something the others wouldn't.
