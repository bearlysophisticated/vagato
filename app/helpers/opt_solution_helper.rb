module OptSolutionHelper

  def self.read_solution_for(problem, rooms)
    File.open("smartfilter/tasks/#{problem}.raw_solution", 'r') do |f|
      l_idx = 1
      f.each_line do |line|
        if l_idx == 1
          return rooms if feasibility(line) == 'Full'
          return nil unless feasibility(line) == 'Optimal'
        elsif l_idx > 2
          unless is_part_of_solution?(line)
            room_id = extract_room_id_from(line)
            room_to_delete = Room.find(room_id)
            rooms.delete(room_to_delete)
          end
        end

        l_idx += 1
      end
    end

    return rooms
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
    activity = /\w\d+\s+(?<activity>\d)/.match(line)[:activity]
    return activity.to_i == 1
  end

  def self.extract_room_id_from(line)
    rid = /\w(?<rid>\d+)\s+\d/.match(line)[:rid]
    return rid.to_i
  end

end