module LpSolutionHelper
  def self.read_solution_for(problem, rooms, subjects)
    line_containing_optimum = 6
    line_where_solution_starts = 15 + subjects
    line_where_solution_ends = 15 + subjects + rooms.size

    File.open("smartfilter/#{problem}_solution.txt", 'r') do |f|
      l_idx = 1
      f.each_line do |line|
        if l_idx == line_containing_optimum
          return nil unless self.is_feasible?(line)
        end

        if (l_idx >= line_where_solution_starts) && (l_idx < line_where_solution_ends)
          unless self.is_part_of_solution?(line)
            key_to_delete = self.extract_key_from(line)
            rooms.delete(key_to_delete)
          end
        end

        l_idx += 1
      end
    end

    return compact_solution_array(rooms)
  end

  def read_solution_for(problem, rooms, subjects)
    return self.read_solution_for(problem, rooms, subjects)
  end


  def self.is_feasible?(line)
    optimum = /.+=\s(?<optimum>\d+).+/.match(line)[:optimum]
    return optimum.to_i > 0
  end

  def self.is_part_of_solution?(line)
    activity = /\s+\d+\s+\w\d{3}\s+\*\s+(?<activity>\d).+/.match(line)[:activity]
    return activity.to_i == 1
  end

  def self.extract_key_from(line)
    key = /\s+\d+\s+(?<key>\w\d{3}).+/.match(line)[:key]
    return key
  end

  def self.compact_solution_array(solution)
    rooms = Array.new

    skip = 0
    solution.each_pair do |key, room|
      if skip == 0
        rooms.push(room)
        skip = room.capacity
      else
        skip -= 1
      end
    end

    return rooms
  end
end