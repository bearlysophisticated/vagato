class SettingsController < ApplicationController
  def index
    @properties = Hash.new
    Property.all.each do |p|
      unless @properties.has_key? p.group
        @properties[p.group] = Hash.new
      end

      @properties[p.group][p.key] = p.value
    end
  end

  def update

  end
end
