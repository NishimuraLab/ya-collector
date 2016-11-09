require 'bundler'
Bundler.require

module YahooAuction
  module Category
    class ChildCategory
      include HappyMapper

      tag 'ChildCategory'
      element :category_id, Integer, tag: 'CategoryId'
      element :category_name, String, tag: 'CategoryName'
      element :category_path, String, tag: 'CategoryPath'
      element :category_id_path, String, tag: 'CategoryIdPath'
      element :parent_category_id, Integer, tag: 'ParentCategoryId'
      element :is_leaf, Boolean, tag: 'IsLeaf'
      element :depth, Integer, tag: 'Depth'
      element :order, Integer, tag: 'Order'
      element :is_link, Boolean, tag: 'IsLink'
      element :is_adult, Boolean, tag: 'IsAdult'
      element :is_leaf_to_link, Boolean, tag: 'IsLeafToLink'
      element :child_category_num, Integer, tag: 'ChildCategoryNum'
    end

    class Category
      include HappyMapper

      tag 'Result'
      element :category_id, Integer, tag: 'CategoryId'
      element :category_name, String, tag: 'CategoryName'
      element :category_path, String, tag: 'CategoryPath'
      element :category_id_path, String, tag: 'CategoryIdPath'
      element :parent_category_id, Integer, tag: 'ParentCategoryId'
      element :is_leaf, Boolean, tag: 'IsLeaf'
      element :depth, Integer, tag: 'Depth'
      element :order, Integer, tag: 'Order'
      element :is_link, Boolean, tag: 'IsLink'
      element :is_adult, Boolean, tag: 'IsAdult'
      element :is_leaf_to_link, Boolean, tag: 'IsLeafToLink'
      element :child_category_num, Integer, tag: 'ChildCategoryNum'

      has_many :child_categories, ChildCategory, tag: 'ChildCategory'
    end

    class ResultSet
      include HappyMapper

      tag 'ResultSet'
      has_one :category, Category, tag: 'Result'
    end
  end
end
