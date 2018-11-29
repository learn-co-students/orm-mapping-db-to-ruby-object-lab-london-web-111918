require 'pry'

DB = {:conn => SQLite3::Database.new("db/students.db")}

class Student

  attr_accessor :name, :grade, :id

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students;
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?);
    SQL

    DB[:conn].execute(sql, @name, @grade)

    sql2 = <<-SQL
    SELECT id
    FROM students
    ORDER BY id
    DESC LIMIT 1;
    SQL

    @id = DB[:conn].execute(sql2)[0][0]
end

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?;
    SQL

    row = DB[:conn].execute(sql, name)
    self.new_from_db(row[0])
  end

  def self.all
    sql = <<-SQL
    SELECT *
    FROM students;
    SQL

    table = DB[:conn].execute(sql)
    table.map {|row| self.new_from_db(row)}
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9;
    SQL

    all_rows = DB[:conn].execute(sql)
    all_rows.map {|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade < 12;
    SQL

    all_rows = DB[:conn].execute(sql)
    all_rows.map {|row| self.new_from_db(row)}
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT ?;
    SQL

    DB[:conn].execute(sql, num).map {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT 1;
    SQL

    row = DB[:conn].execute(sql)
    self.new_from_db(row[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?;
    SQL

    all_rows = DB[:conn].execute(sql, grade).map {|row| self.new_from_db(row)}
  end

end
