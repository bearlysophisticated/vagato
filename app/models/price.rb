class Price < ActiveRecord::Base
  belongs_to :room

	before_save :default_values
  	def default_values
    	self.vat = PricesHelper.default_vat
    	self.ifa = PricesHelper.default_ifa
    	self.currency = PricesHelper.default_currency
  	end

	def value_with_vat
		value + (value * vat)
	end
end
