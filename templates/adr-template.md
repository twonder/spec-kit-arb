# ADR-[NUMBER]: [TITLE]

**Status**: Proposed | Accepted | Deprecated | Superseded
**Date**: [DATE]
**Team**: [TEAM_NAME or "shared"]
**System**: [SYSTEM_NAME or "cross-cutting"]
**Deciders**: [LIST OF DECISION MAKERS]

## Context

[Describe the issue motivating this decision. What is the problem or opportunity that requires a decision? Include relevant background information, constraints, and any forces at play.]

## Decision

[State the decision that was made. Be specific about what was chosen and why this particular approach was selected.]

## Consequences

### Positive

- [List the positive outcomes of this decision]
- [Benefits, improvements, or advantages gained]

### Negative

- [List the negative outcomes or trade-offs]
- [Costs, risks, or disadvantages accepted]

### Neutral

- [List neutral outcomes - things that change but aren't clearly positive or negative]
- [Side effects or implications that are worth noting]

## Alternatives Considered

### Alternative 1: [Name]

**Description**: [Brief description of this alternative]

**Pros**:
- [Advantage 1]
- [Advantage 2]

**Cons**:
- [Disadvantage 1]
- [Disadvantage 2]

**Why not chosen**: [Reason for rejection]

---

### Alternative 2: [Name]

**Description**: [Brief description of this alternative]

**Pros**:
- [Advantage 1]
- [Advantage 2]

**Cons**:
- [Disadvantage 1]
- [Disadvantage 2]

**Why not chosen**: [Reason for rejection]

## Availability Architecture *(if applicable)*

<!--
  Required for decisions involving infrastructure, services, or data storage.
  Per Constitution Principle III, availability choices must be explicit.

  If not applicable (e.g., code style decision, library choice with no infra impact),
  state "N/A - No availability implications" and remove subsections.
-->

### Availability Approach

**Chosen Approach**: [ ] Single Region | [ ] Multi-Region Active-Active | [ ] Multi-Region Active-Passive | [ ] N/A

**Rationale**: [Why this approach - consider cost, latency, compliance, complexity]

### Regional Configuration *(if applicable)*

- **Region(s)**: [List regions and selection rationale]
- **Failover Strategy**: [If multi-region: automatic/manual, expected failover time]
- **Data Consistency**: [ ] Strong | [ ] Eventual | [ ] Bounded Staleness
- **RTO/RPO**: [Recovery Time Objective / Recovery Point Objective]

## FinOps Impact *(mandatory)*

<!--
  Per Constitution Principle IV, cost implications MUST be documented for every ADR.
  This enables informed decision-making and prevents cost surprises.
-->

### Cost Implications of This Decision

| Factor | Chosen Approach | Alternative 1 | Alternative 2 |
|--------|-----------------|---------------|---------------|
| Monthly Cost | $[X] | $[X] | $[X] |
| Setup/Migration Cost | $[X] | $[X] | $[X] |
| Scaling Cost Model | [Linear/Exponential/Step] | [Model] | [Model] |

### Cost Drivers

- **Primary Cost Driver**: [What factor most impacts cost for this decision]
- **Variable vs Fixed**: [Which costs are fixed vs. scale with usage]
- **Hidden Costs**: [Any non-obvious costs - training, migration, operational overhead]

### Cost Rationale

[Explain why the cost of the chosen approach is acceptable. If not the cheapest option, justify the additional expense. Reference Constitution Principle IV.]

## Related Decisions

- [Link to related ADRs if any, e.g., ADR-001, ADR-003]

## Originating Specification

<!--
  If this ADR was created as part of a feature specification, link to it here.
  This creates traceability between architectural decisions and the features that drove them.
-->

- **Spec**: [Link to the spec that required this decision, e.g., specs/001-feature-name/spec.md]
- **Requirement**: [Which requirement or aspect of the spec drove this decision]

## Notes

[Any additional notes, references, or context that might be helpful for future readers]
