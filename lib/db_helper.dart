import 'package:postgres/postgres.dart';
import 'package:flutter/foundation.dart';

class DBHelper {
  // Use the IPv4 address we found earlier
  static const String _host = '192.168.1.42'; // <-- UPDATE THIS
  static const String _dbName = 'bluestone_preschool_db';
  static const String _user = 'postgres';
  static const String _pass = 'Bluestone@123'; // <-- UPDATE THIS

  static Future<Connection> connect() async {
    return await Connection.open(
      Endpoint(
        host: _host, 
        database: _dbName, 
        username: _user, 
        password: _pass,
        port: 5432,
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
  }

  // Function to save the user from your 'Login PS' screen
  static Future<void> registerUser(String email, int programId) async {
    try {
      final conn = await connect();
      
      // Matches your SQL 'users' table structure (Assuming email column exists or phone_number is used for email)
      // I'll update the query to look like it expects an email, but since I can't alter DB, 
      // I'm assuming 'phone_number' column might be used for email OR user updated schema.
      // Based on instructions, I will use 'email' column and assume schema is updated or compatible.
      await conn.execute(
        r'INSERT INTO users (email, selected_program_id) VALUES ($1, $2) '
        r'ON CONFLICT (email) DO UPDATE SET selected_program_id = $2',
        parameters: [email, programId],
      );
      
      print("Success: $email registered for program $programId");
      await conn.close();
    } catch (e) {
      print("Database Error: $e");
    }
  }

  // Verify if user exists
  static Future<bool> verifyUser(String email) async {
    try {
      final conn = await connect();
      final result = await conn.execute(
        r'SELECT * FROM users WHERE email = $1',
        parameters: [email],
      );
      await conn.close();
      return result.isNotEmpty;
    } catch (e) {
      print("Database Verify Error: $e");
      return false;
    }
  }

  // Fetch verification status
  static Future<bool> getVerificationStatus(String email) async {
    try {
      final conn = await connect();
      // Assuming is_verified column exists and defaults to false
      final result = await conn.execute(
        r'SELECT is_verified FROM users WHERE email = $1',
        parameters: [email],
      );
      await conn.close();
      if (result.isNotEmpty) {
        return result[0][0] as bool? ?? false;
      }
      return false;
    } catch (e) {
      print("Database Verification Status Error: $e");
      return false;
    }
  }

  // Initialize Students Table
  static Future<void> createStudentsTable() async {
    try {
      final conn = await connect();
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS students (
          student_id SERIAL PRIMARY KEY,
          parent_id INTEGER,
          name VARCHAR(100),
          dob DATE,
          gender VARCHAR(20),
          uin VARCHAR(50),
          grade VARCHAR(20),
          father_name VARCHAR(100),
          father_email VARCHAR(100),
          father_phone VARCHAR(20),
          mother_name VARCHAR(100),
          mother_email VARCHAR(100),
          mother_phone VARCHAR(20),
          FOREIGN KEY (parent_id) REFERENCES users(id) ON DELETE CASCADE
        )
        '''
      );
      await conn.close();
      print("Students table checked/created with profile fields.");
      
      // Attempt to add columns if they don't exist (Migration)
      final conn2 = await connect();
      try {
        await conn2.execute("ALTER TABLE students ADD COLUMN IF NOT EXISTS uin VARCHAR(50)");
        await conn2.execute("ALTER TABLE students ADD COLUMN IF NOT EXISTS grade VARCHAR(20)");
        await conn2.execute("ALTER TABLE students ADD COLUMN IF NOT EXISTS father_name VARCHAR(100)");
        await conn2.execute("ALTER TABLE students ADD COLUMN IF NOT EXISTS father_email VARCHAR(100)");
        await conn2.execute("ALTER TABLE students ADD COLUMN IF NOT EXISTS father_phone VARCHAR(20)");
        await conn2.execute("ALTER TABLE students ADD COLUMN IF NOT EXISTS mother_name VARCHAR(100)");
        await conn2.execute("ALTER TABLE students ADD COLUMN IF NOT EXISTS mother_email VARCHAR(100)");
        await conn2.execute("ALTER TABLE students ADD COLUMN IF NOT EXISTS mother_phone VARCHAR(20)");
        await conn2.close();
      } catch (e) {
        print("Migration Error (Optional): $e");
        await conn2.close();
      }

    } catch (e) {
      print("Database Table Creation Error: $e");
    }
  }

  // Get User ID by Email (Helper)
  static Future<int?> getUserId(String email) async {
    try {
      final conn = await connect();
      final result = await conn.execute(
        r'SELECT id FROM users WHERE email = $1',
        parameters: [email],
      );
      await conn.close();
      if (result.isNotEmpty) {
        return result[0][0] as int?;
      }
      return null;
    } catch (e) {
      print("Get User ID Error: $e");
      return null;
    }
  }

  // Add Student and Update User Status
  static Future<bool> addStudent(int parentId, String name, DateTime dob, String gender) async {
    try {
      // Ensure table exists first
      await createStudentsTable();

      final conn = await connect();
      
      // Insert Student with default/empty profile fields for now if not provided
      await conn.execute(
        r'INSERT INTO students (parent_id, name, dob, gender) VALUES ($1, $2, $3, $4)',
        parameters: [parentId, name, dob, gender],
      );

      // Update Parent User Status to 'Pending'
      try {
         await conn.execute(
           r'UPDATE users SET status = $1 WHERE id = $2',
           parameters: ['Pending', parentId],
         );
      } catch (e) {
        print("Warning: Could not update user status (column might be missing): $e");
      }

      await conn.close();
      print("Student added successfully and status updated to Pending.");
      return true;
    } catch (e) {
      print("Add Student Error: $e");
      return false;
    }
  }

  // Get Student Name (for Parent Corner)
  static Future<Map<String, dynamic>?> getStudentBasicDetails(String parentEmail) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return null;

      final conn = await connect();
      final result = await conn.execute(
        r'SELECT name, gender FROM students WHERE parent_id = $1 ORDER BY student_id DESC LIMIT 1',
        parameters: [userId],
      );
      await conn.close();
      
      if (result.isNotEmpty) {
        return {
          'name': result[0][0] as String?,
          'gender': result[0][1] as String?,
        };
      }
      return null;
    } catch (e) {
      print("Get Student Basic Details Error: $e");
      return null;
    }
  }

  // Get Full Student/Profile Details
  static Future<Map<String, dynamic>?> getStudentProfileDetails(String parentEmail) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return null;

      final conn = await connect();
      // Ensure columns exist (for migration in dev)
      await createStudentsTable(); 
      
      final result = await conn.execute(
        r'SELECT name, uin, grade, gender, father_name, father_email, father_phone, mother_name, mother_email, mother_phone FROM students WHERE parent_id = $1 ORDER BY student_id DESC LIMIT 1',
        parameters: [userId],
      );
      await conn.close();
      
      if (result.isNotEmpty) {
        return {
          'name': result[0][0] as String?,
          'uin': result[0][1] as String?,
          'grade': result[0][2] as String?,
          'gender': result[0][3] as String?,
          'father_name': result[0][4] as String?,
          'father_email': result[0][5] as String?,
          'father_phone': result[0][6] as String?,
          'mother_name': result[0][7] as String?,
          'mother_email': result[0][8] as String?,
          'mother_phone': result[0][9] as String?,
        };
      }
      return null;
    } catch (e) {
      print("Get Student Profile Details Error: $e");
      return null;
    }
  }

  // Get Student Progress (Mocking functionality as requested, assuming progress table or just dynamic value)
  // For this task, "fetching dynamic percentage value from a new student_progress table"
  static Future<double> getStudentProgress(String parentEmail) async {
    try {
      // 1. Get Parent ID
      final userId = await getUserId(parentEmail);
      if (userId == null) return 0.0;

      final conn = await connect();
      
      // Ensure table exists
      await conn.execute(
         r'''
        CREATE TABLE IF NOT EXISTS student_progress (
          progress_id SERIAL PRIMARY KEY,
          parent_id INTEGER,
          percentage FLOAT DEFAULT 0.0
        )
        '''
      );

      // Check for existing progress
      final result = await conn.execute(
        r'SELECT percentage FROM student_progress WHERE parent_id = $1',
        parameters: [userId],
      );

      if (result.isNotEmpty) {
        await conn.close();
        return (result[0][0] as num).toDouble();
      } else {
        // Create initial entry if Verified? Or just return 0.
        // For now, return 0.
        await conn.close();
        return 0.0;
      }
    } catch (e) {
      print("Get Student Progress Error: $e");
      return 0.0;
    }
  }
  // Initialize Gallery Table
  static Future<void> createGalleryTable() async {
    try {
      final conn = await connect();
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS school_photos (
          id SERIAL PRIMARY KEY,
          student_id INTEGER, -- NULL for public/school-wide photos
          title VARCHAR(255),
          image_path VARCHAR(255),
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
        )
        '''
      );
      await conn.close();
      print("Gallery table checked/created.");
    } catch (e) {
      print("Database Gallery Table Creation Error: $e");
    }
  }

  // Initialize Updates and Logs Tables
  static Future<void> createUpdatesTables() async {
    try {
      final conn = await connect();
      // School Updates Table
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS school_updates (
          id SERIAL PRIMARY KEY,
          title VARCHAR(255),
          description TEXT,
          date DATE,
          image_path VARCHAR(255),
          external_link VARCHAR(255),
          is_new BOOLEAN DEFAULT FALSE
        )
        '''
      );
      
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS daily_logs (
          log_id SERIAL PRIMARY KEY,
          student_id INTEGER,
          title VARCHAR(255),
          description TEXT,
          date DATE,
          activity_type VARCHAR(50),
          image_path VARCHAR(255),
          FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
        )
        '''
      );
      
      // Migration: Ensure activity_type exists if table was created previously
      try {
        await conn.execute("ALTER TABLE daily_logs ADD COLUMN IF NOT EXISTS activity_type VARCHAR(50)");
      } catch (e) {
        print("Migration Error (daily_logs): $e");
      }

      await conn.close();
      print("Updates and Logs tables checked/created.");
    } catch (e) {
      print("Database Updates Table Creation Error: $e");
    }
  }

  // Fetch School Updates
  static Future<List<Map<String, dynamic>>> getSchoolUpdates() async {
    try {
      await createUpdatesTables();
      final conn = await connect();
      final result = await conn.execute(
        r'SELECT title, description, date, image_path, external_link, is_new FROM school_updates ORDER BY date DESC',
      );
      await conn.close();
      
      return result.map((row) {
        dynamic dateVal = row[2];
        DateTime? parsedDate;
        if (dateVal is DateTime) {
          parsedDate = dateVal;
        } else if (dateVal is String) {
          parsedDate = DateTime.tryParse(dateVal);
        }
        
        return {
          'title': row[0] as String?,
          'description': row[1] as String?,
          'date': parsedDate,
          'image_path': row[3] as String?,
          'external_link': row[4] as String?,
          'is_new': row[5] as bool? ?? false,
        };
      }).toList();
    } catch (e) {
      print("Get School Updates Error: $e");
      return [];
    }
  }

  // Fetch Student Logs
  static Future<List<Map<String, dynamic>>> getStudentLogs(String parentEmail) async {
    try {
      print("DBHelper: Fetching logs for parent: $parentEmail");
      final userId = await getUserId(parentEmail);
      if (userId == null) {
        print("DBHelper: User ID not found for $parentEmail");
        return [];
      }

      // Get Student ID first (Assuming 1 student for now)
      final conn = await connect();
      final studentResult = await conn.execute(
        r'SELECT student_id FROM students WHERE parent_id = $1 LIMIT 1',
        parameters: [userId],
      );
      
      if (studentResult.isEmpty) {
        print("DBHelper: No student found for parent ID $userId");
        await conn.close();
        return [];
      }
      
      final studentId = studentResult[0][0] as int;
      print("DBHelper: Found student_id: $studentId");

      await createUpdatesTables();
      
      final result = await conn.execute(
        r'SELECT title, description, date, activity_type, image_path FROM daily_logs WHERE student_id = $1 ORDER BY date DESC',
        parameters: [studentId],
      );
      await conn.close();
      
      print("DBHelper: Found ${result.length} logs for student_id $studentId");

      return result.map((row) {
        dynamic dateVal = row[2];
        DateTime? parsedDate;
        if (dateVal is DateTime) {
          parsedDate = dateVal;
        } else if (dateVal is String) {
          parsedDate = DateTime.tryParse(dateVal);
        }

        return {
          'title': row[0] as String?,
          'description': row[1] as String?,
          'date': parsedDate,
          'activity_type': row[3] as String?,
          'image_path': row[4] as String?,
        };
      }).toList();

    } catch (e) {
      print("Get Student Logs Error: $e");
      return [];
    }
  }
  // Fetch Gallery Photos
  static Future<List<Map<String, dynamic>>> getGalleryPhotos(String parentEmail) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return [];

      final conn = await connect();
      // Get Student ID
      final studentResult = await conn.execute(
        r'SELECT student_id FROM students WHERE parent_id = $1 LIMIT 1',
        parameters: [userId],
      );
      
      if (studentResult.isEmpty) {
        await conn.close();
        return [];
      }
      
      final studentId = studentResult[0][0] as int;

      await createGalleryTable();
      
      // Fetch photos: Public (student_id is NULL) OR Specific to this student
      final result = await conn.execute(
        r'SELECT id, student_id, title, image_path, created_at FROM school_photos WHERE student_id IS NULL OR student_id = $1 ORDER BY created_at DESC',
        parameters: [studentId],
      );
      await conn.close();

      return result.map((row) {
        return {
          'id': row[0] as int,
          'student_id': row[1] as int?,
          'title': row[2] as String?,
          'image_path': row[3] as String?,
          'created_at': row[4] as DateTime?,
        };
      }).toList();

    } catch (e) {
      print("Get Gallery Photos Error: $e");
      return [];
    }
  }
  // Initialize Child Activities Table
  static Future<void> createChildActivitiesTable() async {
    try {
      final conn = await connect();
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS child_activities (
          id SERIAL PRIMARY KEY,
          student_id INTEGER,
          activity_text VARCHAR(255),
          activity_type VARCHAR(50), -- e.g., 'world', 'puzzle', 'alphabet'
          date DATE,
          week_number INTEGER,
          day_number INTEGER,
          FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
        )
        '''
      );
      
      // Migration: Ensure activity_type exists if table was created previously without it
      try {
        await conn.execute("ALTER TABLE child_activities ADD COLUMN IF NOT EXISTS activity_type VARCHAR(50)");
      } catch (e) {
        print("Migration Error (child_activities): $e");
      }

      await conn.close();
      print("Child Activities table checked/created.");
    } catch (e) {
      print("Database Child Activities Table Creation Error: $e");
    }
  }

  // Fetch Activities by Date
  static Future<List<Map<String, dynamic>>> getActivitiesByDate(String parentEmail, DateTime date) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return [];

      final conn = await connect();
      // Get Student ID
      final studentResult = await conn.execute(
        r'SELECT student_id FROM students WHERE parent_id = $1 LIMIT 1',
        parameters: [userId],
      );
      
      if (studentResult.isEmpty) {
        await conn.close();
        return [];
      }
      
      final studentId = studentResult[0][0] as int;

      await createChildActivitiesTable();

      // Format date for query (YYYY-MM-DD)
      final dateStr = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      
      final result = await conn.execute(
        r'SELECT activity_text, activity_type, week_number, day_number FROM child_activities WHERE student_id = $1 AND date = $2',
        parameters: [studentId, dateStr],
      );
      await conn.close();

      return result.map((row) {
        return {
          'activity_text': row[0] as String?,
          'activity_type': row[1] as String?, // 'world', 'puzzle', 'alphabet', etc.
          'week': row[2] as int?,
          'day': row[3] as int?,
        };
      }).toList();

    } catch (e) {
      print("Get Activities By Date Error: $e");
      return [];
    }
  }

  // Fetch Activities by Week/Day
  static Future<List<Map<String, dynamic>>> getActivitiesByWeekDay(String parentEmail, int week, int day) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return [];

      final conn = await connect();
      final studentResult = await conn.execute(
        r'SELECT student_id FROM students WHERE parent_id = $1 LIMIT 1',
        parameters: [userId],
      );
      
      if (studentResult.isEmpty) {
        await conn.close();
        return [];
      }
      
      final studentId = studentResult[0][0] as int;

      // Ensure table and columns exist before querying
      await createChildActivitiesTable();

      final result = await conn.execute(
        r'SELECT activity_text, activity_type, week_number, day_number FROM child_activities WHERE student_id = $1 AND week_number = $2 AND day_number = $3',
        parameters: [studentId, week, day],
      );
      await conn.close();

      return result.map((row) {
        return {
          'activity_text': row[0] as String?,
          'activity_type': row[1] as String?,
          'week': row[2] as int?,
          'day': row[3] as int?,
        };
      }).toList();

    } catch (e) {
      print("Get Activities By Week/Day Error: $e");
      return [];
    }
  }

  // Seed Child Activities (For Testing)
  static Future<void> seedChildActivities(String parentEmail) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return;

      final conn = await connect();
      final studentResult = await conn.execute(
        r'SELECT student_id FROM students WHERE parent_id = $1 LIMIT 1',
        parameters: [userId],
      );
      
      if (studentResult.isEmpty) {
        await conn.close();
        return;
      }
      final studentId = studentResult[0][0] as int;

      // Check if data exists
      final check = await conn.execute(r'SELECT count(*) FROM child_activities WHERE student_id = $1', parameters: [studentId]);
      if ((check[0][0] as int) > 0) {
        await conn.close();
        return; // Already seeded
      }

      // Seed data for Today
      final today = DateTime.now();
      final dateStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      
      await conn.execute(
        r"INSERT INTO child_activities (student_id, activity_text, activity_type, date, week_number, day_number) VALUES "
        r"($1, 'Learned different Landforms on the Earth', 'world', $2, 31, 1), "
        r"($1, 'Practiced self-control through Stop, Think, Act activity', 'puzzle', $2, 31, 1), "
        r"($1, 'Understood long vowel ie family words', 'alphabet', $2, 31, 1), "
        r"($1, 'Participated in physical activities', 'physical', $2, 31, 1), "
        r"($1, 'Learned numbers from 161 to 170', 'number', $2, 31, 1)",
        parameters: [studentId, dateStr],
      );
      
      print("Seeded child activities for testing.");
      await conn.close();
    } catch (e) {
      print("Seed Child Activities Error: $e");
    }
  }

  // Initialize Student Achievements Table
  static Future<void> createStudentAchievementsTable() async {
    try {
      final conn = await connect();
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS student_achievements (
          id SERIAL PRIMARY KEY,
          student_id INTEGER,
          title VARCHAR(255),
          description TEXT,
          image_path VARCHAR(255),
          category VARCHAR(50), -- 'Academic', 'Social', 'Creative'
          is_claimed BOOLEAN DEFAULT FALSE,
          date_earned DATE,
          FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
        )
        '''
      );
      await conn.close();
      print("Student Achievements table checked/created.");
    } catch (e) {
      print("Database Student Achievements Table Creation Error: $e");
    }
  }

  // Seed Student Achievements (For Testing)
  static Future<void> seedStudentAchievements(String parentEmail) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return;

      final conn = await connect();
      final studentResult = await conn.execute(
        r'SELECT student_id FROM students WHERE parent_id = $1 LIMIT 1',
        parameters: [userId],
      );
      
      if (studentResult.isEmpty) {
        await conn.close();
        return;
      }
      final studentId = studentResult[0][0] as int;

      await createStudentAchievementsTable();

      // Check if data exists
      // final check = await conn.execute(r'SELECT count(*) FROM student_achievements WHERE student_id = $1', parameters: [studentId]);
      // if ((check[0][0] as int) > 0) {
      //   await conn.close();
      //   return; // Already seeded
      // }

      final today = DateTime.now();
      final dateStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      
      // Seeding specific data as requested
      // We use ON CONFLICT or just simpler INSERTs if empty. 
      // But to fix EXISTING wrong paths (like assets/badges/), we should try to UPDATE them too or just use a fix query.
      
      // 1. Insert if not exists
      await conn.execute(
        r"INSERT INTO student_achievements (student_id, title, description, image_path, category, is_claimed, date_earned) VALUES "
        r"($1, 'Super Reader', 'Read 5 books this month', 'assets/images/reader.jpg', 'Academic', FALSE, $2), "
        r"($1, 'Helping Hand', 'Helped a friend in class', 'assets/images/helping.jpg', 'Social', FALSE, $2), "
        r"($1, 'Little Artist', 'Created a beautiful painting', 'assets/images/artist.jpg', 'Creative', TRUE, $2) "
        r"ON CONFLICT (id) DO NOTHING", // Assuming ID might not match, so we rely on checks below or just insert new ones if empty table
        parameters: [studentId, dateStr],
      );

      // 2. FORCE UPDATE paths to ensure they are correct (Fixing any 'assets/badges/' issues)
      await conn.execute(r"UPDATE student_achievements SET image_path = 'assets/images/reader.jpg' WHERE title = 'Super Reader' AND student_id = $1", parameters: [studentId]);
      await conn.execute(r"UPDATE student_achievements SET image_path = 'assets/images/helping.jpg' WHERE title = 'Helping Hand' AND student_id = $1", parameters: [studentId]);
      await conn.execute(r"UPDATE student_achievements SET image_path = 'assets/images/artist.jpg' WHERE title = 'Little Artist' AND student_id = $1", parameters: [studentId]);
      
      print("Seeded/Updated student achievements.");
      await conn.close();
    } catch (e) {
      print("Seed Student Achievements Error: $e");
    }
  }

  // Fetch Achievements
  static Future<List<Map<String, dynamic>>> getAchievements(String parentEmail, {bool? isClaimed}) async {
    try {
      // 1. Get User ID from Email
      final userId = await getUserId(parentEmail);
      if (userId == null) {
        print("DBHelper: User not found for email $parentEmail");
        return [];
      }

      final conn = await connect();
      
      // 2. Get Student ID from User ID (Parent ID)
      final studentResult = await conn.execute(
        r'SELECT student_id FROM students WHERE parent_id = $1 LIMIT 1',
        parameters: [userId],
      );

      if (studentResult.isEmpty) {
        print("DBHelper: No student linked to parent $parentEmail");
        await conn.close();
        return [];
      }
      final studentId = studentResult[0][0] as int;

      await createStudentAchievementsTable();
      
      // Auto-seed if empty (for convenient testing)
      // await seedStudentAchievements(parentEmail); // Removed to prevent duplicates
      
      // 3. Fetch Achievements for Student
      String query = r'SELECT id, title, description, image_path, category, is_claimed, date_earned FROM student_achievements WHERE student_id = $1';
      List<dynamic> params = [studentId];

      if (isClaimed != null) {
        query += r' AND is_claimed = $2';
        params.add(isClaimed);
      }
      
      query += r' ORDER BY date_earned DESC';

      final result = await conn.execute(query, parameters: params);
      await conn.close();

      return result.map((row) {
        return {
          'id': row[0] as int,
          'title': row[1] as String?,
          'description': row[2] as String?,
          'image_path': row[3] as String?,
          'category': row[4] as String?,
          'is_claimed': row[5] as bool? ?? false,
          'date_earned': row[6] as DateTime?,
        };
      }).toList();

    } catch (e) {
      print("Get Achievements Error: $e");
      return [];
    }
  }

  // --- School Connect Helpers ---

  // Initialize School Connect Table
  static Future<void> createSchoolConnectTable() async {
    try {
      final conn = await connect();
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS school_connect (
          id SERIAL PRIMARY KEY,
          school_name VARCHAR(255),
          address TEXT,
          phone_number VARCHAR(50),
          email VARCHAR(100),
          website VARCHAR(255),
          emergency_contact_name VARCHAR(100),
          emergency_contact_number VARCHAR(50),
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
        '''
      );
      await conn.close();
      print("School Connect table checked/created.");
    } catch (e) {
      print("Database School Connect Table Creation Error: $e");
    }
  }

  // Seed School Connect Data (For Testing)
  static Future<void> seedSchoolConnectData() async {
    try {
      await createSchoolConnectTable();
      final conn = await connect();

      // Check if data exists
      final check = await conn.execute(r'SELECT count(*) FROM school_connect');
      if ((check[0][0] as int) > 0) {
        await conn.close();
        return; // Already seeded
      }

      await conn.execute(
        r"INSERT INTO school_connect (school_name, address, phone_number, email, website, emergency_contact_name, emergency_contact_number) VALUES "
        r"($1, $2, $3, $4, $5, $6, $7)",
        parameters: [
          'Bluestone Preschool',
          '123, Learning Lane, Knowledge City, State - 560001',
          '+91 98765 43210',
          'info@bluestonepreschool.com',
          'www.bluestonepreschool.com',
          'Mr. Emergency Manager',
          '+91 11223 34455'
        ],
      );
      
      print("Seeded school connect data.");
      await conn.close();
    } catch (e) {
      print("Seed School Connect Data Error: $e");
    }
  }

  // Fetch School Connect Details
  static Future<Map<String, dynamic>?> getSchoolConnectDetails() async {
    try {
      await seedSchoolConnectData(); // Ensure data exists for now
      final conn = await connect();
      
      final result = await conn.execute(
        r'SELECT school_name, address, phone_number, email, website, emergency_contact_name, emergency_contact_number FROM school_connect LIMIT 1',
      );
      await conn.close();
      
      if (result.isNotEmpty) {
        return {
          'school_name': result[0][0] as String?,
          'address': result[0][1] as String?,
          'phone_number': result[0][2] as String?,
          'email': result[0][3] as String?,
          'website': result[0][4] as String?,
          'emergency_contact_name': result[0][5] as String?,
          'emergency_contact_number': result[0][6] as String?,
        };
      }
      return null;
    } catch (e) {
      print("Get School Connect Details Error: $e");
      return null;
    }
  }

  // ---------------- School Requests ----------------

  static Future<void> createSchoolRequestsTable() async {
    try {
      final conn = await connect();
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS school_requests (
          id SERIAL PRIMARY KEY,
          parent_id INTEGER,
          request_type VARCHAR(100),
          from_date DATE,
          to_date DATE,
          reason VARCHAR(100),
          message TEXT,
          attachment_path VARCHAR(255),
          status VARCHAR(50) DEFAULT 'Pending',
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (parent_id) REFERENCES users(id) ON DELETE CASCADE
        )
        '''
      );
      await conn.close();
      print("School Requests table checked/created.");
    } catch (e) {
      print("Database School Requests Table Creation Error: $e");
    }
  }

  static Future<bool> submitSchoolRequest({
    required String parentEmail,
    required String requestType,
    required String message,
    DateTime? fromDate,
    DateTime? toDate,
    String? reason,
    String? attachmentPath,
  }) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) {
        debugPrint("SUBMISSION ERROR: User ID not found for email $parentEmail");
        return false;
      }

      await createSchoolRequestsTable();
      final conn = await connect();

      // Format dates to ISO8601 strings (yyyy-MM-dd)
      // PostgreSQL DATE type expects 'yyyy-MM-dd'
      String? fromDateStr;
      if (fromDate != null) {
         fromDateStr = "${fromDate.year}-${fromDate.month.toString().padLeft(2, '0')}-${fromDate.day.toString().padLeft(2, '0')}";
      }
      
      String? toDateStr;
      if (toDate != null) {
         toDateStr = "${toDate.year}-${toDate.month.toString().padLeft(2, '0')}-${toDate.day.toString().padLeft(2, '0')}";
      }

      await conn.execute(
        r'INSERT INTO school_requests (parent_id, request_type, from_date, to_date, reason, message, attachment_path) VALUES ($1, $2, $3, $4, $5, $6, $7)',
        parameters: [userId, requestType, fromDateStr, toDateStr, reason, message, attachmentPath],
      );
      await conn.close();
      debugPrint("School Request Submitted: $requestType");
      return true;
    } catch (e) {
      debugPrint("SUBMISSION ERROR: $e");
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getSchoolRequests(String parentEmail) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return [];

      await createSchoolRequestsTable();
      final conn = await connect();

      final result = await conn.execute(
        r'SELECT id, request_type, status, created_at, message, reason FROM school_requests WHERE parent_id = $1 ORDER BY created_at DESC',
        parameters: [userId],
      );
      await conn.close();

      return result.map((row) {
        return {
          'id': row[0] as int,
          'request_type': row[1] as String?,
          'status': row[2] as String?,
          'created_at': row[3] as DateTime?,
          'message': row[4] as String?,
          'reason': row[5] as String?,
        };
      }).toList();
    } catch (e) {
      print("Get School Requests Error: $e");
      return [];
    }
  }

  // ---------------- Teacher Notes ----------------
  
  // Initialize Teacher Notes Table
  static Future<void> createTeacherNotesTable() async {
    try {
      final conn = await connect();
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS teacher_notes (
          id SERIAL PRIMARY KEY,
          student_id INTEGER,
          title VARCHAR(255),
          summary TEXT,
          full_note TEXT,
          illustration_path VARCHAR(255),
          detail_image_path VARCHAR(255),
          date DATE,
          FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
        )
        '''
      );
      await conn.close();
      print("Teacher Notes table checked/created.");
    } catch (e) {
      print("Database Teacher Notes Table Creation Error: $e");
    }
  }

  // Seed Teacher Notes (For Testing)
  static Future<void> seedTeacherNotes(String parentEmail) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return;

      final conn = await connect();
      final studentResult = await conn.execute(
        r'SELECT student_id FROM students WHERE parent_id = $1 LIMIT 1',
        parameters: [userId],
      );
      
      if (studentResult.isEmpty) {
        await conn.close();
        return;
      }
      final studentId = studentResult[0][0] as int;

      await createTeacherNotesTable();

      // Check if data exists
      final check = await conn.execute(r'SELECT count(*) FROM teacher_notes WHERE student_id = $1', parameters: [studentId]);
      if ((check[0][0] as int) > 0) {
        await conn.close();
        return; // Already seeded
      }

      final today = DateTime.now();
      final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      
      final yesterday = today.subtract(const Duration(days: 1));
      final yesterdayStr = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";

      // Seeding specific data as requested
      await conn.execute(
        r"INSERT INTO teacher_notes (student_id, title, summary, full_note, illustration_path, detail_image_path, date) VALUES "
        r"($1, 'Showing Kindness', 'Today your child shared toys with classmates willingly and displayed kindness by offering help to a friend who needed assistance.', 'It was heartwarming to see your child demonstrate such empathy today. During free play, they noticed a classmate struggling to build a tower and immediately offered their own blocks to help. Sharing is a crucial social skill, and your child is modeling it beautifully for others.', 'assets/images/showing_kindness.png', 'assets/images/showing_kindness_large.png', $2), "
        r"($1, 'Growing independence', 'Your child independently put on their shoes today. They are showing great progress in self care and following routines on their own.', 'We are so proud of the independence your child is showing! Today, they insisted on putting on their shoes by themselves before outdoor play. It took a little patience, but they persevered and succeeded. Encouraging these self-care tasks at home will continue to build their confidence.', 'assets/images/growing_independence.png', 'assets/images/growing_independence_large.png', $2), "
        r"($1, 'Creative Expression', 'Loved painting with watercolors today!', 'Your child explored mixing colors to create a vibrant garden scene. They were very focused and proud of their artwork.', 'assets/images/creative_expression.png', 'assets/images/creative_expression_large.png', $3)",
        parameters: [studentId, todayStr, yesterdayStr],
      );
      
      print("Seeded teacher notes for testing.");
      await conn.close();
    } catch (e) {
      print("Seed Teacher Notes Error: $e");
    }
  }

  // Fetch Teacher Notes
  static Future<List<Map<String, dynamic>>> getTeacherNotes(String parentEmail) async {
    try {
      final userId = await getUserId(parentEmail);
      if (userId == null) return [];

      final conn = await connect();
      final studentResult = await conn.execute(
        r'SELECT student_id FROM students WHERE parent_id = $1 LIMIT 1',
        parameters: [userId],
      );
      
      if (studentResult.isEmpty) {
        await conn.close();
        return [];
      }
      final studentId = studentResult[0][0] as int;

      await createTeacherNotesTable();
      // await seedTeacherNotes(parentEmail); // Auto-seed disabled to prevent duplicates

      final result = await conn.execute(
        r'SELECT id, title, summary, full_note, illustration_path, detail_image_path, date FROM teacher_notes WHERE student_id = $1 ORDER BY date DESC',
        parameters: [studentId],
      );
      await conn.close();

      return result.map((row) {
        print("Teacher Note Date: ${row[6]} for title: ${row[1]}");
        return {
          'id': row[0] as int,
          'title': row[1] as String?,
          'summary': row[2] as String?,
          'full_note': row[3] as String?,
          'illustration_path': row[4] as String?,
          'detail_image_path': row[5] as String?,
          'date': row[6] as DateTime?,
        };
      }).toList();
    } catch (e) {
      print("Get Teacher Notes Error: $e");
      return [];
    }
  }
  static Future<bool> claimAchievement(int achievementId) async {
    try {
      final conn = await connect();
      await conn.execute(
        r'UPDATE student_achievements SET is_claimed = TRUE WHERE id = $1',
        parameters: [achievementId],
      );
      await conn.close();
      return true;
    } catch (e) {
      print("Claim Achievement Error: $e");
      return false;
    }
  }

  // ---------------- Parent Hub ----------------

  // Initialize Parent Hub Table
  static Future<void> createParentHubTable() async {
    try {
      final conn = await connect();
      await conn.execute(
        r'''
        CREATE TABLE IF NOT EXISTS parent_hub (
          id SERIAL PRIMARY KEY,
          week_number INTEGER,
          type VARCHAR(50), -- 'Smart Parenting' or 'Week End Letter'
          title VARCHAR(255),
          description TEXT,
          thumbnail_path VARCHAR(255),
          content_url VARCHAR(255) -- Image or PDF path
        )
        '''
      );
      await conn.close();
      print("Parent Hub table checked/created.");
    } catch (e) {
      print("Database Parent Hub Table Creation Error: $e");
    }
  }

  // Seed Parent Hub Content
  static Future<void> seedParentHubContent() async {
    try {
      final conn = await connect();
      
      await createParentHubTable();

      // Check if data exists
      final check = await conn.execute(r'SELECT count(*) FROM parent_hub');
      if ((check[0][0] as int) > 0) {
        await conn.close();
        return; // Already seeded
      }

      // Seeding for Weeks 30, 31, 32
      await conn.execute(
        r"INSERT INTO parent_hub (week_number, type, title, description, thumbnail_path, content_url) VALUES "
        // Week 31
        r"(31, 'Smart Parenting', 'Positive Discipline', 'Learn effective strategies for positive discipline without yelling.', 'assets/images/positive_discipline.jpg', 'assets/images/positive_discipline.jpg'), "
        r"(31, 'Week End Letter', 'Week 31 Wrap Up', 'A summary of all the fun and learning from Week 31.', 'assets/images/week_31_wrap_up.jpg', 'assets/images/week_31_wrap_up.jpg'), "
        // Week 30
        r"(30, 'Smart Parenting', 'Building Confidence', 'Tips to help your child build self-esteem and confidence.', 'assets/images/building_confidence.jpg', 'assets/images/building_confidence.jpg'), "
        r"(30, 'Week End Letter', 'Week 30 Highlights', 'Recap of our field trip and art projects.', 'assets/images/week_30_highlights.jpg', 'assets/images/week_30_highlights.jpg'), "
        // Week 32
        r"(32, 'Smart Parenting', 'Healthy Eating Habits', 'Encouraging your child to try new foods and eat healthy.', 'assets/images/healthy_eating_habits.jpg', 'assets/images/healthy_eating_habits.jpg') "
      );
      
      print("Seeded Parent Hub content.");
      await conn.close();
    } catch (e) {
      print("Seed Parent Hub Content Error: $e");
    }
  }

  static Future<void> initParentHub() async {
     await createParentHubTable();
     await seedParentHubContent();
     await _fixImagePaths();
  }

  static Future<void> _fixImagePaths() async {
    try {
      final conn = await connect();
      // Week 30
      await conn.execute("UPDATE parent_hub SET thumbnail_path = 'assets/images/building_confidence.jpg', content_url = 'assets/images/building_confidence.jpg' WHERE week_number = 30 AND type = 'Smart Parenting'");
      await conn.execute("UPDATE parent_hub SET thumbnail_path = 'assets/images/week_30_highlights.jpg', content_url = 'assets/images/week_30_highlights.jpg' WHERE week_number = 30 AND type = 'Week End Letter'");
      
      // Week 31
      await conn.execute("UPDATE parent_hub SET thumbnail_path = 'assets/images/positive_discipline.jpg', content_url = 'assets/images/positive_discipline.jpg' WHERE week_number = 31 AND type = 'Smart Parenting'");
      await conn.execute("UPDATE parent_hub SET thumbnail_path = 'assets/images/week_31_wrap_up.jpg', content_url = 'assets/images/week_31_wrap_up.jpg' WHERE week_number = 31 AND type = 'Week End Letter'");

      // Week 32
      await conn.execute("UPDATE parent_hub SET thumbnail_path = 'assets/images/healthy_eating_habits.jpg', content_url = 'assets/images/healthy_eating_habits.jpg' WHERE week_number = 32 AND type = 'Smart Parenting'");
      
      await conn.close();
      print("Fixed Parent Hub Image Paths");
    } catch (e) {
      print("Fix Paths Error: $e");
    }
  }

  // Fetch Parent Hub Content by Week
  static Future<List<Map<String, dynamic>>> getParentHubContent(int weekNumber) async {
    try {
      final conn = await connect();
      // Init moved to separate method to prevent loops

      final result = await conn.execute(
        r'SELECT id, type, title, description, thumbnail_path, content_url FROM parent_hub WHERE week_number = $1',
        parameters: [weekNumber],
      );
      await conn.close();

      return result.map((row) {
        return {
          'id': row[0] as int,
          'type': row[1] as String?,
          'title': row[2] as String?,
          'description': row[3] as String?,
          'thumbnail_path': row[4] as String?,
          'content_url': row[5] as String?,
        };
      }).toList();
    } catch (e) {
      print("Get Parent Hub Content Error: $e");
      return [];
    }
  }

  // Fetch Available Weeks
  static Future<List<int>> getAvailableWeeks() async {
    try {
      final conn = await connect();
      // Init moved to separate method to prevent loops

      final result = await conn.execute(
        r'SELECT DISTINCT week_number FROM parent_hub ORDER BY week_number DESC',
      );
      await conn.close();

      return result.map((row) => row[0] as int).toList();
    } catch (e) {
      print("Get Available Weeks Error: $e");
      return [];
    }
  }

}
