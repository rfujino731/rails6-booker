class BooksController < ApplicationController
before_action :only_current_user, only: [:edit, :update]
impressionist :actions=> [:show]

  def show
    @newbook = Book.new
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comments = @book.book_comments
    @book_comment = BookComment.new
    # 自主的にPV数を伸ばす事が出来ないように、今回はip_addressにてPV数
    impressionist(@book, nil, unique: [:ip_address])
    # impressionist(@book, nil)
    
    unless @user.id == current_user.id
      @currentUserEntry=Entry.where(user_id: current_user.id)
      @userEntry=Entry.where(user_id: @user.id)
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @book = Book.new
    #いいねのランキング順にする
    @books = Book.one_week_ranks
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def only_current_user
    book = Book.find(params[:id])
    redirect_to books_path unless book.user_id == current_user.id
  end
end
