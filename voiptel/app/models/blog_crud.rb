class BlogCrud

  def self.create_blog(blog_hash)
    blog = Blog.new
    blog_hash.each do|name,value|
      blog[name] = value
    end
    save_proc = Proc.new{
      blog.save!
    }
    if blog.errors.empty?
      save_proc.call
    end
    blog
  end
end