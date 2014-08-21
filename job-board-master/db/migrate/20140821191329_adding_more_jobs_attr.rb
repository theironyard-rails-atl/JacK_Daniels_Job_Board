class AddingMoreJobsAttr < ActiveRecord::Migration
  def change
    add_column :jobs, :salary, :string
    add_column :jobs, :location, :string
    add_column :jobs, :company, :string
    add_column :jobs, :type, :string
  end
end
