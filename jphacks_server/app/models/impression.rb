class Impression < ApplicationRecord
  extend Enumerize
  belongs_to :material, class_name: 'Material'
  enumerize :value, in: { very_good: 'very_good', good: 'good', know_more: 'know_more' }, default: :good
end
