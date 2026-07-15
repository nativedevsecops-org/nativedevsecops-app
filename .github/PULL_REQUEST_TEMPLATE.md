<!-- ============================================================================
PULL REQUEST TEMPLATE — Enterprise DevSecOps Workflow
Location: save as .github/PULL_REQUEST_TEMPLATE.md
GitHub auto-populates every new PR description with this content.

For multiple templates (e.g., feature vs hotfix vs infra), create a folder
.github/PULL_REQUEST_TEMPLATE/ with one .md per template and select via URL:
  ?template=hotfix.md
============================================================================ -->

## 📋 Change Summary

<!-- What does this PR do and WHY? Two or three sentences a reviewer can read
     before looking at any code. Focus on intent, not a file-by-file recap. -->

**What changed:**

**Why it changed:**

**Type of change:**
<!-- Check ALL that apply -->
- [ ] 🐛 Bug fix (non-breaking change that fixes an issue)
- [ ] ✨ New feature (non-breaking change that adds functionality)
- [ ] 💥 Breaking change (fix or feature that breaks existing functionality)
- [ ] ♻️ Refactor (no functional change)
- [ ] 🔧 Configuration / infrastructure change
- [ ] 📝 Documentation only
- [ ] 🔒 Security fix

---

## 🔗 Issue Reference

<!-- Closing keywords auto-close the issue when this PR merges.
     Use "Closes" for full fixes, "Relates to" for partial work. -->

Closes #
Relates to #

<!-- For Jira: PROJ-1234 (use your org's smart-commit format if configured) -->

---

## 🧪 Testing Checklist

<!-- Every checked box is a claim reviewers rely on. Only check what you
     actually did. Delete rows that don't apply, don't leave them unchecked. -->

- [ ] Unit tests added/updated for new logic
- [ ] Integration tests added/updated
- [ ] All tests pass locally (`attach command used, e.g. npm test / phpunit`)
- [ ] CI pipeline is green on this branch
- [ ] Manually tested in a dev/QA environment
- [ ] Edge cases and error paths tested (list the important ones below)
- [ ] Regression check: existing functionality verified unaffected

**How to test this change (steps for the reviewer):**

1.
2.
3.

**Test evidence:** <!-- link to CI run, test report, or coverage diff -->

---

## 🔒 Security Impact

<!-- DevSecOps gate: EVERY PR answers this section, even if the answer is
     "none" — silence is not a security assessment. -->

**Security impact level:** None / Low / Medium / High

- [ ] No secrets, credentials, tokens, or keys are committed (checked diff manually)
- [ ] Input validation / output encoding reviewed for new user-facing inputs
- [ ] AuthN/AuthZ changes reviewed (or N/A — no auth surface touched)
- [ ] New dependencies scanned (SCA/Dependabot clean) and pinned to exact versions
- [ ] SAST/secret-scanning findings reviewed and resolved or triaged
- [ ] No sensitive data added to logs, error messages, or analytics events
- [ ] Data handling complies with retention/privacy requirements (or N/A)

**Details (required if impact ≥ Low):**
<!-- What attack surface changes? What was mitigated and how? -->

---

## 🏗️ Infrastructure Impact

- [ ] No infrastructure impact — application code only
- [ ] Database schema change (migration included: `link/path`)
- [ ] New/changed environment variables (documented below)
- [ ] New/changed cloud resources (Terraform plan output attached/linked)
- [ ] Kubernetes/Helm manifest changes (resource limits reviewed)
- [ ] CI/CD pipeline changes
- [ ] Changes to networking, DNS, load balancing, or certificates
- [ ] Monitoring/alerting updated to cover the change

**New environment variables / config:**

| Variable | Purpose | Required? | Where to set |
|----------|---------|-----------|--------------|
|          |         |           |              |

**Capacity/cost impact:** <!-- e.g., new instance, +X GB storage, none -->

---

## ⏪ Rollback Considerations

<!-- Assume this change breaks production at 3 AM. What does on-call do? -->

**Rollback strategy:**
- [ ] Safe to roll back by reverting this PR / redeploying previous version
- [ ] Requires coordinated rollback (details below)
- [ ] ⚠️ NOT cleanly reversible (destructive migration, data backfill, external side effects — explain below)

**Rollback steps:**

1.
2.

**Database migration reversibility:** N/A / Reversible (`down` migration tested) / Irreversible

**Feature flag:** N/A / Flag name: `________` (change can be disabled without deploy)

---

## 📸 Screenshots / Recordings

<!-- Required for any UI change. Before/after for modifications.
     For API changes: request/response examples. For infra: plan output. -->

| Before | After |
|--------|-------|
|        |       |

<details>
<summary>Additional screenshots / terminal output</summary>

<!-- Drag & drop images or paste terraform plan / kubectl diff here -->

</details>

---

## ✅ Reviewer Checklist

<!-- For the REVIEWER to complete — do not check these as the author. -->

- [ ] Code is readable and follows project conventions
- [ ] Logic is correct; edge cases and failure modes are handled
- [ ] Tests genuinely cover the change (not just line coverage)
- [ ] Security section reviewed and level agrees with the diff
- [ ] No unintended files in the diff (lockfile churn, IDE config, debug code)
- [ ] Documentation updated where behavior changed (README, runbooks, API docs)
- [ ] Rollback plan is realistic and complete
- [ ] Breaking changes are flagged and downstream consumers notified

---

## 🚀 Deployment Notes

**Deployment order / dependencies:**
<!-- e.g., "Deploy AFTER infra PR #123", "Run migration before app deploy",
     "Requires config change in environment X first" — or "None, standard deploy" -->

**Pre-deployment steps:**
- [ ] N/A

**Post-deployment verification:**
<!-- How do we KNOW it worked? Specific dashboard, endpoint, log line, metric. -->
- [ ]

**Communication required:**
- [ ] None
- [ ] Notify #channel / stakeholders before deploy
- [ ] Requires maintenance window / scheduled deploy
- [ ] Customer-facing change — release notes entry added

**Monitoring after release:** <!-- What to watch for the first N hours, and the alert/dashboard link -->

---

<!-- ============================================================================
AUTHOR FINAL CHECK before requesting review:
  ☐ PR title follows convention (e.g., "feat(auth): add SSO login" —
    Conventional Commits if your org squash-merges with PR titles)
  ☐ PR is focused — one logical change (split large PRs)
  ☐ Self-reviewed the full diff on the Files tab
  ☐ Correct target branch selected
  ☐ Labels, milestone, and project board updated
============================================================================ -->
