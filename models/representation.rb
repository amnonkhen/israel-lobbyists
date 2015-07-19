class class Lobbyist < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	
	has_many :representations
	has_many :clients, through: :representations

	accepts_nested_attributes_for :clients


end
 < ActiveRecord::Base
  validates :lobbyist, uniqueness: {scope: :client}
  belongs_to :lobbyist
  belongs_to :client
  
end
