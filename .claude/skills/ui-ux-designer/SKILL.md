---
name: ui-ux-designer
description: "How to design and review anything people see or read in this product (screens, flows, states, copy): the method, the rules, the visual system, the voice and brand, and the product's names. Use it to design or build UI, to review a screen, a plan's UI or a pull request's screenshots, to write or check user-facing copy, and for the voice and brand in marketing and on the website."
---
<!-- Adapted from the orchestration behind Gryter (gryter.com), an AI fitness coach built by one engineer. -->

# UI/UX design

The method, the system and the rules. **The code is the reference for how each screen works today:** read a screen's code before designing a change to it. This skill doesn't describe screens one by one.

**The product.** <!-- ADAPT:app-type — what kind of product this is and where it runs, which sets the sizes to check and the platform conventions to follow. Example: "A mobile app for Android and iOS, checked at phone size, in dark and light themes." Another: "A website used on phones and desktops, checked at 390 and 1280 wide, light theme only." -->

## 1. Start with the sentence

Before designing or judging anything, write: **for [who], doing [job], at [moment].** A screen is only good or bad for a person, a job and a moment.

- **Who:** the people the product is for. Name the one who mustn't get lost (often the newcomer) and the one who mustn't be slowed (often the regular who uses it every day). A design that serves one by failing the other isn't done.
- **The job:** what they want right now, such as what to do next, whether something worked, or how far along they are.
- **The moment.** Most products have two kinds:
  - **The glance:** a person in the middle of something else. On the move, one hand, noise, a weak signal, a few seconds of attention. Big targets, values filled in, one obvious next action, almost nothing to read.
  - **The sit-down:** setting up, planning, reviewing. People read and compare, so explanations, detail, choices and charts belong here.

  A job that takes minutes of thought is a sit-down job wherever the person is. The commonest mistake is sit-down content on a glance screen.
- **People scan, take the first reasonable option, and muddle through.** A screen that only works when read carefully doesn't work.

## 2. The rules

### Hierarchy
- **One primary per surface: one accent-coloured element.** Usually that's the main action, the current item's marker, or one accent label. Two accent things means neither leads. A button repeated on every card is plain secondary, never the accent.
- **Three levels are enough,** each clearly different from the next.
- **Emphasise by de-emphasising:** quiet labels, loud values. Make the competing elements quieter rather than the important thing louder.
- **The primary moves with the task.** On a screen used over time (a multi-step form, a setup flow), the loudest thing is what comes next, never the last step.

### Grouping, spacing and alignment
- **Close means together.** The space inside a group is half the space between groups or less (8 inside, 24 between). An evenly spaced stack doesn't group.
- **The scale.** <!-- ADAPT:design-tokens — the spacing scale, screen side padding, and card padding and corner radii. Example: "Spacing 4, 8, 16, 24, 32, 48. Screen side padding 16. Cards padded 16, radius 12; nested surfaces radius 8." If there is no design system yet, write "none yet: the first item with UI proposes these in its plan". -->
- **One left edge per screen.** Table headers sit over their columns, and compared numbers are right-aligned.
- **Space before boxes:** add a border only when space can't group. No boxes inside boxes.
- **Whitespace communicates certainty.** Don't compress a screen to expose secondary information.

### Type
- **The project's text styles only, never one-off sizes.** <!-- ADAPT:design-tokens — the type scale, the typeface, and where the text styles live in code. Example: "Inter. Styles in src/theme/typography.ts: display 32/28 for page titles, headline 24/20, title 18/16 for sections and cards, body 16/14, label 13/12 for metadata." -->
- **Few sizes per screen.** Build hierarchy with weight and grey level (primary, secondary and muted text) before size. The biggest text is the most important thing.
- **Line height:** 120–130% for headings, 145–155% for body.
- **Case:** sentence case. Uppercase only for small spaced labels. Bold sparingly.
- **Never cut meaning.** A cut-off name is fine; a cut-off explanation isn't. Numbers that change, like timers, use tabular figures.

### Colour
- **Tokens, never raw colour values.** <!-- ADAPT:design-tokens — the colour tokens, where they live in code, and the themes. Example: "theme.colors in src/theme/colors.ts: accent, accentText, success, error, errorText, textPrimary, textSecondary, textMuted, surface, surfaceRaised, divider, scrim. Light is the default theme; dark is supported." If there is no design system yet, say so. --> Every surface works in every theme the product has.
- **One colour, one meaning:**
  - the accent is "do this" or "you are here", never "bad";
  - success is done or good;
  - error is something that can go wrong (destructive actions, failures), never a normal action or a running clock;
  - charts and bars are neutral unless the line is the screen's one accent element.
- **Accent words need a text-safe accent.** If the accent fails 4.5:1 as small text, keep a text-safe variant of it for words, and use the accent itself for fills, borders, icons and charts. A white label on an accent button is fine when it passes.
- **Error words** (messages, field errors, destructive labels) use the text-safe error colour. The plain error colour is for borders, icons, dots and fills.
- **A scrim is the same dark neutral in every theme,** with an alpha where it's used. A light scrim leaves a white card with no boundary.
- **Contrast:** 4.5:1 for normal text, 3:1 for large text (about 24 px regular, 19 px bold) and icons. Check coloured text on tints first.
- **A colour that carries meaning also gets a word or an icon.**
- **Gradients and glow come only from tokens,** and sparingly.

### Touch and platform
- **Targets at least 44 × 44** (points, dp or CSS px), about 8 apart, and bigger for glance actions. On a mouse-first website, keep targets comfortable and every control reachable by keyboard, with a visible focus state.
- **Frequent actions go big and low,** in thumb reach. Rare or risky ones can sit in the top corners. The best target is none: do the step for them.
- **A screen's main action stays in sight however long its list gets:** pinned at the bottom, with the list scrolling under it.
- **Work like the apps people already use:**
  - on mobile, labelled tabs in a bottom bar, and a back arrow plus the system back; on the web, links that look like links, and the browser's back button working;
  - dialogs with the confirming action where the platform puts it, a destructive one in the text-safe error colour;
  - swipe actions with a visible route and an undo;
  - overflow menus (⋮, ⋯) open the project's own menu part, never a stock popup that looks foreign.

  Break a convention only for a strong reason.
- **The same look means the same behaviour.** A label mustn't look like a tappable chip. Habit taps land on whatever sits where other screens have their main navigation.

### Feedback and states
- **Every action answers:**
  - the tap or click itself responds within 0.1 s;
  - past a second, show it's working;
  - past ten seconds, show progress and let the person leave (the work carries on).
- **Every screen has states beyond the ideal:** empty, loading, partial (none, one, many, long names, past a limit), error and offline. List and design each.
- **Moments in a flow are states too:** right after each action, the last step, and anything that only appears then, such as a question after the last step. Check each one lands on screen, not below it.
- **Empty:** what will appear, why it's useful, and the button to start. A new account sees what will appear, never zeros dressed as results.
- **Loading:** the outline of what's coming. Never flash a wrong state, such as "nothing yet".
- **Error and offline:** what happened in plain words, what still works, and what to do. Nothing typed is lost.
- **Success:** acknowledge it. The end of a task is what people remember.

### Flows
- **Write the steps** from "I want this" to "it's done". Count taps, scrolls, decisions, typing and waits; decisions and typing cost most.
- **Cut, strongest first:**
  1. remove the step by doing it for them;
  2. fill in the likely answer;
  3. offer fewer choices and recommend one (Hick's law);
  4. put advanced options one tap away.
- **Confirm only what can't be undone.** Everything else gets an undo.

### Navigation and structure
- **Know the top-level structure** (see the glossary in §4). A new feature goes one level down unless it's a frequent job of its own.
- **File by job, not by type:** put the answer where people look, and link to the detail.
- **Labels predict what's behind them.** Near-synonyms side by side confuse.
- **People always know where they are:** the selected tab or section, the title, a way back.

### Words
- **Buttons say what happens:** "Save", "Send invite", "Discard". Never "OK".
- **The person's words, not the system's:** "Couldn't save. Check your connection and try again.", not "Error 503". No internal codes.
- **The important word first:** "**2 left:** finish these to complete setup."
- **Messages say what happened,** and what to do or what still works.
- **One name per thing everywhere** (see the glossary). Cut words that don't help.
- **Copy is a claim about the product.** Check it's true in the code before writing or changing it.

## 3. Voice and brand

Marketing and the website use this section too.

<!-- ADAPT:voice — the product's voice in a sentence or two, what it never sounds like, and two or three lines of real copy in that voice. Example: "A calm, experienced professional: confident without being loud, supportive without being soft, direct without being cold. Never: hype, guilt, slang, jargon. 'Saved. You can change this any time in Settings.'" -->

- **How it writes,** whatever the voice:
  - explain why when a decision could surprise;
  - say what happens next;
  - short, specific sentences, with evidence and no invented certainty;
  - a lapse is information, never a character flaw: "No problem. I've adjusted what comes next.", never "You missed it again."
- **The product's principles,** if it has them written down (a mission, values), are in their source files. Read the source before paraphrasing them.
- **The brand outside the product** (the product itself uses tokens): <!-- ADAPT:design-tokens — the brand colours as hex values, the typeface, the icon style, and the logo files and where they live. Example: "Accent #4F46E5, background #F8FAFC, text #0F172A. Inter, with line icons. Logo: assets/brand/logo.svg, and logo-mark.svg for small sizes." -->
- **Approved exceptions to the one-accent rule:** list each here, with where it applies. Until one is approved, there are none.

## 4. The product

**How the product behaves comes from the code, not from memory or this skill.** Before designing or reviewing a screen, read the code behind what it shows (what a setting changes, where a number comes from) and the requirements of its work item. A design that contradicts the code is a finding, unless the requirements change that behaviour. The project's instructions apply too.

**The glossary.** Its names are decisions, and the code doesn't always follow them yet:

<!-- ADAPT:voice — the product's names: each thing people see, the one name it goes by, and any near-synonym that is never used; and the top-level navigation (its tabs or main sections). Example: "project: a set of tasks with a due date, never 'board'. Archive, not Delete, for a project that can come back. Tabs: Home · Projects · Inbox · Settings." -->

## 5. Shared parts

Reuse these before inventing anything. A new token or part needs a reason.

<!-- ADAPT:design-tokens — the shared components and where they live: buttons (primary, secondary, tertiary), cards, menus, dialogs, inputs, inline messages, empty states, settings rows, with their sizes and radii. Example: "Button in src/components/Button.tsx: primary is the accent fill with a white label, 48 high, radius 12; secondary is the raised surface with a 1 px divider border." -->

Whatever the parts are, these rules hold:
- **Buttons:** one primary per surface. Forward labels carry at most one arrow per surface. A disabled primary drops any gradient or glow. Under a primary, a tertiary action is quiet text, not a second accent.
- **Cards:** one surface colour, an optional 1 px divider border, minimal shadow, and at most one accent label each.
- **Menus:** a row that can't be chosen now stays, shown off: muted, its line saying why in place of what it does ("A project needs at least one task."), and no tap. Destructive rows are tinted with the error colour.
- **Messages from the product:** one shared part for a note in context, reused instead of new banners. A bold lead and one plain sentence, one at a time.
- **Inputs:** a visible border, a clear focus state in the accent, and muted helper copy.
- **Stats and figures:** values never wrap, clip or touch a divider.
- **Settings rows** open the editor their kind of value needs, so each kind is learned once:
  - an answer from setup or onboarding: its own page, with Save;
  - typed text: a sheet or dialog, with Save;
  - an easily reversed preference: a sheet that saves as chosen;
  - a switch, or two or three options: on the row itself.
- **Motion,** unless the design system says otherwise:
  - screens 180–220 ms, button feedback 90–120 ms;
  - entrances a short fade or a small slide;
  - reduced motion holds still;
  - haptics only for meaningful moments.
- **Accessibility, at the bar the `software-engineer` skill sets:** check every theme, overflow, contrast and target sizes. Icon-only controls need an accessible label, and an ambiguous icon gets text.

## 6. Design mode: before building

**Write down:**
- the sentence;
- the flow and its counts;
- every state, and its primary;
- where it lives;
- the words, in the voice.

**Mockups, while the requirements are settled:**
- **Only for new UI.** Mockups are for an item that adds a screen, a sheet or dialog, a setting or a new kind of element. Anything else gets no mockups and no UX review: the requirements describe the look in words, by pointing at the existing element it copies.
- **Direction sketches first.** A new or reworked editor or flow with more than one plausible shape gets 2–3 direction sketches before any full mockup: one sheet each, showing the key screen with the user's own example on it. The user picks one, and only then are full mockups drawn. Fidelity spent before the direction is settled gets thrown away.
- **Every state before sign-off.** A new or reworked screen has every state and action outcome drawn: the flow, slips, menus, the end, special cards, dialogs and edges, saving and refused, reopened, and every theme. Draw them from real tokens and parts.
- **Every card whole inside its frame.** Split edge cases across frames rather than stacking them.
- **How they're built and rendered** is in `references/mockups.md`. Read it before any mockup work.

The user approves the experience at requirements. The plan turns it into screens: states, primary, parts and copy for each. Departures go back to the user.

## 7. Review mode: judging a screen

**Evidence:**
- **screenshots of every state and every moment in the flow** (right after each action, the last step), at the sizes the product supports, and the flow as steps. Only the ideal state means the review is incomplete;
- **code only as evidence,** for what screenshots can't settle: exact spacing, which token, timeouts, unreachable states, what a screen reader hears. Never judge code quality.

**The routine:**
1. Write the sentence.
2. Squint: first, second, third; one accent element.
3. Check groups and edges.
4. Check type and colour.
5. Check reach and conventions.
6. Check states and feedback.
7. Count the flow.
8. Check where it lives, the names, and that the copy is true.
9. Sweep Nielsen's ten heuristics.
10. Rank.

**Each finding has five parts:**
- **where:** screen, element, state;
- **what happens:** something observable;
- **why it matters:** who, at which moment, how often, and which rule;
- **the fix:** a direction, plus "or an equivalent that does X";
- **done when:** the proving evidence, usually a named screenshot.

**Rank each finding:**
- **High:** it hurts the core job, or happens on every use;
- **Medium:** real effort now and then;
- **Low:** polish.

Put the most important first, and name the top one or two. Mark taste as taste. If a rule here caused the problem, propose the change. "Fine" needs evidence too.

## 8. Worked examples

These show the shape of a finding; they aren't screens of this product.

- **High. A sign-up form after a failed submit.** The error message appears at the top of the form, off screen, while the person is looking at the button. They tap again and nothing visibly changes. Fix: show the message beside the field, and move focus there. Done when a screenshot right after a failed submit shows the message next to the field.
- **High. The last step of a checklist.** The closing question appears below the screen, under a pinned bar, and nothing brings it into view. A person who doesn't scroll moves on without answering, so the answer is never recorded. Fix: bring it into view when the last item is ticked.
- **High. A dashboard.** The person's question is "is this working?", but the biggest thing answers "how much did I do?". The answer sits three taps away. Fix: the answer near the top, linking to the detail.
- **Medium. A banner's link.** It is accent text on an accent tint, below 4.5:1. The text-safe accent passes.
- **Medium. A picker.** It's a filtered list of dozens of options with no recommendation, and the likely choice is far down. Fix: recommend two or three with a reason, and keep search.
