class Client < ActiveRecord::Base
	validates :name, uniqueness: true
	
	has_many :representations
	has_many :lobbyists, through: :representations

end
