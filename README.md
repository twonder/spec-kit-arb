<div align="center">
    <h1>🏛️ Spec Kit for Architectural Review Boards</h1>
    <h3><em>Structured architectural decision-making with AI assistance.</em></h3>
</div>

<p align="center">
    <strong>An open source toolkit for Architectural Review Boards (ARBs) to create well-structured Architecture Decision Records (ADRs) and feature specifications.</strong>
</p>

<p align="center">
    <em>Forked from and inspired by <a href="https://github.com/github/spec-kit">github/spec-kit</a></em>
</p>

---

## Table of Contents

- [🤔 What is This?](#-what-is-this)
- [⚡ Get Started](#-get-started)
- [🤖 Supported AI Agents](#-supported-ai-agents)
- [🔧 CLI Reference](#-cli-reference)
- [📚 Core Philosophy](#-core-philosophy)
- [🎯 Use Cases](#-use-cases)
- [🔧 Prerequisites](#-prerequisites)
- [📖 Learn More](#-learn-more)
- [📋 Detailed Process](#-detailed-process)
- [🔍 Troubleshooting](#-troubleshooting)
- [👥 Maintainers](#-maintainers)
- [💬 Support](#-support)
- [🙏 Acknowledgements](#-acknowledgements)
- [📄 License](#-license)

## 🤔 What is This?

This toolkit helps Architectural Review Boards (ARBs) and engineering teams create consistent, high-quality architectural artifacts:

- **Architecture Decision Records (ADRs)** — Document technology choices, trade-offs, and rationale
- **Feature Specifications** — Define what to build and why, with clear acceptance criteria
- **Implementation Plans** — Translate specifications into actionable technical plans

By using AI assistance with structured templates, teams produce comprehensive architectural documentation that captures context, alternatives considered, and consequences — making decisions discoverable and reviewable for future team members.

## ⚡ Get Started

### 1. Install the CLI

Choose your preferred installation method:

#### Option 1: Persistent Installation (Recommended)

Install once and use everywhere:

```bash
uv tool install specify-arb --from git+https://github.com/twonder/spec-kit-arb.git
```

Then use the tool directly:

```bash
# Create new project
specify-arb init <PROJECT_NAME>

# Or initialize in existing project
specify-arb init . --ai claude
# or
specify-arb init --here --ai claude

# Check installed tools
specify-arb check
```

To upgrade, see the [Upgrade Guide](./docs/upgrade.md) for detailed instructions. Quick upgrade:

```bash
uv tool install specify-arb --force --from git+https://github.com/twonder/spec-kit-arb.git
```

#### Option 2: One-time Usage

Run directly without installing:

```bash
uvx --from git+https://github.com/twonder/spec-kit-arb.git specify-arb init <PROJECT_NAME>
```

**Benefits of persistent installation:**

- Tool stays installed and available in PATH
- No need to create shell aliases
- Better tool management with `uv tool list`, `uv tool upgrade`, `uv tool uninstall`
- Cleaner shell configuration

### 2. Review and Customize the Constitution

Launch your AI assistant in the project directory. The `/arb.*` commands are available in the assistant.

The toolkit includes a **pre-installed constitution** at `memory/constitution.md` with sensible defaults covering quantifiable value, ADR requirements, availability architecture, FinOps, and more. Review these principles and modify them to fit your organization's needs.

Use the **`/arb.constitution`** command to update the governing principles:

```bash
/arb.constitution Add principles for our security requirements: all services must use mTLS, data at rest must be encrypted with customer-managed keys
```

**Note**: The pre-installed constitution is a starting point. Teams should customize it to reflect their specific compliance requirements, technology standards, and organizational policies.

### 3. Create an Architecture Decision Record

Use the **`/arb.adr`** command to document architectural decisions with proper context and rationale:

```bash
/arb.adr Use PostgreSQL for primary database storage
```

This creates a structured ADR with:
- Context explaining why the decision is needed
- The decision itself
- Consequences (positive, negative, neutral)
- Alternatives considered with trade-offs
- FinOps impact analysis

### 4. Create a Feature Specification

Use the **`/arb.specify`** command to define what you want to build. Focus on the **what** and **why**, not the technical implementation:

```bash
/arb.specify Build a user authentication system that supports SSO integration with corporate identity providers and maintains audit logs for compliance
```

### 5. Create a Technical Implementation Plan

Use the **`/arb.plan`** command to translate the specification into a technical plan:

```bash
/arb.plan Use OAuth 2.0 with OIDC, integrate with Azure AD, store sessions in Redis, audit logs in CloudWatch
```

For detailed step-by-step instructions, see our [comprehensive guide](./spec-driven.md).

## 🤖 Supported AI Agents

| Agent                                                                                | Support | Notes                                                                                                                                     |
| ------------------------------------------------------------------------------------ | ------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| [Claude Code](https://www.anthropic.com/claude-code)                                 | ✅      |                                                                                                                                           |
| [Cursor](https://cursor.sh/)                                                         | ✅      |                                                                                                                                           |
| [GitHub Copilot](https://code.visualstudio.com/)                                     | ✅      |                                                                                                                                           |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli)                            | ✅      |                                                                                                                                           |
| [Codex CLI](https://github.com/openai/codex)                                         | ✅      |                                                                                                                                           |
| [Windsurf](https://windsurf.com/)                                                    | ✅      |                                                                                                                                           |
| [Amp](https://ampcode.com/)                                                          | ✅      |                                                                                                                                           |
| [Amazon Q Developer CLI](https://aws.amazon.com/developer/learning/q-developer-cli/) | ⚠️      | Amazon Q Developer CLI [does not support](https://github.com/aws/amazon-q-developer-cli/issues/3064) custom arguments for slash commands. |

## 🔧 CLI Reference

The `specify-arb` command supports the following options:

### Commands

| Command | Description                                                                                                                                             |
| ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `init`  | Initialize a new project from the latest template                                                                                                       |
| `check` | Check for installed tools (`git`, `claude`, `gemini`, `code`/`code-insiders`, `cursor-agent`, `windsurf`, `qwen`, `opencode`, `codex`, `shai`, `qoder`) |

### `specify-arb init` Arguments & Options

| Argument/Option        | Type     | Description                                                                                                                                                                                  |
| ---------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `<project-name>`       | Argument | Name for your new project directory (optional if using `--here`, or use `.` for current directory)                                                                                           |
| `--ai`                 | Option   | AI assistant to use: `claude`, `gemini`, `copilot`, `cursor-agent`, `qwen`, `opencode`, `codex`, `windsurf`, `kilocode`, `auggie`, `roo`, `codebuddy`, `amp`, `shai`, `q`, `bob`, or `qoder` |
| `--script`             | Option   | Script variant to use: `sh` (bash/zsh) or `ps` (PowerShell)                                                                                                                                  |
| `--ignore-agent-tools` | Flag     | Skip checks for AI agent tools like Claude Code                                                                                                                                              |
| `--no-git`             | Flag     | Skip git repository initialization                                                                                                                                                           |
| `--here`               | Flag     | Initialize project in the current directory instead of creating a new one                                                                                                                    |
| `--force`              | Flag     | Force merge/overwrite when initializing in current directory (skip confirmation)                                                                                                             |
| `--skip-tls`           | Flag     | Skip SSL/TLS verification (not recommended)                                                                                                                                                  |
| `--debug`              | Flag     | Enable detailed debug output for troubleshooting                                                                                                                                             |
| `--github-token`       | Option   | GitHub token for API requests (or set GH_TOKEN/GITHUB_TOKEN env variable)                                                                                                                    |

### Available Slash Commands

After running `specify-arb init`, your AI coding agent will have access to these slash commands:

#### Core Commands

Essential commands for architectural decision-making:

| Command             | Description                                                              |
| ------------------- | ------------------------------------------------------------------------ |
| `/arb.constitution` | Create or update project governing principles and architectural guidelines |
| `/arb.adr`          | Create a new Architecture Decision Record (ADR)                          |
| `/arb.specify`      | Define feature requirements and acceptance criteria                      |
| `/arb.plan`         | Create technical implementation plans from specifications                |

#### Quality & Validation Commands

Additional commands for ensuring consistency and completeness:

| Command          | Description                                                                                                                          |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `/arb.clarify`   | Identify underspecified areas and resolve ambiguities (recommended before `/arb.plan`)                                               |
| `/arb.analyze`   | Cross-artifact consistency analysis (validates alignment between spec, plan, ADRs, and constitution)                                 |
| `/arb.checklist` | Generate custom quality checklists for requirements validation                                                                       |

### Environment Variables

| Variable          | Description                                                                                                                                                                                                                                                                                            |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `SPECIFY_FEATURE` | Override feature detection for non-Git repositories. Set to the feature directory name (e.g., `001-auth-system`) to work on a specific feature when not using Git branches.<br/>\*\*Must be set in the context of the agent you're working with prior to using `/arb.plan` or follow-up commands. |

### Local Configuration (Team/System Organization)

For organizations with multiple teams, you can configure team-specific settings using a local config file:

1. Copy the template: `cp .specify/templates/local.template.config.json .specify/local.config.json`
2. Edit `.specify/local.config.json` with your settings:

```json
{
  "user": {
    "name": "Your Name",
    "team": "platform",
    "email": "you@example.com"
  },
  "teams": {
    "platform": {
      "name": "Platform Team",
      "systems": ["identity", "api-gateway", "infrastructure"],
      "specsDir": "specs/platform",
      "adrDir": "adrs/platform"
    }
  }
}
```

**Note**: `local.config.json` is gitignored—it's user-specific and not tracked in version control.

When you run `/arb.specify` or `/arb.adr`, artifacts will automatically be created in your team's directory and tagged with your team/system.

## 📚 Core Philosophy

This toolkit is built on principles that support effective architectural governance. A **pre-installed constitution** (`memory/constitution.md`) provides sensible defaults that teams should customize for their needs:

- **Constitution-driven decisions** — The constitution defines non-negotiable principles that guide all architectural choices
- **ADR-first architecture** — Every significant technology choice is documented with context, alternatives, and consequences
- **Quantifiable value** — Specifications must establish measurable success criteria and baselines
- **FinOps awareness** — Cost is a first-class concern in every architectural decision
- **Availability declarations** — Infrastructure decisions explicitly declare availability architecture (single/multi-region, active-active/passive)

## 🎯 Use Cases

### Architectural Review Boards

- Standardize how architectural decisions are documented across teams
- Ensure all decisions capture alternatives considered and trade-offs
- Track cost implications of technology choices
- Maintain searchable, discoverable decision history

### Engineering Teams

- Document technology choices with proper context for future team members
- Create feature specifications that clearly separate what from how
- Validate specifications against organizational principles before implementation
- Generate implementation plans that trace back to requirements

### Compliance & Auditing

- Maintain audit trails of architectural decisions
- Document security and compliance considerations in context
- Track availability and disaster recovery decisions
- Record cost optimization decisions and rationale

## 🔧 Prerequisites

- **Linux/macOS/Windows**
- [Supported](#-supported-ai-agents) AI coding agent
- [uv](https://docs.astral.sh/uv/) for package management
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

If you encounter issues with an agent, please open an issue so we can refine the integration.

## 📖 Learn More

- **[Spec-Driven Development Methodology](./spec-driven.md)** — Deep dive into the full process
- **[Project Constitution](./memory/constitution.md)** — Pre-installed principles that govern architectural decisions (customize for your team)

---

## 📋 Detailed Process

<details>
<summary>Click to expand the detailed step-by-step walkthrough</summary>

You can use the CLI to bootstrap your project, which will bring in the required artifacts in your environment. Run:

```bash
specify-arb init <project_name>
```

Or initialize in the current directory:

```bash
specify-arb init .
# or use the --here flag
specify-arb init --here
# Skip confirmation when the directory already has files
specify-arb init . --force
```

### **STEP 1:** Review and Customize the Constitution

Go to the project folder and run your AI agent. You will know that things are configured correctly if you see the `/arb.*` commands available.

The toolkit includes a **pre-installed constitution** at `memory/constitution.md` with principles covering:
- Quantifiable value requirements
- ADR-driven architecture
- Availability architecture declarations
- FinOps (cost-driven design)
- Specification before implementation
- Incremental delivery
- Observability by design
- Security as a constraint

Review these principles and customize them for your organization using the `/arb.constitution` command:

```text
/arb.constitution Update to add our compliance requirements: SOC2 attestation required for all third-party services, GDPR data residency for EU customers
```

The constitution at `memory/constitution.md` serves as the foundation for all architectural decisions. Modify it to reflect your team's specific standards and requirements.

### **STEP 2:** Create Architecture Decision Records

As you make architectural decisions, document them using `/arb.adr`:

```text
/arb.adr Use PostgreSQL for primary database - need ACID compliance, strong ecosystem, team familiarity
```

The ADR will be created with:
- Sequential numbering (ADR-001, ADR-002, etc.)
- Structured sections for context, decision, consequences
- Alternatives considered with trade-offs
- FinOps impact analysis

### **STEP 3:** Create Feature Specifications

When defining new features, use `/arb.specify`:

```text
/arb.specify Build user authentication with SSO support. Users should be able to log in with corporate credentials. Must support MFA. Need audit logging for compliance. Session timeout after 30 minutes of inactivity.
```

This creates a structured specification with:
- Quantifiable value metrics
- Features with acceptance criteria
- Functional requirements
- References to applicable ADRs

### **STEP 4:** Clarify Specifications

Before creating an implementation plan, run `/arb.clarify` to identify ambiguities:

```text
/arb.clarify
```

This walks through a structured questionnaire to resolve underspecified areas and records clarifications directly in the spec.

### **STEP 5:** Generate Implementation Plan

With a clarified specification, create the technical plan:

```text
/arb.plan OAuth 2.0 with OIDC, Azure AD integration, Redis for sessions, PostgreSQL for user data
```

### **STEP 6:** Validate Alignment

Run `/arb.analyze` to check consistency across all artifacts:

```text
/arb.analyze
```

This validates:
- Spec requirements are addressed in the plan
- Plan references valid ADRs
- Constitution principles are followed
- No terminology drift or contradictions

</details>

---

## 🔍 Troubleshooting

### Git Credential Manager on Linux

If you're having issues with Git authentication on Linux, you can install Git Credential Manager:

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```

## 👥 Maintainers

- Tim Heuer ([@timheuer](https://github.com/timheuer))

## 💬 Support

For support, please open a [GitHub issue](https://github.com/timheuer/spec-kit-arb/issues/new). We welcome bug reports, feature requests, and questions.

## 🙏 Acknowledgements

This project is forked from and inspired by [github/spec-kit](https://github.com/github/spec-kit), created by:

- Den Delimarsky ([@localden](https://github.com/localden))
- John Lam ([@jflam](https://github.com/jflam))

The Spec-Driven Development methodology and original toolkit provided the foundation for this ARB-focused variant.

## 📄 License

This project is licensed under the terms of the MIT open source license. Please refer to the [LICENSE](./LICENSE) file for the full terms.
