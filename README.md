# plain-writing

A skill that makes Claude write like a person.

Models are decent at code and bad at the prose around it. You get comments that
restate the line below them, READMEs with badge rows and a Contributing section
for a project with one contributor, PR bodies that open with "This PR implements
a comprehensive fix" and close with a bulleted list of the diff. This skill is
the rules that stop that, in one file the model loads before it writes anything.

It covers code comments, docstrings, tool and API descriptions, READMEs, commit
messages, PR titles and bodies, review replies, issue comments, and release
notes.

Works in [Claude Code](https://claude.com/claude-code) and in
[Wizard](https://github.com/teddytennant/wizard). Same file, same rules.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/teddytennant/plain-writing/main/install.sh | bash
```

That installs into whichever of `claude` and `wizard` it finds on your PATH, and
falls back to `~/.claude/skills` if you have neither. Restart Claude Code, or run
`/reload` in Wizard.

<details>
<summary>Manual install</summary>

Claude Code:

```
/plugin marketplace add teddytennant/plain-writing
/plugin install plain-writing@plain-writing
```

Wizard, from a checkout:

```bash
git clone https://github.com/teddytennant/plain-writing
bash plain-writing/plugins/plain-writing/wizard/install.sh
```

Anything else that reads `~/.claude/skills`:

```bash
git clone https://github.com/teddytennant/plain-writing
mkdir -p ~/.claude/skills
cp -r plain-writing/plugins/plain-writing/skills/plain-writing ~/.claude/skills/
```

</details>

## Use

It triggers on its own when the model is about to write a comment, a doc, a
commit message, or a PR body, and when you say something reads like AI. You can
also call it directly in either tool:

```
/plain-writing
```

With no arguments it loads the rules for the rest of the session. Point it at
text you already have and it will cut that down instead.

## What it actually enforces

No em dashes. No delve, leverage, robust, seamless, comprehensive, "it's worth
noting". No bullet list that repeats the paragraph above it. No badge rows or
boilerplate sections in a README. No "should fix" when you either checked or you
did not. Never naming a command you did not run.

Comments say why, not what. Docstrings lead with the one sentence the caller
needs. PR bodies are what broke, how to see it, what you changed, how you
verified. Then a last pass that cuts the first sentence and the last sentence,
because those are usually the padding.

The full rules are in [SKILL.md](plugins/plain-writing/skills/plain-writing/SKILL.md).
It is short enough to read in one sitting, and you should, since you are the one
who has to agree with it.

## License

MIT
