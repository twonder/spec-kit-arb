# Specify Constitution

## Core Principles

### I. Quantifiable Value

Every specification MUST establish quantifiable value that the feature will deliver:

- **Define success metrics**: What measurements will prove this feature is valuable?
- **Establish baselines**: What is the current state of these metrics?
- **Set targets**: What specific, measurable improvements are expected?
- **Identify measurement mechanisms**: How will progress be tracked?

**When baselines don't exist**:

If the metrics needed to measure value don't currently exist, this MUST be explicitly called out. The specification MUST include a **predecessor user story** that:

1. Implements the instrumentation or data collection needed to measure current state
2. Establishes the baseline measurement before the main feature work begins
3. Is completed and verified BEFORE subsequent user stories can proceed

**Example**:
> **Predecessor User Story**: "As a product team, we need to instrument checkout flow completion rates so we can measure the impact of the new express checkout feature."
>
> **Acceptance Criteria**:
> - Checkout funnel events are logged to analytics platform
> - Dashboard shows current completion rate (baseline established)
> - Alerting configured for significant deviations

**Value categories to consider**:
- **Revenue impact**: Conversion rates, average order value, customer lifetime value
- **Cost reduction**: Operational efficiency, reduced manual processes, infrastructure savings
- **User experience**: Task completion time, error rates, satisfaction scores
- **Risk mitigation**: Security incidents, compliance violations, outage frequency
- **Developer productivity**: Deployment frequency, lead time, mean time to recovery

**Rationale**: Features without measurable value are impossible to evaluate. By requiring quantifiable metrics upfront, we ensure every feature can be objectively assessed for success or failure. Predecessor stories for measurement ensure we never implement features we cannot evaluate.

### II. ADR-Driven Architecture

All specifications MUST reference applicable Architecture Decision Records (ADRs). When a specification proposes a new technology, pattern, or significant architectural approach:

- An ADR MUST be created documenting the decision, alternatives considered, and rationale
- The specification MUST link to the new ADR before implementation begins
- Existing ADRs that constrain or guide the feature MUST be referenced in the spec
- If a spec conflicts with an existing ADR, either the ADR must be superseded or the spec must be revised
- ADRs MUST be searchable and discoverable; use consistent naming (`ADR-###-slug.md`)

**Rationale**: ADRs preserve institutional knowledge and ensure consistency across features. Architectural decisions made implicitly in code are invisible, hard to find, and often repeated incorrectly. By requiring specs to reference ADRs, we ensure decisions are explicit, traceable, and considered.

### III. Availability Architecture Declaration

Every specification and ADR involving infrastructure or services MUST explicitly declare the availability architecture:

**Single Region**:
- State the chosen region and rationale
- Document acceptable downtime (RTO/RPO)
- Identify single points of failure and mitigation strategies
- Document disaster recovery approach (backup region, restore procedures)

**Multi-Region** (MUST specify approach):

| Approach | Definition | When to Use |
|----------|------------|-------------|
| **Active-Active** | All regions serve traffic simultaneously; data replicated bidirectionally | Low latency requirements globally; zero-downtime requirements; regulatory data residency |
| **Active-Passive** | Primary region serves traffic; secondary on standby for failover | Cost-sensitive; can tolerate failover time; simpler consistency model |

**Required declarations**:
- Chosen approach with explicit rationale
- Regions selected and why
- Failover strategy and expected failover time
- Data consistency model (eventual, strong, bounded staleness)
- Cost implications of the availability choice (reference FinOps section)

**Rationale**: Availability architecture fundamentally shapes cost, complexity, and user experience. Implicit assumptions about availability lead to either over-engineering (expensive) or under-engineering (outages). Explicit declaration forces conscious trade-off decisions.

### IV. FinOps (Cost-Driven Design)

Cost is a primary driver of architectural and implementation decisions. Every specification and ADR MUST include a FinOps section that addresses:

- **Estimated costs**: Monthly/annual cost projections for the proposed solution
- **Cost drivers**: What factors most significantly impact cost (compute, storage, data transfer, API calls, etc.)
- **Cost comparison**: How does this compare to alternatives? Include rejected options' cost profiles
- **Cost optimization opportunities**: What can be done to reduce costs without sacrificing requirements?
- **Cost monitoring**: How will costs be tracked and alerted on?
- **Break-even analysis**: At what scale does the solution become cost-prohibitive or cost-advantageous?

**Non-negotiables**:
- MUST NOT proceed with implementation without cost estimates
- MUST document cost assumptions and pricing model used
- MUST identify cost ceilings and what happens when exceeded
- MUST consider both development cost and operational cost

**Rationale**: Cloud costs can spiral unexpectedly. By making cost a first-class concern in every decision, we prevent expensive surprises and ensure we're building sustainably within budget constraints.

### V. Specification Before Implementation

No implementation work begins without an approved specification:

- Specifications define WHAT and WHY, never HOW
- Specifications MUST be written for non-technical stakeholders
- Implementation details belong in plans, not specs
- Specifications MUST have measurable, testable acceptance criteria
- Changes to scope require spec amendments, not just code changes

**Rationale**: Specifications create alignment between stakeholders before expensive development begins. They serve as contracts that prevent scope creep and ensure everyone agrees on what "done" looks like.

### VI. Incremental Delivery

Features MUST be designed for incremental, independently-deployable delivery:

- Each user story SHOULD be deployable independently
- Prefer feature flags over long-lived feature branches
- MVP first: identify the smallest valuable increment
- Avoid "big bang" releases; prefer continuous delivery
- Each increment MUST be testable and demonstrable

**Rationale**: Large releases are risky, hard to debug, and delay value delivery. Incremental delivery reduces risk, enables faster feedback, and allows course correction.

### VII. Observability by Design

Every feature MUST be observable from day one:

- Structured logging with correlation IDs
- Metrics for business KPIs and technical health
- Distributed tracing for cross-service requests
- Alerting thresholds defined before deployment
- Dashboards created as part of feature delivery

**Rationale**: You cannot improve what you cannot measure. Observability added after the fact is incomplete and expensive. Building it in from the start ensures we can diagnose issues and understand system behavior.

### VIII. Security as a Constraint

Security is not a feature; it is a constraint on all features:

- Authentication and authorization MUST be addressed in every spec involving user data or actions
- Data classification (public, internal, confidential, restricted) MUST be declared
- Encryption requirements (at rest, in transit) MUST be specified
- Compliance requirements (GDPR, SOC2, HIPAA, etc.) MUST be identified
- Security review required before production deployment

**Rationale**: Security bolted on after implementation is ineffective and expensive. Treating security as a constraint ensures it's designed in from the start.

## Operational Standards

### Infrastructure as Code

All infrastructure MUST be defined in code:

- No manual changes to production infrastructure
- Infrastructure changes go through the same review process as application code
- Environments MUST be reproducible from code
- Drift detection and remediation MUST be automated

### Testing Requirements

- Unit tests for business logic (aim for >80% coverage on critical paths)
- Integration tests for service boundaries and external dependencies
- End-to-end tests for critical user journeys
- Performance tests for latency-sensitive operations
- Chaos engineering for resilience validation (production-like environments)

### Documentation Standards

- API documentation auto-generated from code/specs (OpenAPI, GraphQL schema)
- Runbooks for operational procedures
- Architecture diagrams kept current (C4 model recommended)
- README files for every repository and significant module

## Governance

### Constitutional Authority

This constitution supersedes all other development practices. When conflicts arise:

1. Constitution principles take precedence
2. ADRs provide implementation guidance within constitutional bounds
3. Specifications implement ADRs for specific features
4. Code implements specifications

### Amendment Process

Constitutional amendments require:

1. Written proposal with rationale
2. Impact analysis on existing ADRs and specifications
3. Review period (minimum 1 week for minor, 2 weeks for major)
4. Approval from architecture review board or designated approvers
5. Migration plan for existing work affected by the change
6. Version increment (MAJOR for principle changes, MINOR for additions, PATCH for clarifications)

### Exception Process

Exceptions to constitutional principles require:

1. Written justification documenting why compliance is impossible or counterproductive
2. Risk assessment of the exception
3. Approval from architecture review board
4. Documentation in the relevant spec/ADR

**Version**: 1.0.0 | **Ratified**: 2025-01-29 | **Last Amended**: 2025-01-29
