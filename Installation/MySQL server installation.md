MySQL Server Installation

 1.Environment
- Database Engine: MySQL Server 8.0
- OS: Windows 11 (Local Development)
- Tooling: MySQL Workbench 8.0

 2.Installation Approach
- Standalone MySQL Server instance
- Dedicated service account
- TCP/IP networking enabled
- Port: 3306
- Character Set: UTF-8 (utf8mb4)

 3.Security Decisions
- Root login disabled for application use
- Role-based access control enabled
- Strong password policy enforced

 4.Data Directories
- Data directory: C:\ProgramData\MySQL\MySQL Server 8.0\Data
- Binary logs enabled for recovery

 5.Why These Choices
These support:
- Secure access for healthcare data
- Scalability for national distribution
- Compliance with data integrity requirements