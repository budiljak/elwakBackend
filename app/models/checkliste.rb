class Checkliste < ActiveRecord::Base
  belongs_to :checklisten_vorlage
  belongs_to :schicht

  has_many :checklisten_werts
  accepts_nested_attributes_for :checklisten_werts
end
