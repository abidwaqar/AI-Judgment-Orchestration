<!-- Adapted from the orchestration behind Gryter (gryter.com), an AI fitness coach built by one engineer. -->
# This repository is the starter itself

This repo holds the orchestration starter: the skills and agents under `.claude/`, the `README.md`, and the walk-through in `docs/orchestration.md`. It is not a project that uses them.

A project that copies `.claude/` gets its own `CLAUDE.md` section ("How we work") from the `adapt-to-your-project` skill. Don't run that skill here: it would fill the slots this starter exists to carry.

When you change the starter:
- **Keep every `ADAPT:` slot** (`<!-- ADAPT:<slot-name> — what goes here, and an example -->`, or a `# ADAPT:` comment inside agent frontmatter). The setup skill finds them by that marker.
- **Keep every attribution line** exactly as it is: right after the frontmatter, the first line of a markdown file without frontmatter, or line 2 of `gpt-model.sh`.
- **Keep the frontmatter first** in every `SKILL.md` and agent file, valid YAML with `name` and `description`, or the skill or agent won't load.
- **Name only skills and agents that exist** under `.claude/` (Claude Code's built-in `Explore` agent aside).
- **Keep the files free of any one project's specifics:** its product, stack, people, numbers and paths belong in slots, filled in the project that uses the starter.
