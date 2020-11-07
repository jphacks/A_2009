class Impression < ApplicationRecord
  extend Enumerize
  belongs_to :material, class_name: 'Material'
  enumerize :value, in: { interseting: 'interseting', good: 'good', know_more: 'know_more' }, default: :good
end
