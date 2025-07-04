USE lab_db;

-- Insert Teams
INSERT INTO teams (name, description) VALUES
('Executive Leadership', 'C-Level executives and strategic leadership'),
('Engineering', 'Software development and engineering teams'),
('DevOps & Infrastructure', 'DevOps, SRE, and infrastructure management'),
('Security', 'Cybersecurity and information security'),
('Data & Analytics', 'Data science, analytics, and business intelligence'),
('Product Management', 'Product strategy and management'),
('Quality Assurance', 'Testing and quality assurance'),
('Network Operations', 'Network engineering and operations'),
('Support & Operations', 'IT support and technical operations'),
('Research & Development', 'Innovation and R&D initiatives');

-- Insert Roles
INSERT INTO roles (name, department, level, description) VALUES
-- C-Level
('Chief Executive Officer', 'Executive', 'C-Level', 'Overall company leadership and strategy'),
('Chief Technology Officer', 'Executive', 'C-Level', 'Technology strategy and leadership'),

-- Engineering
('Software Engineer', 'Engineering', 'Entry', 'Full-stack development and coding'),
('Senior Software Engineer', 'Engineering', 'Senior', 'Advanced development and architecture'),
('Lead Software Engineer', 'Engineering', 'Lead', 'Team leadership and technical guidance'),
('Engineering Manager', 'Engineering', 'Manager', 'Team management and project delivery'),
('Principal Engineer', 'Engineering', 'Senior', 'Technical architecture and design'),

-- DevOps & Infrastructure
('DevOps Engineer', 'DevOps', 'Mid', 'CI/CD, automation, and infrastructure'),
('Site Reliability Engineer', 'DevOps', 'Senior', 'System reliability and monitoring'),
('Infrastructure Engineer', 'DevOps', 'Mid', 'Server and infrastructure management'),
('Cloud Architect', 'DevOps', 'Senior', 'Cloud strategy and architecture'),
('DevOps Manager', 'DevOps', 'Manager', 'DevOps team leadership'),

-- Security
('Security Engineer', 'Security', 'Mid', 'Security implementation and monitoring'),
('Security Analyst', 'Security', 'Entry', 'Security monitoring and incident response'),
('Penetration Tester', 'Security', 'Senior', 'Security testing and vulnerability assessment'),
('Security Architect', 'Security', 'Senior', 'Security architecture and design'),
('CISO', 'Security', 'C-Level', 'Chief Information Security Officer'),

-- Data & Analytics
('Data Scientist', 'Data', 'Senior', 'Machine learning and advanced analytics'),
('Data Engineer', 'Data', 'Mid', 'Data pipeline and ETL development'),
('Business Intelligence Analyst', 'Data', 'Mid', 'Reporting and data analysis'),
('Data Architect', 'Data', 'Senior', 'Data architecture and modeling'),
('Analytics Manager', 'Data', 'Manager', 'Analytics team leadership'),

-- Product Management
('Product Manager', 'Product', 'Mid', 'Product strategy and roadmap'),
('Senior Product Manager', 'Product', 'Senior', 'Advanced product strategy'),
('Product Director', 'Product', 'Director', 'Product organization leadership'),
('Technical Product Manager', 'Product', 'Mid', 'Technical product strategy'),

-- Quality Assurance
('QA Engineer', 'QA', 'Entry', 'Manual and automated testing'),
('Senior QA Engineer', 'QA', 'Senior', 'Advanced testing and automation'),
('QA Lead', 'QA', 'Lead', 'Testing strategy and team leadership'),
('Test Automation Engineer', 'QA', 'Mid', 'Automated testing frameworks'),

-- Network Operations
('Network Engineer', 'Network', 'Mid', 'Network design and maintenance'),
('Senior Network Engineer', 'Network', 'Senior', 'Advanced networking and architecture'),
('Network Architect', 'Network', 'Senior', 'Network architecture and design'),
('Network Operations Manager', 'Network', 'Manager', 'Network team leadership'),

-- Support & Operations
('IT Support Specialist', 'Support', 'Entry', 'Technical support and troubleshooting'),
('System Administrator', 'Support', 'Mid', 'System administration and maintenance'),
('Senior System Administrator', 'Support', 'Senior', 'Advanced system administration'),
('IT Operations Manager', 'Support', 'Manager', 'IT operations leadership'),

-- Research & Development
('Research Engineer', 'R&D', 'Senior', 'Innovation and research projects'),
('R&D Manager', 'R&D', 'Manager', 'Research and development leadership');

-- Insert Employees (starting with CEOs)
INSERT INTO employees (first_name, last_name, email, phone, hire_date, salary, team_id, role_id, manager_id) VALUES
-- CEOs
('Sarah', 'Johnson', 'sarah.johnson@techcorp.com', '+1-555-0101', '2020-01-15', 450000.00, 1, 1, NULL),
('Michael', 'Chen', 'michael.chen@techcorp.com', '+1-555-0102', '2020-03-20', 420000.00, 1, 2, NULL),

-- Engineering Team
('David', 'Rodriguez', 'david.rodriguez@techcorp.com', '+1-555-0103', '2021-02-10', 180000.00, 2, 5, 1),
('Emily', 'Watson', 'emily.watson@techcorp.com', '+1-555-0104', '2021-03-15', 160000.00, 2, 4, 3),
('James', 'Thompson', 'james.thompson@techcorp.com', '+1-555-0105', '2021-04-20', 140000.00, 2, 3, 4),
('Lisa', 'Garcia', 'lisa.garcia@techcorp.com', '+1-555-0106', '2021-05-10', 120000.00, 2, 2, 5),
('Robert', 'Brown', 'robert.brown@techcorp.com', '+1-555-0107', '2021-06-15', 110000.00, 2, 2, 5),
('Jennifer', 'Davis', 'jennifer.davis@techcorp.com', '+1-555-0108', '2021-07-20', 95000.00, 2, 1, 5),
('Christopher', 'Miller', 'christopher.miller@techcorp.com', '+1-555-0109', '2021-08-25', 90000.00, 2, 1, 5),
('Amanda', 'Wilson', 'amanda.wilson@techcorp.com', '+1-555-0110', '2021-09-30', 85000.00, 2, 1, 5),

-- DevOps & Infrastructure Team
('Kevin', 'Martinez', 'kevin.martinez@techcorp.com', '+1-555-0111', '2021-01-15', 170000.00, 3, 10, 2),
('Rachel', 'Anderson', 'rachel.anderson@techcorp.com', '+1-555-0112', '2021-02-20', 150000.00, 3, 9, 10),
('Daniel', 'Taylor', 'daniel.taylor@techcorp.com', '+1-555-0113', '2021-03-25', 130000.00, 3, 8, 11),
('Michelle', 'Thomas', 'michelle.thomas@techcorp.com', '+1-555-0114', '2021-04-30', 115000.00, 3, 7, 12),
('Steven', 'Jackson', 'steven.jackson@techcorp.com', '+1-555-0115', '2021-05-05', 105000.00, 3, 6, 12),
('Nicole', 'White', 'nicole.white@techcorp.com', '+1-555-0116', '2021-06-10', 100000.00, 3, 6, 12),

-- Security Team
('Alex', 'Harris', 'alex.harris@techcorp.com', '+1-555-0117', '2021-01-20', 190000.00, 4, 15, 2),
('Jessica', 'Clark', 'jessica.clark@techcorp.com', '+1-555-0118', '2021-02-25', 160000.00, 4, 14, 17),
('Matthew', 'Lewis', 'matthew.lewis@techcorp.com', '+1-555-0119', '2021-03-30', 140000.00, 4, 13, 18),
('Stephanie', 'Robinson', 'stephanie.robinson@techcorp.com', '+1-555-0120', '2021-04-05', 120000.00, 4, 12, 19),
('Andrew', 'Walker', 'andrew.walker@techcorp.com', '+1-555-0121', '2021-05-10', 110000.00, 4, 11, 19),

-- Data & Analytics Team
('Melissa', 'Perez', 'melissa.perez@techcorp.com', '+1-555-0122', '2021-01-25', 180000.00, 5, 20, 2),
('Ryan', 'Hall', 'ryan.hall@techcorp.com', '+1-555-0123', '2021-02-28', 155000.00, 5, 19, 22),
('Ashley', 'Young', 'ashley.young@techcorp.com', '+1-555-0124', '2021-03-05', 135000.00, 5, 18, 23),
('Brandon', 'Allen', 'brandon.allen@techcorp.com', '+1-555-0125', '2021-04-10', 125000.00, 5, 17, 24),
('Samantha', 'King', 'samantha.king@techcorp.com', '+1-555-0126', '2021-05-15', 115000.00, 5, 16, 24),

-- Product Management Team
('Justin', 'Wright', 'justin.wright@techcorp.com', '+1-555-0127', '2021-01-30', 170000.00, 6, 24, 2),
('Hannah', 'Lopez', 'hannah.lopez@techcorp.com', '+1-555-0128', '2021-02-05', 150000.00, 6, 23, 27),
('Tyler', 'Hill', 'tyler.hill@techcorp.com', '+1-555-0129', '2021-03-10', 130000.00, 6, 22, 28),
('Lauren', 'Scott', 'lauren.scott@techcorp.com', '+1-555-0130', '2021-04-15', 120000.00, 6, 21, 28),
('Jordan', 'Green', 'jordan.green@techcorp.com', '+1-555-0131', '2021-05-20', 110000.00, 6, 21, 28),

-- Quality Assurance Team
('Cameron', 'Adams', 'cameron.adams@techcorp.com', '+1-555-0132', '2021-01-05', 160000.00, 7, 28, 2),
('Morgan', 'Baker', 'morgan.baker@techcorp.com', '+1-555-0133', '2021-02-10', 140000.00, 7, 27, 32),
('Casey', 'Gonzalez', 'casey.gonzalez@techcorp.com', '+1-555-0134', '2021-03-15', 125000.00, 7, 26, 33),
('Taylor', 'Nelson', 'taylor.nelson@techcorp.com', '+1-555-0135', '2021-04-20', 115000.00, 7, 25, 34),
('Riley', 'Carter', 'riley.carter@techcorp.com', '+1-555-0136', '2021-05-25', 105000.00, 7, 25, 34),
('Quinn', 'Mitchell', 'quinn.mitchell@techcorp.com', '+1-555-0137', '2021-06-30', 95000.00, 7, 24, 34),

-- Network Operations Team
('Parker', 'Roberts', 'parker.roberts@techcorp.com', '+1-555-0138', '2021-01-10', 165000.00, 8, 32, 2),
('Avery', 'Turner', 'avery.turner@techcorp.com', '+1-555-0139', '2021-02-15', 145000.00, 8, 31, 38),
('Reese', 'Phillips', 'reese.phillips@techcorp.com', '+1-555-0140', '2021-03-20', 130000.00, 8, 30, 39),
('Blake', 'Campbell', 'blake.campbell@techcorp.com', '+1-555-0141', '2021-04-25', 120000.00, 8, 29, 40),
('Hayden', 'Parker', 'hayden.parker@techcorp.com', '+1-555-0142', '2021-05-30', 110000.00, 8, 29, 40),

-- Support & Operations Team
('Dakota', 'Evans', 'dakota.evans@techcorp.com', '+1-555-0143', '2021-01-15', 155000.00, 9, 36, 2),
('Rowan', 'Edwards', 'rowan.edwards@techcorp.com', '+1-555-0144', '2021-02-20', 135000.00, 9, 35, 43),
('Sage', 'Collins', 'sage.collins@techcorp.com', '+1-555-0145', '2021-03-25', 120000.00, 9, 34, 44),
('River', 'Stewart', 'river.stewart@techcorp.com', '+1-555-0146', '2021-04-30', 110000.00, 9, 33, 45),
('Skyler', 'Sanchez', 'skyler.sanchez@techcorp.com', '+1-555-0147', '2021-05-05', 100000.00, 9, 32, 45),
('Finley', 'Morris', 'finley.morris@techcorp.com', '+1-555-0148', '2021-06-10', 90000.00, 9, 32, 45),

-- Research & Development Team
('Kai', 'Rogers', 'kai.rogers@techcorp.com', '+1-555-0149', '2021-01-20', 175000.00, 10, 38, 2),
('Zoe', 'Reed', 'zoe.reed@techcorp.com', '+1-555-0150', '2021-02-25', 150000.00, 10, 37, 49),
('Nova', 'Cook', 'nova.cook@techcorp.com', '+1-555-0151', '2021-03-30', 135000.00, 10, 37, 50),
('Atlas', 'Morgan', 'atlas.morgan@techcorp.com', '+1-555-0152', '2021-04-05', 125000.00, 10, 37, 50);

-- Insert Projects
INSERT INTO projects (name, description, team_id, status, start_date, end_date) VALUES
('Cloud Migration Initiative', 'Migrate all on-premise systems to AWS', 3, 'In Progress', '2024-01-15', '2024-12-31'),
('Security Framework Implementation', 'Implement zero-trust security model', 4, 'Planning', '2024-03-01', '2024-08-31'),
('Data Lake Platform', 'Build enterprise data lake for analytics', 5, 'Testing', '2024-02-01', '2024-07-31'),
('Mobile App Redesign', 'Redesign customer mobile application', 2, 'In Progress', '2024-01-01', '2024-06-30'),
('Network Infrastructure Upgrade', 'Upgrade network to 100Gbps backbone', 8, 'Planning', '2024-04-01', '2024-09-30'),
('AI-Powered Analytics', 'Implement machine learning for business insights', 10, 'In Progress', '2024-02-15', '2024-11-30'),
('DevOps Automation Platform', 'Build comprehensive CI/CD pipeline', 3, 'Deployed', '2023-10-01', '2024-01-31'),
('Customer Support Portal', 'Develop new customer support system', 9, 'Testing', '2024-01-01', '2024-05-31');
