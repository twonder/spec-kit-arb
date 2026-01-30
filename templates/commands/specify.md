---
description: Create or update the feature specification from a natural language feature description.
handoffs: 
  - label: Build Technical Plan
    agent: arb.plan
    prompt: Create a plan for the spec. I am building with...
  - label: Clarify Spec Requirements
    agent: arb.clarify
    prompt: Clarify specification requirements
    send: true
scripts:
  sh: scripts/bash/create-new-feature.sh --json "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json "{ARGS}"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/arb.specify` in the triggering message **is** the feature description. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that feature description, do this:

1. **Generate a concise short name** (2-4 words) for the branch:
   - Analyze the feature description and extract the most meaningful keywords
   - Create a 2-4 word short name that captures the essence of the feature
   - Use action-noun format when possible (e.g., "add-user-auth", "fix-payment-bug")
   - Preserve technical terms and acronyms (OAuth2, API, JWT, etc.)
   - Keep it concise but descriptive enough to understand the feature at a glance
   - Examples:
     - "I want to add user authentication" → "user-auth"
     - "Implement OAuth2 integration for the API" → "oauth2-api-integration"
     - "Create a dashboard for analytics" → "analytics-dashboard"
     - "Fix payment processing timeout bug" → "fix-payment-timeout"

2. **Check for existing branches before creating new one**:

   a. First, fetch all remote branches to ensure we have the latest information:

      ```bash
      git fetch --all --prune
      ```

   b. Find the highest feature number across all sources for the short-name:
      - Remote branches: `git ls-remote --heads origin | grep -E 'refs/heads/[0-9]+-<short-name>$'`
      - Local branches: `git branch | grep -E '^[* ]*[0-9]+-<short-name>$'`
      - Specs directories: Check for directories matching `specs/[0-9]+-<short-name>`

   c. Determine the next available number:
      - Extract all numbers from all three sources
      - Find the highest number N
      - Use N+1 for the new branch number

   d. Run the script `{SCRIPT}` with the calculated number and short-name:
      - Pass `--number N+1` and `--short-name "your-short-name"` along with the feature description
      - Bash example: `{SCRIPT} --json --number 5 --short-name "user-auth" "Add user authentication"`
      - PowerShell example: `{SCRIPT} -Json -Number 5 -ShortName "user-auth" "Add user authentication"`

   **IMPORTANT**:
   - Check all three sources (remote branches, local branches, specs directories) to find the highest number
   - Only match branches/directories with the exact short-name pattern
   - If no existing branches/directories found with this short-name, start with number 1
   - You must only ever run this script once per feature
   - The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for
   - The JSON output will contain BRANCH_NAME and SPEC_FILE paths
   - For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot")

3. Load `templates/spec-template.md` to understand required sections.

4. **Load user configuration** (if available):
   - Check for `.specify/local.config.json` in the repository root
   - If found, extract:
     - `user.name` → Use as Author
     - `user.team` → Use as Team
     - Determine System from the feature description or user's team config
   - If local config doesn't exist, use defaults:
     - Team: "shared"
     - System: "cross-cutting"
     - Author: Leave blank or use git user.name if available

5. Follow this execution flow:

    1. Parse user description from Input
       If empty: ERROR "No feature description provided"
    2. Extract key concepts from description
       Identify: actors, actions, data, constraints
    3. For unclear aspects:
       - Make informed guesses based on context and industry standards
       - Only mark with [NEEDS CLARIFICATION: specific question] if:
         - The choice significantly impacts feature scope or user experience
         - Multiple reasonable interpretations exist with different implications
         - No reasonable default exists
       - **LIMIT: Maximum 3 [NEEDS CLARIFICATION] markers total**
       - Prioritize clarifications by impact: scope > security/privacy > user experience > technical details
    4. **Quantifiable Value Section** (MANDATORY - Constitution Principle I):
       a. Identify 2-4 success metrics that will prove this feature delivers value
       b. For each metric, determine if a baseline measurement exists:
          - If YES: Document the current baseline and set a target
          - If NO: Mark "Baselines missing" checkbox
       c. If baselines are missing:
          - Create a Predecessor User Story (P0 priority) to establish measurement capability
          - This story MUST be completed before implementing other stories
          - The predecessor story should instrument/collect data needed for baseline
       d. Identify the value category (Revenue, Cost Reduction, UX, Risk, Productivity)
    5. Fill User Scenarios & Testing section
       If no clear user flow: ERROR "Cannot determine user scenarios"
    6. Generate Functional Requirements
       Each requirement must be testable
       Use reasonable defaults for unspecified details (document assumptions in Assumptions section)
    7. Define Success Criteria
       Create measurable, technology-agnostic outcomes
       Include both quantitative metrics (time, performance, volume) and qualitative measures (user satisfaction, task completion)
       Each criterion must be verifiable without implementation details
    8. Identify Key Entities (if data involved)
    9. **ADR Review and Creation** (MANDATORY - Constitution Principle II):
       a. List the ADR directory: `ls -la adrs/` (or configured adrDir)
       b. Read ALL existing ADRs to understand current architectural decisions
       c. For each ADR, determine if it applies to this feature:
          - If applicable: Add to "Referenced ADRs" section with explanation of relevance
          - If conflicts exist: Note in "ADR Compliance Notes" section
       d. Identify if this spec proposes NEW technologies, patterns, or architectural decisions:
          - New programming language, framework, or library not previously used
          - New integration pattern (message queue, event sourcing, etc.)
          - New data storage approach
          - New authentication/authorization mechanism
          - Significant deviation from established patterns
       e. For each new decision identified:
          - Add to "New ADRs Required" section as TODO
          - Include: decision topic, why it needs an ADR, alternatives to consider
       f. If no ADRs exist yet, note this and still identify decisions that SHOULD have ADRs
    10. **Availability Architecture** (MANDATORY for infrastructure/services - Constitution Principle III):
        a. Determine if this feature involves infrastructure or services
        b. If yes, explicitly declare the availability approach:
           - Single Region: State region, RTO/RPO, SPOFs, DR approach
           - Multi-Region Active-Active: All regions serve traffic, bidirectional replication
           - Multi-Region Active-Passive: Primary serves traffic, secondary on standby
        c. Document rationale for the choice (cost, latency, compliance, complexity)
        d. If multi-region, specify: failover strategy, consistency model, replication lag tolerance
        e. Cross-reference with FinOps section for cost implications
    11. **FinOps Section** (MANDATORY - Constitution Principle IV):
        a. Estimate costs for the proposed solution (compute, storage, network, etc.)
        b. Identify primary cost drivers and what scales with usage
        c. Compare costs against alternatives considered
        d. Document cost optimization opportunities
        e. Define budget ceiling, alert thresholds, and monitoring approach
        f. Calculate cost per unit (user/request/transaction)
        g. Note: If exact costs unknown, provide ranges and document assumptions
    12. Return: SUCCESS (spec ready for planning)

5. Write the specification to SPEC_FILE using the template structure, replacing placeholders with concrete details derived from the feature description (arguments) while preserving section order and headings.

6. **Specification Quality Validation**: After writing the initial spec, validate it against quality criteria:

   a. **Create Spec Quality Checklist**: Generate a checklist file at `FEATURE_DIR/checklists/requirements.md` using the checklist template structure with these validation items:

      ```markdown
      # Specification Quality Checklist: [FEATURE NAME]
      
      **Purpose**: Validate specification completeness and quality before proceeding to planning
      **Created**: [DATE]
      **Feature**: [Link to spec.md]
      
      ## Content Quality

      - [ ] No implementation details (languages, frameworks, APIs)
      - [ ] Focused on user value and business needs
      - [ ] Written for non-technical stakeholders
      - [ ] All mandatory sections completed

      ## Requirement Completeness

      - [ ] No [NEEDS CLARIFICATION] markers remain
      - [ ] Requirements are testable and unambiguous
      - [ ] Success criteria are measurable
      - [ ] Success criteria are technology-agnostic (no implementation details)
      - [ ] All acceptance scenarios are defined

      ## Quantifiable Value (Constitution Principle I)

      - [ ] Success metrics defined with specific targets
      - [ ] Baseline measurements documented OR marked as missing
      - [ ] If baselines missing: Predecessor user story (P0) included
      - [ ] Value category identified (Revenue/Cost/UX/Risk/Productivity)
      - [ ] Measurement method specified for each metric

      ## ADR Compliance (Constitution Principle II)

      - [ ] All applicable existing ADRs are referenced
      - [ ] New ADRs identified for new technologies/patterns
      - [ ] ADR compliance notes completed
      - [ ] No unresolved ADR conflicts

      ## Availability Architecture (Constitution Principle III)

      - [ ] Availability approach explicitly declared (Single/Multi-Region)
      - [ ] If Multi-Region: Active-Active or Active-Passive specified
      - [ ] Region selection rationale documented
      - [ ] RTO/RPO defined
      - [ ] Failover strategy documented (if applicable)
      - [ ] Or marked N/A with justification (no infrastructure impact)

      ## FinOps (Constitution Principle IV)

      - [ ] Cost estimates provided (monthly/annual)
      - [ ] Cost drivers identified
      - [ ] Cost comparison with alternatives included
      - [ ] Cost optimization opportunities documented
      - [ ] Budget ceiling and alert thresholds defined
      - [ ] Cost monitoring approach specified
      - [ ] Edge cases are identified
      - [ ] Scope is clearly bounded
      - [ ] Dependencies and assumptions identified
      
      ## Feature Readiness
      
      - [ ] All functional requirements have clear acceptance criteria
      - [ ] User scenarios cover primary flows
      - [ ] Feature meets measurable outcomes defined in Success Criteria
      - [ ] No implementation details leak into specification
      
      ## Notes
      
      - Items marked incomplete require spec updates before `/arb.clarify` or `/arb.plan`
      ```

   b. **Run Validation Check**: Review the spec against each checklist item:
      - For each item, determine if it passes or fails
      - Document specific issues found (quote relevant spec sections)

   c. **Handle Validation Results**:

      - **If all items pass**: Mark checklist complete and proceed to step 6

      - **If items fail (excluding [NEEDS CLARIFICATION])**:
        1. List the failing items and specific issues
        2. Update the spec to address each issue
        3. Re-run validation until all items pass (max 3 iterations)
        4. If still failing after 3 iterations, document remaining issues in checklist notes and warn user

      - **If [NEEDS CLARIFICATION] markers remain**:
        1. Extract all [NEEDS CLARIFICATION: ...] markers from the spec
        2. **LIMIT CHECK**: If more than 3 markers exist, keep only the 3 most critical (by scope/security/UX impact) and make informed guesses for the rest
        3. For each clarification needed (max 3), present options to user in this format:

           ```markdown
           ## Question [N]: [Topic]
           
           **Context**: [Quote relevant spec section]
           
           **What we need to know**: [Specific question from NEEDS CLARIFICATION marker]
           
           **Suggested Answers**:
           
           | Option | Answer | Implications |
           |--------|--------|--------------|
           | A      | [First suggested answer] | [What this means for the feature] |
           | B      | [Second suggested answer] | [What this means for the feature] |
           | C      | [Third suggested answer] | [What this means for the feature] |
           | Custom | Provide your own answer | [Explain how to provide custom input] |
           
           **Your choice**: _[Wait for user response]_
           ```

        4. **CRITICAL - Table Formatting**: Ensure markdown tables are properly formatted:
           - Use consistent spacing with pipes aligned
           - Each cell should have spaces around content: `| Content |` not `|Content|`
           - Header separator must have at least 3 dashes: `|--------|`
           - Test that the table renders correctly in markdown preview
        5. Number questions sequentially (Q1, Q2, Q3 - max 3 total)
        6. Present all questions together before waiting for responses
        7. Wait for user to respond with their choices for all questions (e.g., "Q1: A, Q2: Custom - [details], Q3: B")
        8. Update the spec by replacing each [NEEDS CLARIFICATION] marker with the user's selected or provided answer
        9. Re-run validation after all clarifications are resolved

   d. **Update Checklist**: After each validation iteration, update the checklist file with current pass/fail status

7. Report completion with branch name, spec file path, checklist results, and readiness for the next phase (`/arb.clarify` or `/arb.plan`).

**NOTE:** The script creates and checks out the new branch and initializes the spec file before writing.

## General Guidelines

## Quick Guidelines

- Focus on **WHAT** users need and **WHY**.
- Avoid HOW to implement (no tech stack, APIs, code structure).
- Written for business stakeholders, not developers.
- DO NOT create any checklists that are embedded in the spec. That will be a separate command.

### ADR Guidelines

Architecture Decision Records are MANDATORY for specifications. Every spec must:

1. **Reference existing ADRs**: Read all ADRs in the `adrs/` directory and link any that apply
2. **Create new ADRs when needed**: If the spec proposes something new (technology, pattern, approach), create an ADR first
3. **Document compliance**: Note any tensions or full compliance with existing decisions

**When to create a new ADR**:
- Proposing a new technology not currently used in the project
- Introducing a new architectural pattern (event sourcing, CQRS, etc.)
- Choosing between competing approaches with significant trade-offs
- Deviating from an established convention

**To create a new ADR**, use:
```bash
./scripts/bash/create-adr.sh "Decision title"
# or PowerShell:
./scripts/powershell/create-adr.ps1 "Decision title"
```

**ADR content should include**:
- Context and problem statement
- Decision drivers (requirements, constraints)
- Considered options with pros/cons
- Decision outcome and rationale
- Consequences (positive, negative, neutral)

### Section Requirements

- **Mandatory sections**: Must be completed for every feature
- **Optional sections**: Include only when relevant to the feature
- When a section doesn't apply, remove it entirely (don't leave as "N/A")

### For AI Generation

When creating this spec from a user prompt:

1. **Make informed guesses**: Use context, industry standards, and common patterns to fill gaps
2. **Document assumptions**: Record reasonable defaults in the Assumptions section
3. **Limit clarifications**: Maximum 3 [NEEDS CLARIFICATION] markers - use only for critical decisions that:
   - Significantly impact feature scope or user experience
   - Have multiple reasonable interpretations with different implications
   - Lack any reasonable default
4. **Prioritize clarifications**: scope > security/privacy > user experience > technical details
5. **Think like a tester**: Every vague requirement should fail the "testable and unambiguous" checklist item
6. **Common areas needing clarification** (only if no reasonable default exists):
   - Feature scope and boundaries (include/exclude specific use cases)
   - User types and permissions (if multiple conflicting interpretations possible)
   - Security/compliance requirements (when legally/financially significant)

**Examples of reasonable defaults** (don't ask about these):

- Data retention: Industry-standard practices for the domain
- Performance targets: Standard web/mobile app expectations unless specified
- Error handling: User-friendly messages with appropriate fallbacks
- Authentication method: Standard session-based or OAuth2 for web apps
- Integration patterns: RESTful APIs unless specified otherwise

### Success Criteria Guidelines

Success criteria must be:

1. **Measurable**: Include specific metrics (time, percentage, count, rate)
2. **Technology-agnostic**: No mention of frameworks, languages, databases, or tools
3. **User-focused**: Describe outcomes from user/business perspective, not system internals
4. **Verifiable**: Can be tested/validated without knowing implementation details

**Good examples**:

- "Users can complete checkout in under 3 minutes"
- "System supports 10,000 concurrent users"
- "95% of searches return results in under 1 second"
- "Task completion rate improves by 40%"

**Bad examples** (implementation-focused):

- "API response time is under 200ms" (too technical, use "Users see results instantly")
- "Database can handle 1000 TPS" (implementation detail, use user-facing metric)
- "React components render efficiently" (framework-specific)
- "Redis cache hit rate above 80%" (technology-specific)
