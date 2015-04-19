module PricesHelper
	def self.default_currency
		return "Ft"
	end

	def default_currency
		PricesHelper.default_currency
	end

	def self.default_vat
		return 0.27
	end

	def default_vat
		PricesHelper.default_vat
	end

	def self.default_ifa
		return 350
	end

	def default_ifa
		PricesHelper.default_ifa
	end

	def self.get_average_price(rooms)
		average_price = 0
		rooms.each do |room|
			average_price += room.price.value_with_vat
		end

		(average_price /= rooms.size).round(2)
	end
end
