# == Schema Information
#
# Table name: jobs
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  start_date  :date
#  end_date    :date
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Job < ActiveRecord::Base
  validates_presence_of :title, :description, :user_id, :salary, :location, :company, :jobtype

  def self.active
    now   = Date.today
    query = %{
      ( start_date IS NULL OR start_date <= ? ) AND
      ( end_date   IS NULL OR end_date  >= ? )
    }.squish

    where [query, now, now]
  end


  # belongs_to :user
  # ^- would define job.user
  def author
    User.find self.user_id
  end

  def self.search(search)
    search
    where("title ilike ? or description ilike ? or location ilike ? or jobtype ilike ?", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
  end
end
