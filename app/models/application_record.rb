class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true


  def formatted_created_at
    created_at.strftime('%A, %B %e, %Y')
  end
end
