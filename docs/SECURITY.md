# Security and public-release review

[← Home](../README.md)

## What was intentionally excluded

- Original company/client names and identifiable workstation identifiers.
- Internal DNS names, IP addresses, ERP application paths, tenant/site/plant parameters and infrastructure-specific endpoints.
- Real account names, passwords, access methods and production form-filling commands.
- Screenshots from the private configuration document and the document itself.
- Device logs, browser profiles, cookies, private keys and backup files.
- Personnel and operational metadata unrelated to a public case study.

The image under `assets/` was cropped to omit visible labeling on the device's lower front edge and re-encoded without image metadata from the original upload.

## Operational risks

**OS autologin:** It removes a local authentication barrier. Limit physical access, use a least-privilege kiosk account and assess the applicable security policy.

**Browser session:** Kiosk mode alone is not a complete security boundary. Evaluate keyboard shortcuts, external links, USB input, terminal access, session persistence and browser policies.

**Authentication:** Do not store reusable ERP or business application passwords in a public repository or plaintext shell script. Prefer managed SSO/device identity or a formally approved secret management solution. The original private UI form automation is excluded.

**Network:** A test URL must be explicitly approved. Use TLS where possible, monitor certificate errors and restrict outbound destinations according to policy.

**Host:** Keep the OS and browser patched, restrict SSH to authorized users and use least-privilege permissions.

## Before making a repository public

1. Confirm **ownership and employer/client permission** to publish the generalized example, source code and hardware photograph. Redacting secrets does not automatically eliminate confidentiality or intellectual property obligations.
2. Search all tracked files, including images and commit history, for internal names, addresses, tokens and identifiers.
3. Never add the original private DOCX or real application screenshots to Git, not even temporarily.
4. Review any fork, release archive, CI artifact or previous commit. A file deleted in the latest commit can still exist in Git history.
5. If actual credentials have ever been publicly disclosed, rotate or revoke them and follow the relevant incident procedure.
6. Choose and add a license **only after** you have the rights to grant one.

## Publication scope

This repository's local text templates have been checked for several known sensitive items from the supplied source document. That check cannot guarantee safety against unseen context, company policy or private information hidden in future edits. Perform a final manual review before publishing.
