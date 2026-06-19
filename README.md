# SKCorp-IAM-Operations-Access-Governance-Lab

## Project Overview

This project demonstrates an enterprise-style Identity and Access Management lab built with Windows Server 2022, Active Directory Domain Services, DNS, a domain-joined Windows 11 endpoint, RBAC security groups, Joiner-Mover-Leaver workflows, file-share authorization, delegated administration, and PowerShell-based access review reporting.

The lab simulates a small company environment called **SKCorp** and shows how identities are created, assigned access, modified during role changes, deprovisioned after termination, and reviewed for access governance.

## Lab Environment

| Component | Purpose |
|---|---|
| Windows Server 2022 | Domain Controller, DNS, AD DS, file shares |
| Windows 11 Pro | Domain-joined client workstation |
| VMware Workstation | Virtualization platform |
| Active Directory | Identity store and authentication provider |
| PowerShell | Access review automation |

## Architecture

```text
Windows Server 2022: DC01
        |
        |-- Active Directory Domain Services
        |-- DNS
        |-- Organizational Units
        |-- Security Groups / RBAC
        |-- HR and Finance File Shares
        |-- PowerShell Access Review Report

Windows 11: WIN11-CLIENT01
        |
        |-- Joined to skcorp.local
        |-- Domain user authentication
        |-- Access testing for HR and Finance users
```

## Objectives

- Build an Active Directory domain using Windows Server 2022.
- Create a structured OU model for users, groups, workstations, service accounts, and disabled users.
- Implement role-based access control using AD security groups.
- Simulate Joiner-Mover-Leaver identity lifecycle workflows.
- Enforce access control using NTFS and SMB permissions.
- Configure delegated password reset administration for a Helpdesk role.
- Automate user access review reporting with PowerShell.

---

## 1. Server and Domain Setup

The lab begins with Windows Server 2022 configured as the domain controller **DC01**. Active Directory Domain Services and DNS were installed to support the domain `skcorp.local`.

![ADUC domain root](screenshots/01-server-setup/01-aduc-domain-root.png)

![Server Manager roles](screenshots/01-server-setup/02-server-manager-roles.png)

---

## 2. Active Directory OU and RBAC Design

A dedicated parent OU named **SKCorp** was created to organize identities and resources.

OU structure:

```text
SKCorp
|-- Users
|-- Groups
|-- Servers
|-- Workstations
|-- Service Accounts
|-- Disabled Users
```

![OU structure](screenshots/02-active-directory/01-ou-structure.png)

Security groups were created to support RBAC:

- HR-Users
- Finance-Users
- Finance-Managers
- IT-Users
- VPN-Users
- Helpdesk-PasswordReset

![Security groups](screenshots/02-active-directory/02-security-groups-rbac.png)

User accounts were created inside the SKCorp Users OU.

![Users OU](screenshots/02-active-directory/03-users-ou.png)

---

## 3. Joiner-Mover-Leaver Lifecycle Management

### Joiner

A new employee account was created and assigned initial access based on job role.

![Joiner users created](screenshots/03-jml-lifecycle/01-joiner-users-created.png)

### Mover

Sarah Wilson was moved from HR access to Finance access by removing old groups and adding new role-based groups.

Before mover process:

![Sarah before mover](screenshots/03-jml-lifecycle/02-mover-before-hr-vpn.png)

Group membership validated from the domain-joined Windows 11 workstation using `whoami /groups`.

![Validate HR membership](screenshots/03-jml-lifecycle/03-validate-hr-membership-whoami.png)

After mover process:

![Sarah after mover](screenshots/03-jml-lifecycle/04-mover-after-finance-manager.png)

### Leaver

The leaver workflow disabled the user account, removed access, and moved the user into the Disabled Users OU.

![Disable user confirmation](screenshots/03-jml-lifecycle/05-disable-user-confirmation.png)

![Disabled Users OU](screenshots/03-jml-lifecycle/06-leaver-disabled-users-ou.png)

A login attempt confirmed the disabled account could no longer authenticate.

![Disabled user login denied](screenshots/03-jml-lifecycle/07-disabled-user-login-denied.png)

---

## 4. Delegated Helpdesk Administration

The Helpdesk role was delegated permission to reset user passwords and force password changes at next login without granting Domain Admin privileges. This demonstrates least-privilege administration.

![Delegation wizard](screenshots/04-delegated-admin/01-delegate-password-reset.png)

---

## 5. RBAC File Share Authorization

Two departmental shares were created:

```text
\\DC01\HR
\\DC01\Finance
```

Access was controlled through AD security groups and NTFS/SMB permissions.

| User | Group | HR Share | Finance Share |
|---|---|---|---|
| Aisha Khan | HR-Users | Allowed | Denied |
| Rahul Mehta | Finance-Users, Finance-Managers | Denied | Allowed |

Aisha could access the HR share but was denied access to the Finance share.

![HR user denied Finance access](screenshots/05-rbac-file-authorization/01-hr-user-finance-denied.png)

![HR access success](screenshots/05-rbac-file-authorization/02-hr-user-hr-access-success.png)

---

## 6. PowerShell User Access Review Automation

A PowerShell script was created to export user group memberships into a CSV report. This simulates an IAM access review or entitlement review.

![PowerShell script execution](screenshots/06-access-review/01-powershell-access-review-script.png)

Generated CSV report:

![User access review CSV](screenshots/06-access-review/02-user-access-review-csv.png)

Script location: [`scripts/UserAccessReview.ps1`](scripts/UserAccessReview.ps1)

---

## Key IAM Concepts Demonstrated

- Identity lifecycle management
- Joiner-Mover-Leaver workflows
- Active Directory administration
- Domain authentication
- Role-based access control
- Least privilege
- Delegated administration
- NTFS and SMB authorization
- User access reviews
- PowerShell automation
- Access governance reporting
