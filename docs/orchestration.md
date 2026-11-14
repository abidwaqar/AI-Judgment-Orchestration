<!-- Adapted from the orchestration behind Gryter (gryter.com), an AI fitness coach built by one engineer. -->
# How the orchestration works, and why

This is the longer walk through the flow. The skills themselves say *what* to do; this says *why*, so you can tell which rules to keep exactly and which to bend for your project.

Most of the rules exist because the obvious way failed once. When a skill names the incident behind a rule, that rule is meant to be followed exactly. Everything else is a playbook: when a work item doesn't fit it, the lead says so, does what serves the outcome, and records what it did instead.

## The shape

There are two leads, and both run in your main conversation, because both need to talk to you.

- **The product lead** settles one work item's requirements with you, before any branch exists. It only reads.
- **The delivery lead** takes a settled item to a merged pull request. It doesn't write the plan or the code; a `software-engineer` subagent does both, and stays warm from the plan to the last repair.

Between them, three decisions are yours, and only yours:

1. **The requirements:** what the item does, what it doesn't, and the states that must work.
2. **The plan:** the direction the build will take.
3. **The result:** the pull request, which merges only when you say it's approved.

Everything else is delegated, and checked by something other than the thing that did it.

## Why three decisions, and why those three

Judgement compounds. A wrong requirement makes every later step correct work on the wrong thing, a wrong plan makes every later line correct code in the wrong direction, and a wrong merge ships it. Those are the three points where a person's call is worth the most and is hardest to recover later.

Everything between them can be checked: code against tests, tests against the code, the plan against the repository, the build against the requirements. So that's where the AI works, and where an independent reviewer checks it.

## Settling requirements before a branch exists

A delivery that stops halfway to ask a product question has wasted its context and your time. So the product lead settles the questions first, and writes them down where your project keeps requirements, with every decision and its reason. Then the delivery lead can go from a fresh branch to a plan without asking you anything, and nobody reopens a settled choice later, because the reason is written beside it.

**An explorer reads the code first.** It's a fresh session (by default a GPT model through the Codex CLI) that reports how the area works today, whether the product already does what's asked, what the change would touch, and a rough size. The report's main value is to the product lead: its questions to you are then about real choices, not things the code could have answered. The engineer gets the same report later, word for word, as a starting map.

**Plain language first.** Every finding and question reaches you in plain words with an example, and the technical account goes underneath. The same content, ordered so the sentence that lands comes first.

**Acceptance criteria describe the common path.** They say what a person experiences, and they don't demand guarantees about rare concurrent orderings. Those go in the out-of-scope list, with the ones that could corrupt or expose data named, so you decide with eyes open. A single criterion that demanded a guarantee about a rare race once turned a small fix into round after round of review and a string of regressions, while the bug people actually hit was on the common path all along.

**Mockups only for new UI, and directions before detail.** If an item doesn't add a screen, a dialog, a setting or a new kind of element, it gets no mockups: the requirements point at the existing element it copies. When there's more than one plausible shape, the designer draws a few direction sketches first, and only after you pick one does it draw every state. Detail drawn before the direction is settled gets thrown away.

**Research only when it decides something.** The `web-researcher` agent has no access to the repository on purpose: it reports what the world does, not a defence of what you already have. It's time-boxed, and it stops once the deciding facts are in.

## The mid-level plan

The engineer writes the plan into one document with four sections: your requirements, copied word for word; the plan in plain language, which is what you approve; the technical plan, which is what the reviewer reads; and an append-only log of what each review found and what was done about it.

**Why mid-level.** A plan is worth something when someone else can find a wrong direction in it before any code exists. That needs the approach, the parts, the data model and contracts, the failure paths people can hit, and how each acceptance criterion will be proved. It doesn't need line-level steps: those go stale the moment building starts, and they're better reviewed as code, where tests can check them.

**Why one document.** Two files drift apart, and a reviewer then judges a plan against requirements it was handed separately.

**The engineer never edits the requirements.** When it thinks one is wrong, it brings that back, and you rule on it. That rule catches requirement errors before they ship.

**Be loudest about the least certain part.** A plan that says "this is the risky bit, and here's why" is worth more than one that reads smoothly. Smooth plans hide their weak joints.

**Name the numbers.** If the change should move a measurable thing, the plan names its current value, how it was measured, and the target, and the numbers that must not move. A measured baseline once showed that the obvious fix made things worse, and saved a whole delivery.

## A reviewer from another AI family

Claude writes the plan and the code. The reviewer is a GPT model, run through the Codex CLI. That's the point of the whole arrangement: a reviewer that shares the author's training shares its blind spots, and will agree with its mistakes.

The recipe is deliberately strict:

- **Read-only, in the background, prompt on stdin.** The review runs with `codex exec` in a read-only sandbox, launched from the main conversation so you can keep talking to the lead while it runs. The prompt goes in on stdin, because long prompts break as arguments.
- **A fresh session every round.** A resumed session drags the previous round along on every step, so it costs more and reviews worse.
- **The reviewer reads the repository itself.** Nobody pastes it a diff or a summary, because a pre-digested change is a change someone else has already framed.
- **Don't tell it where the risk is.** Naming a few areas gets the rest a shallow pass that still reports itself as complete.
- **One reviewer, not a panel split by concern.** Their remits overlap, so you pay several times for the same findings. The one exception is the UX review, which judges only what a person experiences, from screenshots and the plan, and runs in parallel with the code review.
- **Check the verdict's shape.** A review must parse against its rulebook's output contract, and its verdict must match its own findings: approved means complete coverage and no findings, approved with notes means only minor ones, and blocked means a serious finding or any ground left unwalked. A review that doesn't fit that shape, or a timeout, isn't a verdict. It's an infrastructure failure, and the lead retries.
- **The lead never fills the gap with its own review.** It orchestrated the work, so it isn't independent of it.

**When GPT can't run.** If a retry fails too, the lead asks you. You can fix the GPT side, or choose the Claude fallback: the `delivery-reviewer` agent, whose every verdict is recorded as NOT INDEPENDENT, in the plan and in the pull request. It's never started without your say-so. If you chose at setup to run without the Codex CLI, that choice stands for every delivery, and the label still goes on every verdict, so nobody mistakes a self-review for an independent one.

## How many rounds

**The plan gets one round of review,** and a second only if the repair changes direction: the architecture, the data, a dependency, a trust boundary, a user flow, the acceptance criteria, the scope or the numbers. There's never a third.

The cap exists because a plan can't be tested, so every finding on it is a hypothesis. The reviewer questions a guard, the engineer adds a guard, and the new guard becomes the next finding. Review rounds that keep growing on a plan are a sign that the questions belong in the implementation review, where the reviewer reads finished code against real test results.

**The lead says whether a repair changed direction, and why, in one line.** It benefits from calling a change small, so the call has to be visible.

**The implementation has no cap.** The lead runs another round while one would plausibly change what ships, and stops when it wouldn't. Each later round gets the earlier findings and asks what they missed, rather than repeating the same review.

**The cap stops review calls, never escalation.** If the lead goes ahead past a blocking verdict, you get a plain explanation and then the verdict, every unresolved serious finding and every gap in coverage, verbatim. Never summarized, never softened. A delivery once shipped over a blocking verdict whose findings had been reported as old problems; one of them was a real defect, and a person using the product hit it.

## Evidence and conclusions

When the engineer hands work to the reviewer, it splits its report in two. The **evidence** goes to the reviewer: what changed, every raw test result, and everything it couldn't verify. Its **conclusions** about its own work stay with the lead. A reviewer told what was already checked steers away from exactly those places.

The same instinct runs through the engineer's standard:

- **A test earns its place by failing when the behavior is wrong.** The engineer and the reviewer judge that by reading each test against the code. Nobody plants bugs to find out.
- **The full suite runs twice in a delivery:** once before the first implementation review, and once on the commit that merges. Between them, the tests for what changed run, and the engineer says why they cover it.
- **A claim that something is impossible or bounded comes with its proof or its falsifier.** A confident "this can't happen" is a belief, not an observation, and reviewers are good at finding the difference.
- **Unverified stays labelled unverified,** with what could go wrong and how a person would check it by hand.

## The AI sees the running app

Green tests and a clean type check prove the code compiles and does what the tests ask. They don't prove the screen looks right, the error state is reachable, or the flow makes sense. So the engineer looks at what it built, running, before handing it back.

How it looks depends on the project, and the setup skill fills it in: an emulator or simulator driven through a mobile MCP, a browser driven through Playwright or Claude Code's built-in browser, or, for a backend, calls to its API and a read of its logs.

Two rules keep this honest. **Say what's running:** which branch's build, and whether the services it needs are up. A screen showing yesterday's build, or a front end whose backend is down, shows errors that aren't the change's. And **capture every state, not only the good one:** loading, empty, error and offline get their own screenshots, named by screen and state, because the ideal state is the one that least needs checking.

For a change people see, those screenshots go to the UX reviewer, who judges them against the experience you approved.

## Keeping current with the base branch

Other work lands on the base branch while a delivery runs. The lead pulls it in at safe points (before the plan review, before building, before each implementation round, before the pull request and before the merge), and never while a review is running or the engineer is mid-task. `git fetch` is the only evidence that the base moved, not someone's message saying so. That way every decision is made on current code, and conflicts stay small.

## When you step away

You can tell the lead you're going away. It then decides the two-way doors itself (anything easy to undo that wastes little work if wrong: a review finding, a choice inside the plan, a test, whether another round is worth it) and logs each with its reasoning for the pull request. One-way doors wait for you: production, merging, anything destructive, anything that reaches a real person, new dependencies, the shape of stored data, and anything outside the requirements you signed off. When you're back, you get one message: what it decided, what's waiting, and where things stand.

## Adapting it to your project

The skills carry marked slots wherever they need a fact about your project: your stack, your app type, how the AI sees your running app, your design tokens and voice, where requirements live, your commands, your branch model and an optional domain expert. The `adapt-to-your-project` skill reads your project, asks only what it can't infer, fills the slots, and removes what doesn't apply, such as the emulator steps for a website or the screenshot steps for a backend.

What it doesn't change is the method: the three decisions, the mid-level plan, the reviewer from another family, the round rules and the output contracts. If your project needs one of those changed, change it on purpose, and keep the reason beside it.
