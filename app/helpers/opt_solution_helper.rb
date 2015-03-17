module OptSolutionHelper

  def self.read_ampl_solution_for(problem, rooms)
    File.open("smartfilter/#{problem}_raw_solution.txt", 'r') do |f|
      l_idx = 1
      f.each_line do |line|
        if l_idx == 1
          return compact_solution_array(rooms) if nlp_feasibality(line) == 'Full'
          return nil unless nlp_feasibality(line) == 'Optimal'
        else
          unless nlp_is_part_of_solution?(line)
            key_to_delete = nlp_extract_key_from(line)
            rooms.delete(key_to_delete)
          end
        end

        l_idx += 1
      end
    end

    return compact_solution_array(rooms)
  end

  def read_ampl_solution_for(problem, rooms)
    return self.read_ampl_solution_for(problem, rooms)
  end

  def self.read_lp_solution_for(problem, rooms, subjects)
    line_containing_optimum = 6
    line_where_solution_starts = 15 + subjects
    line_where_solution_ends = 15 + subjects + rooms.size

    File.open("smartfilter/#{problem}_solution.txt", 'r') do |f|
      l_idx = 1
      f.each_line do |line|
        if l_idx == line_containing_optimum
          return nil unless self.lp_is_feasible?(line)
        end

        if (l_idx >= line_where_solution_starts) && (l_idx < line_where_solution_ends)
          unless self.lp_is_part_of_solution?(line)
            key_to_delete = self.lp_extract_key_from(line)
            rooms.delete(key_to_delete)
          end
        end

        l_idx += 1
      end
    end

    return compact_solution_array(rooms)
  end

  def read_lp_solution_for(problem, rooms, subjects)
    return self.read_lp_solution_for(problem, rooms, subjects)
  end


  def self.lp_is_feasible?(line)
    optimum = /.+=\s(?<optimum>\d+).+/.match(line)[:optimum]
    return optimum.to_i > 0
  end

  def self.lp_is_part_of_solution?(line)
    activity = /\s+\d+\s+\w\d{3}\s+\*\s+(?<activity>\d).+/.match(line)[:activity]
    return activity.to_i == 1
  end

  def self.lp_extract_key_from(line)
    key = /\s+\d+\s+(?<key>\w\d{3}).+/.match(line)[:key]
    return key
  end

  def self.nlp_feasibality(line)
    match = /\w+:\s(?<result>\w+)/.match(line)

    if match.nil?
      return 'Full'
    else
      return match[:result]
    end
  end

  def self.nlp_is_part_of_solution?(line)
    activity = /\w\d{3}\s=\s(?<activity>\d)/.match(line)[:activity]
    return activity.to_i == 1
  end

  def self.nlp_extract_key_from(line)
    key = /(?<key>\w\d{3})\s=\s\d/.match(line)[:key]
    return key
  end

  def self.compact_solution_array(solution)
    rooms = Array.new

    skip = 0
    solution.each_value do |room|
      if skip == 0
        rooms.push(room)
        skip = room.capacity - 1
      else
        skip -= 1
      end
    end

    return rooms
  end
end