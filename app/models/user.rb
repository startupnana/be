class User < ActiveRecord::Base
	validates :username, length: {minimum: 1}, allow_nil: false, uniqueness: true
	validates :password, length: {minimum: 1}, allow_nil: false
end
