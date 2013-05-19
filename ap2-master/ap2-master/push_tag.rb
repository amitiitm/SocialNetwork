require 'rubygems'
require 'yaml'

class Publish

  def get_last_commit_message
    `git log -1 HEAD --pretty=format:%s`
  end

  def get_latest_tag_version
    `git describe --abbrev=0 --tags`
  end

  def version_date
    Date.today.strftime("%Y/%m/%d")
  end

  def generate_version
    version = 'v1.5.'
    tag = get_latest_tag_version
    minor = tag.split(version)[1]
    version+(minor.to_i + 1).to_s
  end

  def generate_tag_version
    date = version_date
    version = generate_version
    {"publish" => {"date" => "#{date}", "version" => "#{version}"}}
  end

  def write_publish_file
    publish_data = YAML::load_file('config/publish.yml')
    puts "Older Content of publish.yml #{publish_data.inspect}"
    publish_version = generate_tag_version
    puts "Current Content of publish.yml #{publish_version.inspect}"
    output = File.new('config/publish.yml', 'w')
    output.puts YAML.dump(publish_version)
    output.close
  end

  def git_add_publish_yml
    `git add config/publish.yml`
  end

  def commit_version_change
    last_version_message = get_last_commit_message
    puts "Last version message #{last_version_message}"
    version = generate_version
    puts "Current Version #{version}"
    `git commit -m 'version changed to #{version} #{last_version_message}'`
  end

  def create_and_push_tag
    version = generate_version
    puts "Creating Tag ..."
    `git tag #{version}`
    puts "Pushing Tag ..."
    `git push --tags`
  end



  def   generate_tag
    puts "Update the file publish.yml"
    write_publish_file
    puts "Added publish.yml to git"
    git_add_publish_yml
    puts "Commited the file to Git"
    commit_version_change
    create_and_push_tag
    puts "Pushing to Git ..."
    `git push`

  end

end

publish = Publish.new
publish.generate_tag






