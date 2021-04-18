class Comment < ApplicationRecord
  belongs_to :article

  include Visible
end
