class Post
  include Mongoid::Document
  field :title, type: String
  field :content, type: String

  has_and_belongs_to_many :tags
  validates_presence_of :title

end
