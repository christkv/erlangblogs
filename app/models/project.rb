class Project < ActiveRecord::Base
  
  has_many :project_downloads
  has_many :project_updates

  def full_url()
    if site.eql?("sourceforge")
      return "http://www.sourceforge.com#{self.url}"
    elsif site.eql?("github")
      return "http://www.github.com#{self.url}"
    elsif site.eql?("google")
      return "http://code.google.com#{self.url}"
    end
  end

  def self.most_active_projects(number_of_days, limit)
    # Negate the number to create the timeframe
    number_of_days = number_of_days * -1
    # Figure out the most active projects by calculating the amount of commits over the last 30 days
    return self.find_by_sql(["select p.id, p.title, p.site, p.description, count(*) as activity_level from projects p, project_updates pu where pu.updated_at <= now() and pu.updated_at >= adddate(now(), ?) and p.id = pu.project_id group by p.id order by count(*) desc limit ?", number_of_days, limit])
  end
end
