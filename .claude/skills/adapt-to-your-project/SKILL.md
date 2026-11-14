---
name: adapt-to-your-project
description: "Run once, right after copying these orchestration files (.claude/skills and .claude/agents) into a project. Reads the project, asks the user only what it can't infer, fills every ADAPT slot under .claude/, removes the sections that don't apply, and writes a short How we work section into the project's CLAUDE.md. Use when the user has just added this starter, or asks to set up, adapt or configure the orchestration for their project."
---
<!-- Adapted from the orchestration behind Gryter (gryter.com), an AI fitness coach built by one engineer. -->

# Adapt the orchestration to your project

These skills and agents arrive with a marked slot wherever they need a fact about the project:

    <!-- ADAPT:<slot-name> — what goes here, and an example -->

In agent frontmatter, where an HTML comment would break the YAML, the same slot is a `# ADAPT:<slot-name> — …` comment.

Your job is to replace every slot with this project's facts, remove what doesn't apply, and leave the method itself intact. Work in the main conversation, with the user. Here, *the user* is the person working with you.

## The rules while you work

- **Never remove or change an attribution line.** Every file carries one: the comment that begins "Adapted from the orchestration behind" (an HTML comment in markdown, a `#` comment on line 2 of `gpt-model.sh`). In every file that stays, it stays exactly as it is, in the same place. Count the files that carry it before you start and when you finish.
- **Change facts, not the method.** Fill slots and cut what doesn't apply. Don't reword the rules, the round limits, the review recipe or the output contracts. If the project needs a rule changed, say so to the user and change it only on their word.
- **Don't fill this skill's own text.** Its slot examples are documentation. Leave `.claude/skills/adapt-to-your-project/` out of every search and edit.
- **Edit, don't overwrite.** The project's existing `CLAUDE.md`, `AGENTS.md` and `.gitignore` belong to the user: add to them, and never truncate them.
- **Touch nothing else.** Edit only `.claude/`, `CLAUDE.md` (or `AGENTS.md`) and `.gitignore`. Don't install anything, and don't commit: leave both to the user.

## 1. Read the project

Infer what you can before asking anything:
- **What's here:** the `README`, an existing `CLAUDE.md` or `AGENTS.md` (and any area-level ones), and the folder layout two levels deep.
- **The stack:** the manifest and lock files (`package.json`, `pyproject.toml`, `requirements.txt`, `go.mod`, `Cargo.toml`, `Gemfile`, `pom.xml`, `build.gradle`, `pubspec.yaml`, `*.csproj`, `composer.json`), framework config files, and infrastructure files (`Dockerfile`, `docker-compose.yml`, deployment config).
- **The app type:** a mobile project (`android/`, `ios/`, an app manifest), a website (pages, a dev server, static output), a backend (routes and handlers, no UI), or several.
- **The commands:** the scripts in the manifest (`build`, `dev`, `start`, `test`, `lint`, `typecheck`), a `Makefile` or task runner, and what CI runs (`.github/workflows/` or other CI config). CI is often the most honest list of the real checks.
- **The design system:** theme or token files, CSS variables, a Tailwind or similar config, a components folder, font files, a logo.
- **The voice and names:** the product's own copy, in its UI strings and its README.
- **Git and GitHub:** `git remote -v`; the default branch (`git symbolic-ref refs/remotes/origin/HEAD`); long-lived branches such as `develop` or `staging`; whether `gh` is installed and logged in (`gh auth status`), and whether the repository has issues (`gh repo view --json hasIssuesEnabled`).
- **Codex:** `codex --version` and `codex login status`. If both work, independent reviews can run.
- **Seeing the app:** which tools this session has for it, such as a mobile MCP, a browser MCP (Playwright) or Claude Code's built-in browser, and whether an emulator, a simulator or a local URL is already set up.
- **Every slot:** `grep -rn "ADAPT:" .claude --exclude-dir=adapt-to-your-project`. Note each file, line and slot name. The slots are `stack`, `app-type`, `see-the-app`, `design-tokens`, `voice`, `requirements-home`, `commands`, `domain-expert` and `branch-model`.
- **The attribution lines:** `grep -rlF "Adapted from the orchestration behind" .claude | wc -l`. Note the count.

## 2. Ask only what you couldn't infer

A few questions at a time, two or three per message. For each, say what you inferred and from where, and give your recommendation, so most answers can be a "yes".

1. **The app type:** a mobile app, a website, a backend, or a mix, and the sizes and themes it supports.
2. **How the AI should see the running app:**
   - an emulator or simulator plus a mobile MCP, for a mobile app;
   - a browser tool, such as Playwright MCP or Claude Code's built-in browser, for a website;
   - or none, for a backend, where the engineer checks the running service through its API and logs instead.

   If the tool they pick isn't installed, say which one and how to add it.
3. **The design tokens and voice:** where they live, or "none yet". With none yet, the rules stay, and the `ui-ux-designer` skill's §6 *No tokens yet* applies: the designer proposes provisional tokens alongside the first item's mockups, the user approves them with that item's experience, the requirements carry them, and that item's delivery builds them into the code.
4. **Codex,** if the check in step 1 failed: will they install it (`npm install -g @openai/codex`, then `codex login`) for independent reviews? If not, say plainly what that means: every review then runs on the `delivery-reviewer` agent (and every UX review on the `ui-ux-designer` agent), Claude reviewing Claude's work, and every verdict is recorded as NOT INDEPENDENT. It's their choice; record it in step 5.
5. **Where requirements live:** GitHub issues (the default), or file mode: one markdown file per item in `.claude/requirements/`, git-ignored, so the product lead can write it without touching tracked files.
6. **The build, run and test commands** you couldn't confirm: above all the full suite, how to run one file's tests, and whether the full suite's output shows per-file counts.
7. **The branch model:** the base branch feature work starts from, the pull-request target, the merge style (squash by default), and who merges.
8. **A domain expert,** optional: a skill they have, or want, for the product's domain, and when to load it.

## 3. Fill every slot

For each slot found in step 1:
- **Replace the whole comment** with the fact, written in the voice of the file around it: a sentence or a short list, not a comment and not a placeholder. Keep a slot's example only where it is literally true for this project.
- **One fact, one wording.** The same slot name appears in several files; say the same thing in each, shaped to its sentence.
- **Replace every `<base>`** in `.claude/skills/` with the base branch's name, once the branch model is settled.
- **The `ui-ux-designer` agent's tools:** append the see-the-app tools to its `tools:` line, then delete its `# ADAPT:` comment.
- **The GPT model:** tell the user which model and effort `.claude/skills/product-lead/scripts/gpt-model.sh` names, and that they should set them to the strongest their Codex plan offers.
- **No design tokens yet:** fill each `design-tokens` slot with "None yet: see No tokens yet in §6." (in `references/mockups.md`, "in the skill's §6"), and keep both *No tokens yet* rules. Don't make up values here: the tokens are a design decision, made with the first item's mockups.

Remove what doesn't apply, a whole sentence, bullet or section at a time, so nothing reads half-cut:
- **A website:** no emulator, simulator or mobile MCP steps; the browser tool and the local URL stand in their place.
- **A backend with no UI:** remove the app-checking steps that need a screen (screenshots, the UX review sections in both leads, the mockup steps); the engineer checks the running service through its API and logs. Ask before deleting the `ui-ux-designer` skill and agent and `references/ux-review.md` outright. If the user agrees, delete them and remove every reference to them.
- **Requirements in files (file mode):** each item is `.claude/requirements/<slug>.md`, with the explorer's report beside it as `<slug>.explore.md`. In both leads, rewrite the `gh issue` commands to use those files, and the slug wherever they say `<N>`:
  - reading an item is reading its file; a new item is a new file named by the user's slug;
  - the file's first line is its status: `Status: open`, `Status: settled`, `Status: in progress`, `Status: closed (not planned): <reason>` or `Status: done (<pull request link>)`. Each lead updates it wherever its steps set a status or close the issue;
  - settling writes the `## Requirements (signed off <date>)` section into the file, and copies the approved mockup PNGs to `.claude/requirements/<slug>/`, referenced from there, because the delivery deletes `.claude/mockups/<slug>/` after the merge;
  - the history search (`git log --grep`) and the pull request's `Closes #N` line name the slug instead.

  The product lead's read-only rule already allows writing inside `.claude/requirements/`, and the delivery lead's clean-tree check ignores the folder because git does. A team that wants requirements shared can commit the folder instead: leave it out of `.gitignore`. Each settled file is then an uncommitted change, so the user commits it to the base branch before its delivery starts, because the delivery lead stops on uncommitted work.
- **No domain expert:** delete the domain-expert lines.
- **No Codex:** keep the Codex sections, since the user may install it later, and record the choice in step 5.

Add the delivery's scratch folders to the project's `.gitignore`, if they aren't there, and in file mode the requirements folder too, unless the team commits it:

    .claude/delivery-plans/
    .claude/mockups/
    .claude/requirements/

Then check:
- `grep -rn "ADAPT:" .claude CLAUDE.md --exclude-dir=adapt-to-your-project` finds nothing;
- `grep -rn "<base>" .claude/skills --exclude-dir=adapt-to-your-project` finds nothing;
- every `SKILL.md` and agent file still starts with its frontmatter, which parses as YAML with `name` and `description`;
- every skill or agent named anywhere under `.claude/` exists (Claude Code's built-in `Explore` agent aside).

## 4. The attribution lines

Count them again with the command from step 1. The count must match, less any file the user agreed to delete. Each line must be unchanged and in its place: right after the frontmatter's closing `---`, the first line of a markdown file without frontmatter, or line 2 of `gpt-model.sh`.

## 5. How we work, in CLAUDE.md

Write a short section into the project's `CLAUDE.md`, or update the one that is there. If `CLAUDE.md` only imports `AGENTS.md` (`@AGENTS.md`), write it into `AGENTS.md` instead. Keep it this short, with the brackets filled:

```markdown
## How we work

Three decisions stay with a person: the requirements, the plan, and the result.

- **Settle an item:** `/product-lead <item>` explores the code, asks what's ours to decide, and writes signed-off requirements to [where requirements live].
- **Build it:** `/delivery-lead <item>`. A `software-engineer` subagent writes a mid-level plan, an independent reviewer checks its direction, we approve it, the engineer builds, tests and checks the running app, the reviews run again, and a pull request into [the base branch] comes to us before the merge.
- **Reviews** run on [Codex: a GPT model from another AI family, so they are independent | the `delivery-reviewer` agent, because this project has no Codex CLI, so every verdict is NOT INDEPENDENT].
- **Standards:** `software-engineer` for code, [`ui-ux-designer` for anything people see or read, if it was kept,] `solutions-architect` for structural decisions.
```

`delivery-lead` reads the reviews line at the start of every delivery, so keep its wording. Name only the skills and agents still in `.claude/`: if the user agreed to delete the `ui-ux-designer` skill and agent, leave it out of the Standards line, and out of the reviews line's mention of UX reviews.

Then run step 3's reference check again, now over `CLAUDE.md` (or `AGENTS.md`) as well as `.claude/`: every skill or agent the new section names must exist.

## 6. Report back

End with a summary for the user:
- **what you set:** each slot name, with its value in a few words;
- **what you removed:** sections, steps and files, and why each didn't apply;
- **what's left for them:** tools to install (Codex, an MCP), answers they deferred, anything you couldn't confirm (such as a command you couldn't run), and that nothing is committed;
- **how to start:** `/product-lead` with their first work item.

Once this skill has run, it has nothing left to fill. Offer, in one line, to delete its folder, and delete it only on a yes.
