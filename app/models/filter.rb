class Filter < ActiveRecord::Base
  has_many :equipments
  has_many :serviices

  def load_params(params)
    self.city = params[:city]
    self.start_date = params[:start_date]
    self.end_date = params[:end_date]
    self.capacity = params[:capacity] if params.has_key? :capacity

    if params.has_key? :equipment_ids
      params[:equipment_ids].split(',').each do |e|
        self.equipments.push(Equipment.find(e))
      end
    end

    if params.has_key? :serviice_ids
      params[:serviice_ids].split(',').each do |s|
        self.serviices.push(Serviice.find(s))
      end
    end

    self.guests = params[:guests] if params.has_key? :guests
    self.one_bed = params[:one_bed] if params.has_key? :one_bed
    self.two_bed = params[:two_bed] if params.has_key? :two_bed
    self.three_bed = params[:three_bed] if params.has_key? :three_bed
    self.four_or_more_bed = params[:four_or_more_bed] if params.has_key? :four_or_more_bed
    self.cheap = params[:cheap] if params.has_key? :cheap
    self.close = params[:close] if params.has_key? :close
  end
end
