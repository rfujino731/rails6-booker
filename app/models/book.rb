class Book < ApplicationRecord
  is_impressionable counter_cache: true
  
  # has_many :user
  belongs_to :user, optional: true
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end

  def self.one_week_ranks
    #@books = Book.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}
    from = DateTime.now.ago(7.days)
    to = DateTime.now
    puts("ディバッグ")
    puts(from)
    @books = Book.includes(:favorites).sort {
      |a,b|
      b.favorites.includes(:favorites).where(created_at: from...to).size <=>
      a.favorites.includes(:favorites).where(created_at: from...to).size}
  end

  def self.before_one_week
    puts(DateTime.now.ago(7.days))
    date = DateTime.now.ago(7.days)
    @books = Book.where("created_at >= ?", date)
  end
end
