class Project < ActiveRecord::Base
  def full_url()
    if site.eql?("sourceforge")
      return "http://www.sourceforge.com#{self.url}"
    elsif site.eql?("github")
      return "http://www.github.com#{self.url}"
    elsif site.eql?("google")
      return "http://code.google.com#{self.url}"
    end
  end
end
