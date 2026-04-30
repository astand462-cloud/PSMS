<?php
// Database configuration
define('DB_NAME', 'primary_school_db');
define('DB_USER', 'root');
define('DB_PASS', '');
define('SITE_URL', 'http://localhost/school%20management%20-Copy/');

// ១. ហៅ File Database.php មកប្រើ
require_once 'Database.php';

// ២. បង្កើត Object ថ្មី និងហៅអនុគមន៍ភ្ជាប់
$database = new Database();
$db = $database->getConnection();

if($db){
    echo "<h3>ជោគជ័យ! ប្រព័ន្ធបានភ្ជាប់ទៅកាន់ Database primary_school_db រួចរាល់។</h3>";
    
    // ៣. ឧទាហរណ៍៖ ទាញយកឈ្មោះគ្រូមកបង្ហាញ (SELECT)
    try {
        $query = "SELECT name, phone_number FROM teachers";
        $stmt = $db->prepare($query);
        $stmt->execute();
        
        echo "<b>បញ្ជីឈ្មោះគ្រូ៖</b><br>";
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            echo "- ឈ្មោះ: " . $row['name'] . " | ទូរស័ព្ទ: " . $row['phone_number'] . "<br>";
        }
    } catch(PDOException $e) {
        echo "មានបញ្ហាក្នុងការទាញទិន្នន័យ៖ " . $e->getMessage();
    }

}
?>