module PropertiesHelper
	def self.get_property(group, key)
		properties = YAML.load(File.read(File.expand_path('../../properties.yml', __FILE__)))
		properties[group][key]
	end
	def get_property(group, key)
		PropertiesHelper.get_property(group,key)
	end
end