class ExpandPrintOptionsForUsers < ActiveRecord::Migration
  def up
    # print_calendar:boolean print_email:boolean print_qotd:boolean print_stories:boolean print_twitter_timeline:boolean
    add_column :users, :print_calendar, :boolean, :default => true unless column_exists? :users, :print_calendar
    add_column :users, :print_email, :boolean, :default => true unless column_exists? :users, :print_email
    add_column :users, :print_qotd, :boolean, :default => true unless column_exists? :users, :print_qotd
    add_column :users, :print_stories, :boolean, :default => true unless column_exists? :users, :print_stories
    add_column :users, :print_twitter_timeline, :boolean, :default => false unless column_exists? :users, :print_twitter_timeline

    User.all.each do |user|
      print_options = YAML.load(user[:print_options])
      user.update_attributes(print_calendar: print_options[:print_calendar],
                             print_email: print_options[:print_email],
                             print_qotd: print_options[:print_qotd],
                             print_stories: print_options[:print_stories],
                             print_twitter_timeline: print_options[:print_twitter_timeline])
    end

    remove_column :users, :print_options
  end

  def down
    add_column :users, :print_options, :text


    User.all.each do |user|
      hash = {
        print_calendar: user.print_calendar,
        print_email: user.print_email,
        print_qotd: user.print_qotd,
        print_stories: user.print_stories,
        print_twitter_timeline: user.print_twitter_timeline
      }
      # Rails uses YAML for serialization
      user.update_attribute(:print_options, hash.to_yaml)
    end
    remove_column :users, :print_calendar
    remove_column :users, :print_email
    remove_column :users, :print_qotd
    remove_column :users, :print_stories
    remove_column :users, :print_twitter_timeline
  end
end
