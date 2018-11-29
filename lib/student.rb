require 'pry'
class Student
  attr_accessor :id, :name, :grade

  # def initialize(id = nil, name, grade) - not needed!
  #   @id = id
  #   @name = name
  #   @grade = grade
  # end

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      select * from students
    SQL
    students = DB[:conn].execute(sql)
    students.map do |sdt| Student.new_from_db(sdt)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      select * from students where students.name = ?
    SQL
    row = DB[:conn].execute(sql, name)[0]
    self.new_from_db(row)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      select * from students where students.grade = ?
    SQL
    students = DB[:conn].execute(sql, 9)
    students.map do |sdt| Student.new_from_db(sdt)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      select * from students where students.grade < 12
    SQL
    students = DB[:conn].execute(sql)
    students.map do |sdt| Student.new_from_db(sdt)
    end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      select * from students where students.grade = ? LIMIT ?
    SQL
    students = DB[:conn].execute(sql, 10, x)
    students.map do |sdt| Student.new_from_db(sdt)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      select * from students where students.grade = ? LIMIT 1
    SQL
    row = DB[:conn].execute(sql, 10)[0]
  
    self.new_from_db(row)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      select * from students where students.grade = ?
    SQL
    students = DB[:conn].execute(sql, x)
    students.map do |sdt| Student.new_from_db(sdt)
    end
  end




end
