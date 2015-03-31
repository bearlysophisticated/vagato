module OptSolutionHelper

  def self.read_solution_for(problem, rooms)
    File.open("smartfilter/tasks/#{problem}.raw_solution", 'r') do |f|
      l_idx = 1
      f.each_line do |line|
        if l_idx == 1
          return compact_solution(rooms) if feasibility(line) == 'Full'
          return Array.new unless feasibility(line) == 'Optimal'
        elsif l_idx > 2
          unless is_part_of_solution?(line)
            room_key = extract_room_key_from(line)
            rooms.delete(room_key)
          end
        end

        l_idx += 1
      end
    end

    return compact_solution(rooms)
  end

  def read_solution_for(problem, rooms)
    return self.read_solution_for(problem, rooms)
  end

  def self.feasibility(line)
    match = /\w+:\s(?<result>\w+)/.match(line)

    if match.nil?
      return 'Full'
    else
      return match[:result]
    end
  end

  def self.is_part_of_solution?(line)
    activity = /\w\d+_\d+\s+(?<activity>\d)/.match(line)[:activity]
    return activity.to_i == 1
  end

  def self.extract_room_key_from(line)
    key = /(?<key>\w\d+_\d+)\s+\d/.match(line)[:key]
    return key
  end

  def self.compact_solution(rooms)
    return rooms.values
  end
end