class Fax
	liquid_methods :pages, :singular_or_plural, :cid, :date

	def pages
		5
	end

	def singular_or_plural
		"pages"
	end

	def cid
		"1(408) 215-1212"
	end

	def date
		Time.now
	end		
end
