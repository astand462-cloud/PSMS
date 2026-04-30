-- Database: primary_school_db
-- Note: Create the database 'primary_school_db' with utf8mb4 charset before importing this file
-- Or run: CREATE DATABASE IF NOT EXISTS primary_school_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- ១. តារាងឆ្នាំសិក្សា (Academic Years)
CREATE TABLE IF NOT EXISTS academic_years (
    id INT AUTO_INCREMENT PRIMARY KEY,
    year_name VARCHAR(50) NOT NULL, -- ឧទាហរណ៍៖ ២០២៥-២០២៦
    is_active BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ២. តារាងសាលារៀន (Schools)
CREATE TABLE IF NOT EXISTS schools (
    id INT AUTO_INCREMENT PRIMARY KEY,
    school_code VARCHAR(50) UNIQUE NOT NULL, -- លេខកូដសាលា
    name VARCHAR(255) NOT NULL, -- ឈ្មោះសាលា
    province VARCHAR(100) NOT NULL, -- ខេត្ត
    district VARCHAR(100) NOT NULL, -- ស្រុក
    commune VARCHAR(100) NOT NULL, -- ឃុំ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ៣. តារាងថ្នាក់រៀន (Classes)
CREATE TABLE IF NOT EXISTS classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    school_id INT NOT NULL,
    academic_year_id INT NOT NULL,
    class_name VARCHAR(50) NOT NULL, -- ឧទាហរណ៍៖ ៥ "ក"
    FOREIGN KEY (school_id) REFERENCES schools(id) ON DELETE CASCADE,
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ៤. តារាងគ្រូបង្រៀន (Teachers - ទាញចេញពី Popup Modal)
CREATE TABLE IF NOT EXISTS teachers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL, -- គ្រូប្រចាំថ្នាក់ណា
    name VARCHAR(100) NOT NULL, -- ឈ្មោះគ្រូ
    phone_number VARCHAR(20), -- លេខទូរស័ព្ទ
    start_date DATE, -- ថ្ងៃចូលរៀន/ថ្ងៃចាប់ផ្តើមបង្រៀន
    profile_picture TEXT, -- ទីតាំងរូបថត (URL ឬ Base64)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ៥. តារាងប្រវត្តិរូបសិស្ស (Students)
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL,
    student_code VARCHAR(50) UNIQUE NOT NULL, -- អត្តលេខសិស្ស
    first_name VARCHAR(50) NOT NULL, -- នាមត្រកូល
    last_name VARCHAR(50) NOT NULL, -- នាមខ្លួន
    gender ENUM('ប្រុស', 'ស្រី') NOT NULL, -- ភេទ
    dob DATE, -- ថ្ងៃខែឆ្នាំកំណើត
    parent_phone VARCHAR(20), -- លេខទូរស័ព្ទមាតាបិតា
    profile_picture TEXT,
    status ENUM('កំពុងសិក្សា', 'បោះបង់', 'ផ្ទេរ') DEFAULT 'កំពុងសិក្សា',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ៦. តារាងអ្នកប្រើប្រាស់ (Users/Accounts)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('admin', 'school') DEFAULT 'school',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ៩. តារាងការកំណត់សៃថ៍ (Site Settings)
CREATE TABLE IF NOT EXISTS site_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ៧. តារាងអវត្តមានសិស្ស (Attendance)
CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    status ENUM('វត្តមាន', 'អវត្តមាន', 'ច្បាប់') NOT NULL,
    reason TEXT, -- មូលហេតុ (បើមានច្បាប់)
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ៨. តារាងពិន្ទុប្រចាំខែ (Monthly Scores)
CREATE TABLE IF NOT EXISTS monthly_scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    semester ENUM('1', '2') NOT NULL, -- ឆមាសទី ១ ឬ ២
    month_name VARCHAR(50) NOT NULL, -- ធ្នូ, មករា, កុម្ភៈ...
    total_score DECIMAL(10,2) DEFAULT 0, -- ពិន្ទុសរុប
    average DECIMAL(5,2) DEFAULT 0, -- មធ្យមភាគ
    rank INT, -- ចំណាត់ថ្នាក់
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ៩. តារាងពិន្ទុប្រចាំឆមាស (Semester Exams)
CREATE TABLE IF NOT EXISTS semester_exams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    semester ENUM('1', '2') NOT NULL,
    total_score DECIMAL(10,2) DEFAULT 0,
    average DECIMAL(5,2) DEFAULT 0,
    rank INT,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==========================================
-- បញ្ចូលទិន្នន័យសាកល្បង (Dummy Data)
-- ==========================================

-- បញ្ចូលឆ្នាំសិក្សា
INSERT INTO academic_years (year_name, is_active) VALUES 
('២០២៥-២០២៦', TRUE),
('២០២៦-២០២៧', FALSE),
('២០២៧-២០២៨', TRUE),
('២០២៨-២០២៩', FALSE);


-- បញ្ចូលសាលារៀន
INSERT INTO schools (school_code, name, province, district, commune) VALUES 
('០៧០៧០៥០៥០៥៧', 'សាលាបឋមសិក្សា ព្រៃថ្មី', 'កំពត', 'ទឹកឈូ', 'កណ្តាល');

-- បញ្ចូលថ្នាក់រៀន
INSERT INTO classes (school_id, academic_year_id, class_name) VALUES 
(1, 1, '៥ ក'),
(1, 1, '៥ ខ');

-- បញ្ចូលគ្រូប្រចាំថ្នាក់ (តាមទិន្នន័យ Popup)
INSERT INTO teachers (class_id, name, phone_number, start_date) VALUES 
(1, 'នាង នី', '0964531036', '2025-11-01');

-- បញ្ចូលសិស្សសាកល្បង
INSERT INTO students (class_id, student_code, first_name, last_name, gender, dob, parent_phone) VALUES 
(1, 'STU-001', 'សុខ', 'សាន្ត', 'ប្រុស', '2015-05-12', '012345678'),
(1, 'STU-002', 'ចាន់', 'ធីតា', 'ស្រី', '2015-08-20', '098765432');

-- បញ្ចូលការកំណត់សៃថ៍
INSERT INTO site_settings (setting_key, setting_value) VALUES 
('site_name', 'School Management System'),
('site_url', 'http://localhost/school%20management%20-Copy/'),
('admin_email', 'admin@example.com');