class MainController < ApplicationController

  def home
    puts params[:a]
    puts params[:b]
    puts params[:h]
    puts params[:w]
    puts params[:c]
  end

  def create_blog
    blog_hash = params[:blog]
    @blog = BlogCrud.create_blog(blog_hash)
    render('my_blog')
  end

  def show_blog
    id = params[:id]
    @blog = Blog.find(id)
  end

end
