---
description: Create a new Architecture Decision Record (ADR)
handoffs: []
scripts:
  sh: scripts/bash/create-adr.sh --json "{ARGS}"
  ps: scripts/powershell/create-adr.ps1 -Json "{ARGS}"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/speckit.adr` in the triggering message **is** the ADR title or decision description. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that decision description, do this:

1. **Generate a concise slug** from the title:
   - Extract meaningful keywords from the title
   - Create a kebab-case slug (e.g., "use-postgresql" from "Use PostgreSQL for primary database")
   - Keep it descriptive but concise (3-5 words maximum)

2. **Run the ADR creation script** `{SCRIPT}`:
   - Pass the title to the script
   - Bash example: `{SCRIPT} --json "Use PostgreSQL for primary database"`
   - PowerShell example: `{SCRIPT} -Json "Use PostgreSQL for primary database"`
   - The JSON output will contain ADR_NUM, ADR_FILE, and ADR_TITLE

   **IMPORTANT**:
   - You must only ever run this script once per ADR
   - The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for
   - For single quotes in args like "I'm choosing X", use escape syntax or double quotes

3. Load `templates/adr-template.md` to understand required sections.

4. Follow this execution flow:

   1. Parse user description from Input
      If empty: ERROR "No decision title provided"
   2. Extract key concepts from the decision description
      Identify: the decision topic, technology choices, architectural concerns
   3. For unclear aspects:
      - Make informed guesses based on context
      - Only mark with [NEEDS CLARIFICATION: specific question] if:
        - The decision scope is genuinely ambiguous
        - Multiple incompatible interpretations exist
      - **LIMIT: Maximum 2 [NEEDS CLARIFICATION] markers**
   4. Fill in the Context section
      Describe the problem or situation requiring a decision
   5. Generate the Decision section
      State what was decided clearly and concisely
   6. Document Consequences
      List positive, negative, and neutral outcomes
   7. Document Alternatives Considered
      Include at least 2 alternatives with pros/cons and why they weren't chosen
   8. Return: SUCCESS (ADR ready for review)

5. Write the ADR to ADR_FILE using the template structure, replacing placeholders with concrete details derived from the decision description.

6. **ADR Quality Validation**: After writing the initial ADR, validate it against quality criteria:

   a. **Validation Checklist**:
      - Decision is clearly stated
      - Context explains why a decision is needed
      - At least 2 alternatives are documented
      - Consequences cover positive, negative, and neutral outcomes
      - No [NEEDS CLARIFICATION] markers remain

   b. **Handle Validation Results**:
      - If items fail, update the ADR to address issues
      - If [NEEDS CLARIFICATION] markers remain, present options to user

7. Report completion with ADR number, file path, and status.

**NOTE:** The script creates the ADR file with the next available number before writing.

## General Guidelines

### Quick Guidelines

- Focus on **WHAT** was decided and **WHY**
- Document alternatives fairly, even the rejected ones
- Be honest about trade-offs and consequences
- Write for future team members who need to understand the decision

### Section Requirements

- **Mandatory sections**: Context, Decision, Consequences, Alternatives Considered
- **Optional sections**: Related Decisions, Notes
- When a section doesn't apply, remove it entirely

### For AI Generation

When creating this ADR from a user prompt:

1. **Make informed guesses**: Use technical knowledge to fill context gaps
2. **Document assumptions**: Note any assumptions made about the technical context
3. **Limit clarifications**: Maximum 2 [NEEDS CLARIFICATION] markers
4. **Be balanced**: Present alternatives fairly, acknowledge real trade-offs
5. **Common areas needing clarification** (only if genuinely unclear):
   - Scope of the decision (project-wide vs component-specific)
   - Constraints not mentioned (budget, timeline, team expertise)

**Examples of reasonable defaults** (don't ask about these):
- Standard industry practices for the technology choice
- Common security/compliance requirements for the domain
- Typical performance expectations for the use case
