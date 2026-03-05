# Remote-Hustle
# Remote Hustle Master Operational Database (RHDC Stage 1)

## Project Name
**RHDC Master Operational Database**


---

## Project Overview
This project is a **fully functional operational database** for Remote Hustle, designed to manage participants, submissions, evaluations, reports, and analytics.  

It addresses the following **pain points** in manual tracking:
- Manual participant registration and category assignment  
- Submission delays and messy tracking  
- Judge scoring inefficiencies  
- Stage progress monitoring  
- Reporting and analytics gaps  

The database is **ready to use immediately** and can support Remote Hustle admins, judges, and support staff.

---

## Tech Stack
- **Database:** PostgreSQL  
- **Hosting/Deployment:** Supabase / Neon / Railway (any cloud DB hosting supported)  
- **Data Modeling:** Relational with foreign keys and constraints  
- **Additional:** Views and queries for operational efficiency  

---

## Tables & Relationships
| Table | Description |
|-------|-------------|
| **participants** | Stores all participants and their profile information, stage, and category assignments |
| **categories** | Stores challenge categories and optionally links them to a stage |
| **stages** | Stores all competition stages (Registration, Qualifiers, Semi Finals, Finals) |
| **submissions** | Tracks all participant submissions including status and associated category/stage |
| **judges** | Stores judges and admins, assigned to stages if required |
| **evaluations** | Stores scoring details from judges for each submission |
| **roles** | Stores user roles and permissions (JSONB) |
| **audit_logs** | Tracks system actions for accountability and integrity |
| **views** | Participant average scores, leaderboard, and other operational views |

Relationships are enforced with **foreign keys** and constraints to maintain **data integrity**.  
`SERIAL` columns are used for IDs, which are **auto-incremented**.

---


