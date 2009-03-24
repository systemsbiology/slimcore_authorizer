class LabGroupProfile < ActiveRecord::Base
  belongs_to :lab_group
  validates_presence_of :lab_group_id

  # Manually provide a list of column names that should be shown in the lab_groups/index view, 
  # since ActiveResource doesn't seem to provide an easy way to do this.
  class << self; attr_accessor :index_columns end
  @index_columns = []

  # Define a custom warning for destroying this lab group, e.g. 'Destroying this lab group will 
  # also destroy 10 projects!'
  def destroy_warning
    return "Are you sure you want to destroy this lab group?"
  end

  # Any LabProfile attributes that should be included with the LabGroup detail_hash
  def detail_hash
    return {}
  end

end
