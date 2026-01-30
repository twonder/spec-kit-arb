# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`
**Created**: [DATE]
**Status**: Draft
**Team**: [TEAM_NAME or "shared"]
**System**: [SYSTEM_NAME or "cross-cutting"]
**Author**: [AUTHOR_NAME]
**Input**: User description: "$ARGUMENTS"

## Quantifiable Value *(mandatory)*

<!--
  ACTION REQUIRED: Per Constitution Principle I, every spec MUST establish quantifiable value.

  If baseline measurements don't exist, you MUST:
  1. Explicitly call this out
  2. Add a predecessor feature to establish the measurement capability
  3. The predecessor feature MUST be completed before subsequent features
-->

### Success Metrics

| Metric | Current Baseline | Target | Measurement Method |
|--------|-----------------|--------|-------------------|
| [e.g., Checkout completion rate] | [e.g., 72%] | [e.g., 85%] | [e.g., Analytics funnel events] |
| [e.g., Average task completion time] | [e.g., 4.5 minutes] | [e.g., 2 minutes] | [e.g., Session recordings] |
| [e.g., Support tickets per week] | [e.g., 150] | [e.g., < 50] | [e.g., Zendesk reports] |

### Baseline Measurement Status

- [ ] **All baselines established** - Proceed with implementation
- [ ] **Baselines missing** - Predecessor feature required (see below)

### Predecessor Feature *(required if baselines missing)*

<!--
  If measurement infrastructure doesn't exist, add a predecessor feature here.
  This feature MUST be completed and baseline established BEFORE implementing the main feature.

  Remove this section if all baselines are already established.
-->

**Feature 0 - Establish Measurement Baseline (Priority: P0)**

Implement measurement capability to [measure the impact of the main feature].

**Acceptance Criteria**:
1. **Given** [measurement doesn't exist], **When** [instrumentation is deployed], **Then** [metric is captured in dashboard]
2. **Given** [metric is captured], **When** [one week of data collected], **Then** [baseline is established and documented]

**Baseline Established**: [ ] Yes, documented above | [ ] No, feature must complete first

### Value Category

<!--
  Check all that apply and provide specifics.
-->

- [ ] **Revenue Impact**: [Describe expected impact on conversion, AOV, LTV, etc.]
- [ ] **Cost Reduction**: [Describe expected operational or infrastructure savings]
- [ ] **User Experience**: [Describe expected improvement in task time, errors, satisfaction]
- [ ] **Risk Mitigation**: [Describe expected reduction in security, compliance, or reliability risks]
- [ ] **Developer Productivity**: [Describe expected improvement in deployment, lead time, MTTR]

## Features & Testing *(mandatory)*

<!--
  IMPORTANT: Features should be PRIORITIZED and ordered by importance.
  Each feature must be INDEPENDENTLY TESTABLE - meaning if you implement just ONE of them,
  you should still have a viable MVP (Minimum Viable Product) that delivers value.

  Assign priorities (P1, P2, P3, etc.) to each feature, where P1 is the most critical.
  Think of each feature as a standalone slice of functionality that can be:
  - Developed independently
  - Tested independently
  - Deployed independently
  - Demonstrated to users independently
-->

### Feature 1 - [Brief Title] (Priority: P1)

[Describe this feature in plain language - what it does and why users need it]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently - e.g., "Can be fully tested by [specific action] and delivers [specific value]"]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### Feature 2 - [Brief Title] (Priority: P2)

[Describe this feature in plain language - what it does and why users need it]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### Feature 3 - [Brief Title] (Priority: P3)

[Describe this feature in plain language - what it does and why users need it]

**Why this priority**: [Explain the value and why it has this priority level]

**Independent Test**: [Describe how this can be tested independently]

**Acceptance Scenarios**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more features as needed, each with an assigned priority]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
-->

### Functional Requirements

- **FR-001**: System MUST [specific capability, e.g., "allow users to create accounts"]
- **FR-002**: System MUST [specific capability, e.g., "validate email addresses"]  
- **FR-003**: Users MUST be able to [key interaction, e.g., "reset their password"]
- **FR-004**: System MUST [data requirement, e.g., "persist user preferences"]
- **FR-005**: System MUST [behavior, e.g., "log all security events"]

*Example of marking unclear requirements:*

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]
- **FR-007**: System MUST retain user data for [NEEDS CLARIFICATION: retention period not specified]

### Key Entities *(include if feature involves data)*

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
-->

### Measurable Outcomes

- **SC-001**: [Measurable metric, e.g., "Users can complete account creation in under 2 minutes"]
- **SC-002**: [Measurable metric, e.g., "System handles 1000 concurrent users without degradation"]
- **SC-003**: [User satisfaction metric, e.g., "90% of users successfully complete primary task on first attempt"]
- **SC-004**: [Business metric, e.g., "Reduce support tickets related to [X] by 50%"]

## Architecture Decision Records *(mandatory)*

<!--
  ACTION REQUIRED: Reference all applicable ADRs.

  RULES:
  1. List ALL existing ADRs that constrain or guide this feature
  2. If this spec proposes a NEW technology, pattern, or architectural approach:
     - Create a new ADR BEFORE implementation begins
     - Document alternatives considered and rationale for the choice
  3. If this spec conflicts with an existing ADR:
     - Either revise the spec to comply, OR
     - Create a new ADR that supersedes the old one (with justification)

  Use: ./scripts/bash/create-adr.sh "Decision title" to create new ADRs
-->

### Referenced ADRs

- **[ADR-XXX](../adrs/ADR-XXX-title.md)**: [Brief description of how this ADR applies to the feature]
- **[ADR-YYY](../adrs/ADR-YYY-title.md)**: [Brief description of relevance]

### New ADRs Required

<!--
  List any new ADRs that need to be created for this spec.
  Mark as TODO until created, then update with links.
-->

- [ ] **TODO**: [Decision topic] - [Why this needs an ADR]
- [x] **[ADR-ZZZ](../adrs/ADR-ZZZ-title.md)**: [Created for this spec - brief description]

### ADR Compliance Notes

<!--
  Document any tensions or tradeoffs with existing ADRs.
  If none, state "This spec fully complies with all referenced ADRs."
-->

[Compliance notes or "This spec fully complies with all referenced ADRs."]

## Availability Architecture *(mandatory for infrastructure/services)*

<!--
  ACTION REQUIRED: Declare the availability architecture for this feature.
  Per Constitution Principle III, you MUST explicitly choose and justify your approach.

  If this feature does not involve infrastructure or services (e.g., pure UI change,
  documentation update), state "N/A - No infrastructure impact" and remove subsections.
-->

### Availability Approach

**Chosen Approach**: [ ] Single Region | [ ] Multi-Region Active-Active | [ ] Multi-Region Active-Passive

**Rationale**: [Why this approach was chosen - consider cost, latency, compliance, complexity]

### Single Region Details *(if Single Region selected)*

- **Region**: [e.g., us-east-1, eu-west-1]
- **Region Selection Rationale**: [Why this specific region - user proximity, cost, compliance]
- **Acceptable Downtime (RTO)**: [e.g., 4 hours, 1 hour, 15 minutes]
- **Acceptable Data Loss (RPO)**: [e.g., 1 hour, 15 minutes, zero]
- **Single Points of Failure**: [List identified SPOFs and mitigation strategies]
- **Disaster Recovery**: [Backup region, restore procedures, DR testing frequency]

### Multi-Region Details *(if Multi-Region selected)*

- **Primary Region**: [Region name and rationale]
- **Secondary Region(s)**: [Region name(s) and rationale]
- **Failover Strategy**: [Automatic/Manual, DNS-based, load balancer, etc.]
- **Expected Failover Time**: [e.g., < 60 seconds, < 5 minutes]
- **Data Consistency Model**: [ ] Strong | [ ] Eventual | [ ] Bounded Staleness ([bound])
- **Replication Lag Tolerance**: [e.g., < 1 second, < 30 seconds, N/A for strong consistency]
- **Conflict Resolution**: [For active-active: last-write-wins, merge, application-level, etc.]

## FinOps *(mandatory)*

<!--
  ACTION REQUIRED: Cost is a primary driver of decisions (Constitution Principle IV).
  This section MUST be completed before implementation begins.

  If costs cannot be estimated, document why and what information is needed.
-->

### Cost Estimate

| Component | Monthly Cost | Annual Cost | Assumptions |
|-----------|-------------|-------------|-------------|
| [Compute] | $[X] | $[X] | [e.g., 2x m5.large, 730 hrs/mo] |
| [Storage] | $[X] | $[X] | [e.g., 100GB S3, 1TB data transfer] |
| [Database] | $[X] | $[X] | [e.g., RDS db.r5.large, Multi-AZ] |
| [Network] | $[X] | $[X] | [e.g., 500GB egress, NAT gateway] |
| [Other] | $[X] | $[X] | [e.g., API calls, third-party services] |
| **Total** | **$[X]** | **$[X]** | |

**Pricing Model Used**: [On-demand / Reserved / Spot / Savings Plans - with commitment period if applicable]

### Cost Drivers

1. **Primary Driver**: [What factor most impacts cost - e.g., "Data transfer costs scale with user growth"]
2. **Secondary Driver**: [Next most significant factor]
3. **Variable Costs**: [What costs scale with usage vs. fixed costs]

### Cost Comparison with Alternatives

| Approach | Monthly Cost | Trade-offs |
|----------|-------------|------------|
| Chosen approach | $[X] | [Why chosen despite cost] |
| Alternative 1 | $[X] | [Why not chosen - e.g., "30% cheaper but doesn't meet latency requirements"] |
| Alternative 2 | $[X] | [Why not chosen] |

### Cost Optimization Opportunities

- [ ] [Optimization 1 - e.g., "Use Reserved Instances after validating usage patterns - potential 40% savings"]
- [ ] [Optimization 2 - e.g., "Implement S3 lifecycle policies for cold storage"]
- [ ] [Optimization 3 - e.g., "Right-size instances after load testing"]

### Cost Monitoring & Alerts

- **Budget Ceiling**: $[X]/month - [What happens if exceeded: alert, auto-scale down, manual review]
- **Alert Thresholds**: [e.g., 50%, 75%, 90% of budget]
- **Cost Allocation Tags**: [Tags used for cost tracking - e.g., project, team, environment]
- **Review Cadence**: [How often costs are reviewed - e.g., weekly, monthly]

### Break-Even Analysis

- **Current Scale**: [X users/requests] = $[X]/month
- **Projected Scale**: [Y users/requests] = $[Y]/month (at [timeframe])
- **Cost Per Unit**: $[X] per [user/request/transaction]
- **Sustainability Threshold**: [At what scale does this become unsustainable? What's the mitigation plan?]
