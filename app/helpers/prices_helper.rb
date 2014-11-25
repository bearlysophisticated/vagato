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
end
