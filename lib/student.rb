class Student
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def self.get_last_id
    sql= <<-SQL
      SELECT id FROM students ORDER BY id DESC LIMIT 1;
    SQL

    DB[:conn].execute(sql).flatten[0]
  end

  def self.create_table
    sql= <<-SQL
      CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, grade INTEGER);
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql= <<-SQL
      DROP TABLE students;
    SQL

    DB[:conn].execute(sql)
  end

  def self.create(name:, grade:)
    Student.new(name, grade).save
  end

  def save
    sql= <<-SQL
      INSERT INTO students(name, grade) VALUES(?, ?);
    SQL

    DB[:conn].execute(sql, @name, @grade)
    @id = Student.get_last_id
    self
  end
end
