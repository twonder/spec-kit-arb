---
description: Perform a non-destructive cross-artifact consistency and quality analysis across spec.md, plan.md, and related documents.
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Goal

Identify inconsistencies, duplications, ambiguities, and underspecified items across the core artifacts (`spec.md`, `plan.md`, and any additional documents in the feature directory) before implementation. This command should run after `/arb.plan` has produced a complete implementation plan.

## Operating Constraints

**STRICTLY READ-ONLY**: Do **not** modify any files. Output a structured analysis report. Offer an optional remediation plan (user must explicitly approve before any follow-up editing commands would be invoked manually).

**Constitution Authority**: The project constitution (`/memory/constitution.md`) is **non-negotiable** within this analysis scope. Constitution conflicts are automatically CRITICAL and require adjustment of the spec or plan—not dilution, reinterpretation, or silent ignoring of the principle. If a principle itself needs to change, that must occur in a separate, explicit constitution update outside `/arb.analyze`.

## Execution Steps

### 1. Initialize Analysis Context

Run `{SCRIPT}` once from repo root and parse JSON for FEATURE_DIR and AVAILABLE_DOCS. Derive absolute paths:

- SPEC = FEATURE_DIR/spec.md
- PLAN = FEATURE_DIR/plan.md

Additionally check for optional documents:
- RESEARCH = FEATURE_DIR/research.md (if exists)
- DATA_MODEL = FEATURE_DIR/data-model.md (if exists)
- CONTRACTS_DIR = FEATURE_DIR/contracts/ (if exists)

Abort with an error message if spec.md or plan.md is missing (instruct the user to run missing prerequisite command).
For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

### 2. Load Artifacts (Progressive Disclosure)

Load only the minimal necessary context from each artifact:

**From spec.md:**

- Quantifiable Value section (metrics, baselines, targets)
- Overview/Context
- Functional Requirements
- Non-Functional Requirements
- User Stories and acceptance criteria
- ADR References
- Availability Architecture declarations
- FinOps section
- Edge Cases (if present)

**From plan.md:**

- Architecture/stack choices
- Data Model references
- Phases and deliverables
- Technical constraints
- Constitution Check results

**From research.md (if exists):**

- Technology decisions and rationale
- Alternatives considered

**From data-model.md (if exists):**

- Entity definitions
- Relationships
- Validation rules

**From contracts/ (if exists):**

- API specifications
- Interface contracts

**From constitution:**

- Load `/memory/constitution.md` for principle validation

### 3. Build Semantic Models

Create internal representations (do not include raw artifacts in output):

- **Requirements inventory**: Each functional + non-functional requirement with a stable key (derive slug based on imperative phrase; e.g., "User can upload file" → `user-can-upload-file`)
- **User story/action inventory**: Discrete user actions with acceptance criteria
- **Plan coverage mapping**: Map each requirement/story to plan sections that address it
- **Constitution rule set**: Extract principle names and MUST/SHOULD normative statements
- **Value metrics**: Extract success metrics and their measurement status

### 4. Detection Passes (Token-Efficient Analysis)

Focus on high-signal findings. Limit to 50 findings total; aggregate remainder in overflow summary.

#### A. Duplication Detection

- Identify near-duplicate requirements
- Mark lower-quality phrasing for consolidation

#### B. Ambiguity Detection

- Flag vague adjectives (fast, scalable, secure, intuitive, robust) lacking measurable criteria
- Flag unresolved placeholders (TODO, TKTK, ???, `<placeholder>`, etc.)
- Flag [NEEDS CLARIFICATION] markers that weren't resolved

#### C. Underspecification

- Requirements with verbs but missing object or measurable outcome
- User stories missing acceptance criteria alignment
- Success metrics without baselines or targets
- Missing predecessor user stories when baselines don't exist

#### D. Constitution Alignment

- Any requirement or plan element conflicting with a MUST principle
- Missing mandated sections or quality gates from constitution
- Quantifiable Value section incomplete (Principle I)
- ADR references missing for new technologies (Principle II)
- Availability architecture not declared (Principle III)
- FinOps section incomplete (Principle IV)

#### E. Spec-Plan Alignment

- Requirements in spec not addressed by plan
- Plan elements not traceable to requirements
- Data entities in plan not defined in spec (or vice versa)
- Technology choices in plan not justified by ADRs

#### F. Inconsistency

- Terminology drift (same concept named differently across files)
- Conflicting requirements (e.g., one requires Next.js while other specifies Vue)
- Cost estimates that don't align with availability choices
- Success metrics that conflict with technical constraints

### 5. Severity Assignment

Use this heuristic to prioritize findings:

- **CRITICAL**: Violates constitution MUST, missing core spec artifact, missing quantifiable value, or requirement with no plan coverage that blocks baseline functionality
- **HIGH**: Duplicate or conflicting requirement, ambiguous security/performance attribute, untestable acceptance criterion, missing ADR for new technology
- **MEDIUM**: Terminology drift, incomplete FinOps section, underspecified edge case
- **LOW**: Style/wording improvements, minor redundancy

### 6. Produce Compact Analysis Report

Output a Markdown report (no file writes) with the following structure:

## Specification Analysis Report

| ID | Category | Severity | Location(s) | Summary | Recommendation |
|----|----------|----------|-------------|---------|----------------|
| A1 | Duplication | HIGH | spec.md:L120-134 | Two similar requirements ... | Merge phrasing; keep clearer version |

(Add one row per finding; generate stable IDs prefixed by category initial.)

**Spec-Plan Alignment Summary:**

| Requirement Key | Addressed in Plan? | Plan Section | Notes |
|-----------------|-------------------|--------------|-------|

**Constitution Alignment Issues:** (if any)

**Quantifiable Value Status:**
- Metrics defined: [count]
- Baselines established: [count]
- Predecessor stories needed: [count]

**Metrics:**

- Total Requirements
- Requirements with plan coverage (%)
- Ambiguity Count
- Duplication Count
- Critical Issues Count

### 7. Provide Next Actions

At end of report, output a concise Next Actions block:

- If CRITICAL issues exist: Recommend resolving before proceeding
- If only LOW/MEDIUM: User may proceed, but provide improvement suggestions
- Provide explicit command suggestions: e.g., "Run /arb.specify with refinement", "Run /arb.plan to adjust architecture", "Create ADR for [technology choice]"

### 8. Offer Remediation

Ask the user: "Would you like me to suggest concrete remediation edits for the top N issues?" (Do NOT apply them automatically.)

## Operating Principles

### Context Efficiency

- **Minimal high-signal tokens**: Focus on actionable findings, not exhaustive documentation
- **Progressive disclosure**: Load artifacts incrementally; don't dump all content into analysis
- **Token-efficient output**: Limit findings table to 50 rows; summarize overflow
- **Deterministic results**: Rerunning without changes should produce consistent IDs and counts

### Analysis Guidelines

- **NEVER modify files** (this is read-only analysis)
- **NEVER hallucinate missing sections** (if absent, report them accurately)
- **Prioritize constitution violations** (these are always CRITICAL)
- **Use examples over exhaustive rules** (cite specific instances, not generic patterns)
- **Report zero issues gracefully** (emit success report with alignment statistics)

## Context

{ARGS}
