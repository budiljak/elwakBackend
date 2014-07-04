class InfoEmpfaenger < ActiveRecord::Base
  belongs_to :info
  belongs_to :benutzer
end
