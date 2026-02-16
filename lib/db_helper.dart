import 'package:postgres/postgres.dart';

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
          FOREIGN KEY (parent_id) REFERENCES users(id) ON DELETE CASCADE
        )
        '''
      );
      await conn.close();
      print("Students table checked/created.");
    } catch (e) {
      print("Database Table Creation Error: $e");
      // Fallback: If 'users' table doesn't have 'id' as PK or it's named differently, 
      // we might face foreign key issues. 
      // For now, assuming standard 'id' column on users.
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

  // Add Student
  static Future<bool> addStudent(String parentEmail, String name, DateTime dob, String gender) async {
    try {
      // Ensure table exists first
      await createStudentsTable();

      final userId = await getUserId(parentEmail);
      if (userId == null) {
        print("Parent not found for email: $parentEmail");
        return false;
      }

      final conn = await connect();
      await conn.execute(
        r'INSERT INTO students (parent_id, name, dob, gender) VALUES ($1, $2, $3, $4)',
        parameters: [userId, name, dob, gender],
      );
      await conn.close();
      print("Student added successfully.");
      return true;
    } catch (e) {
      print("Add Student Error: $e");
      return false;
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
}
