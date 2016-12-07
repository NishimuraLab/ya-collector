class Similarity < ActiveRecord::Base
  belongs_to :label

  def pair_label
    Label.find_by_id(self.pair_label_id)
  end
end
