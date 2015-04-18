module UrlHelper
  def self.build_parameterised_url(params)
    base = params[:filter][:base_url]

    if base.nil?
      return nil
    else
      params = remove_empty_params(params)
      write_params(base, params)
    end
  end

  def build_parameterised_url(base, params)
    return self.build_parameterised_url(base, params)
  end

  def self.remove_empty_params(params)
      params[:filter][:equipment_ids].delete_at(params[:filter][:equipment_ids].length-1) unless params[:filter][:equipment_ids].nil?
      params[:filter][:serviice_ids].delete_at(params[:filter][:serviice_ids].length-1) unless params[:filter][:serviice_ids].nil?

      params[:filter].delete(:city) if params[:filter][:city].empty?
      params[:filter].delete(:start_date) if params[:filter][:start_date].empty?
      params[:filter].delete(:end_date) if params[:filter][:end_date].empty?
      params[:filter].delete(:equipment_ids) if params[:filter][:equipment_ids].empty?
      params[:filter].delete(:serviice_ids) if params[:filter][:serviice_ids].empty?

      if params[:filter][:filter] == 'fine'
        params[:filter].delete(:capacity) if params[:filter][:capacity].empty?

      elsif params[:filter][:filter] == 'smart'
        params[:filter][:close] = params[:close] if params.has_key?('close')
        params[:filter][:cheap] = params[:cheap] if params.has_key?('cheap')

        params[:filter][:one_bed] = params[:one_bed] if params.has_key?('one_bed')
        params[:filter][:two_bed] = params[:two_bed] if params.has_key?('two_bed')
        params[:filter][:three_bed] = params[:three_bed] if params.has_key?('three_bed')
        params[:filter][:four_or_more_bed] = params[:four_or_more_bed] if params.has_key?('four_or_more_bed')

        params[:filter].delete(:guests) if params[:filter][:guests].empty?
      end

    return params
  end

  def self.write_params(base, params)
    url = base + '?'

    params.keys.each_with_index do |key, idx|
      url += "#{key}="
      if params[key].is_a? Array
        params[key].each_with_index do |v,i|
          url += "#{v}"

          unless i+1 == params[key].length
            url += ','
          end
        end
      else
        url += "#{params[key]}"
      end

      url += '&' if idx + 1 < params.keys.length
    end

    return url
  end
end
