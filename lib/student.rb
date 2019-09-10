class Student

  attr_accessor :id, :name, :grade

  def self.create_table
    sql = <<-SQL
        CREATE TABLE IF NOT EXISTS students
        (id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER)
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
        DROP TABLE IF EXISTS students
      SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name,grade)
      VALUES (?,?)
      SQL
    DB[:conn].execute(sql,self.name,self.grade)
  end

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      SQL
    self.new_from_db(DB[:conn].execute(sql,name)[0])
  end

  def self.all_students_in_grade_9
    array = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      SQL
    DB[:conn].execute(sql,9).each {|student_array| array << self.new_from_db(student_array)}
    array
  end

  def self.students_below_12th_grade
    array = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade <= ?
      SQL
    DB[:conn].execute(sql,11).each {|student_array| array << self.new_from_db(student_array)}
    array
  end

  def self.all
    array = []
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
    DB[:conn].execute(sql).each {|student_array| array << self.new_from_db(student_array)}
    array
  end

  def self.first_X_students_in_grade_10(num_students)
    array = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      LIMIT ?
      SQL
    DB[:conn].execute(sql,10,num_students).each {|student_array| array << self.new_from_db(student_array)}
    array
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      LIMIT ?
      SQL
    self.new_from_db(DB[:conn].execute(sql,10,1)[0])
  end

  def self.all_students_in_grade_X(grade)
    array = []
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      SQL
    DB[:conn].execute(sql,grade).each {|student_array| array << self.new_from_db(student_array)}
    array
  end

end
