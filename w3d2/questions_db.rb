require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton 

  def initialize 
    super('questions.db')
    self.type_translation = true 
    self.results_as_hash = true 
  end 
end 

class User 
  def self.all
    user_data = QuestionsDatabase.instance.execute('SELECT * FROM users')
    user_data.map { |datum| User.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end 

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM users WHERE id = ? 
    SQL

    return nil unless user.length > 0

    User.new(user.first)
  end 

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT * FROM users WHERE fname = ? AND lname = ?
    SQL

    return nil unless user.length > 0

    User.new(user.first)
  end 

  def authored_questions
    Question.find_by_asker_id(@id) 
  end

  def authored_replies 
    Reply.find_by_author_id(@id)
  end 
end 

class Question 
  attr_reader :body

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @asker_id = options['asker_id']
  end 

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM questions WHERE id = ? 
    SQL

    return nil unless question.length > 0

    Question.new(question.first)
  end 

    def self.find_by_asker_id(asker_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, asker_id)
      SELECT * FROM questions WHERE asker_id = ? 
    SQL

    return nil unless question.length > 0

    Question.new(question.first)
  end 

  def author 
    User.find_by_id(@asker_id)
  end 

  def replies 
    Reply.find_by_subject_question_id(@id)
  end 

end 

class QuestionFollow
  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end 

  def self.find_by_id(id)
    question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM question_follows WHERE id = ? 
    SQL

    return nil unless question_follow.length > 0

    QuestionFollow.new(question_follow.first)
  end 
end 

class Reply
  def initialize(options)
    @id = options['id']
    @body = options['body']
    @subject_question_id = options['subject_question_id']
    @author_id = options['author_id']
    @parent_reply_id = options['parent_reply_id']
  end 

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT * FROM replies WHERE id = ? 
    SQL

    return nil unless reply.length > 0

    Reply.new(reply.first)
  end 

   def self.find_by_author_id(author_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT * FROM replies WHERE author_id = ? 
    SQL

    return nil unless reply.length > 0

    array = Array.new 

    reply.each_with_index do |r, i|
        array << Reply.new(r)
    end 

    array 
  end 

  def self.find_by_subject_question_id(subject_question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, subject_question_id)
      SELECT * FROM replies WHERE subject_question_id = ? 
    SQL

    return nil unless reply.length > 0

    array = Array.new 

    reply.each do |r|
      array << Reply.new(r)
    end 

    array 
  end 
end 

if __FILE__ == $PROGRAM_NAME 

# n = User.find_by_name('Niyati', 'Desai')
# p "_________________________"
# p n.authored_replies
# p User.find_by_name('Niyati', 'Desai')
# p "_________________________"
# p User.find_by_name('Marianna','Mullens')
# p "_________________________"
d = Question.find_by_asker_id(1)
p "____________________"
p d.replies 
# p Question.find_by_asker_id(2)
# p "____________________"
# p Question.find_by_asker_id(3)
# p "_____________________"
# p "_____________________"
# p Question.find_by_id(1)
# p "____________________"
# p Question.find_by_id(2)
# p "____________________"
# p Question.find_by_id(3)
# p '____________________' 
# p Reply.find_by_author_id(1)
# p '____________________'
# p Reply.find_by_author_id(2)
# p '____________________'
# p Reply.find_by_author_id(3)
# p "_____________________"
# p Reply.find_by_subject_question_id(1)
# p '____________________'
# p Reply.find_by_subject_question_id(2)
# p '____________________'
# p Reply.find_by_subject_question_id(3)
# p '____________________' 
# p QuestionFollow.find_by_id(1)
# p '____________________'
# p QuestionFollow.find_by_id(2)
# p '____________________'
# p QuestionFollow.find_by_id(3)
# p '____________________' 
# p Like.find_by_id(1)
# p '____________________'
# p Like.find_by_id(2)
# p '____________________'
# p Like.find_by_id(3)
# p '____________________' 
# p Question.find_by_user_id(1)
# p '____________________'
# p Question.find_by_user_id(2)
# p '____________________'
# p Question.find_by_user_id(3)

end 