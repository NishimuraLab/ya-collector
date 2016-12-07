class Similarity < ActiveRecord::Base
  belongs_to :label

  def pair_label
    Label.where(pair_label_id: self.pair_label_id).first
  end
end
