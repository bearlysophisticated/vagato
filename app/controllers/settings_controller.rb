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
    property = Property.find_by_key(params[:property][:key])
    unless property.nil?
      property.value = params[:property][:value]
      if property.save!
        flash[:notice] = 'A beállítás mentve!'
      else
        flash[:warning] = 'Sikertelen mentés'
      end
    else
      flash[:warning] = 'Sikertelen mentés'
    end

    redirect_to '/settings'
  end

end
