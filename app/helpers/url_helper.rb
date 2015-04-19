module UrlHelper
  def self.build_parameterised_url(params)
    puts params

    base = params[:base_url]
    params.delete(:base_url)

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
      params[:equipment_ids].delete_at(params[:equipment_ids].length-1) unless params[:equipment_ids].nil?
      params[:serviice_ids].delete_at(params[:serviice_ids].length-1) unless params[:serviice_ids].nil?

      params.delete(:city) if params[:city].empty?
      params.delete(:start_date) if params[:start_date].empty?
      params.delete(:end_date) if params[:end_date].empty?
      params.delete(:equipment_ids) if params[:equipment_ids].empty?
      params.delete(:serviice_ids) if params[:serviice_ids].empty?

      if params[:filter] == 'fine'
        params.delete(:capacity) if params[:capacity].empty?

      elsif params[:filter] == 'smart'
        params[:close] = params[:close] if params.has_key?('close')
        params[:cheap] = params[:cheap] if params.has_key?('cheap')

        params[:one_bed] = params[:one_bed] if params.has_key?('one_bed')
        params[:two_bed] = params[:two_bed] if params.has_key?('two_bed')
        params[:three_bed] = params[:three_bed] if params.has_key?('three_bed')
        params[:four_or_more_bed] = params[:four_or_more_bed] if params.has_key?('four_or_more_bed')

        params.delete(:guests) if params[:guests].empty?
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
