class CrashController < ApplicationController
	def index
		raise "boom"
	end
end
