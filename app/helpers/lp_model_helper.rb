module LpModelHelper
  def self.find_cheap_solution(rooms, guests)
    problem = self.generate_model_name
    subjects = 0

    File.open("smartfilter/#{problem}_model.lp", 'w') do |f|
      rooms.each_key do |key|
        f.write("var #{key}, binary;\n")
      end

      f.write("s.t. g: ")
      rooms.each_key do |key|
        f.write("#{key}+")
      end
      f.write("0=#{guests};\n")


      capacity = 0
      prev_key = nil
      rooms.each_pair do |key, room|
        if capacity == 0 && room.capacity > 1
          capacity = room.capacity-1
          prev_key = key

        elsif room.capacity > 1
          f.write("s.t. s#{subjects}: #{prev_key}=#{key};\n")
          prev_key = key
          capacity -= 1
          subjects += 1
        end
      end


      f.write("minimize OPTIMUM: ")
      rooms.each_pair do |key, room|
        f.write("#{key}*#{room.price.value_with_vat}+")
      end
      f.write("0;\nend;")
    end

    self.run_lp_solver_on(problem, rooms, subjects)
  end

  def find_cheap_solution(rooms, guests)
    return self.find_cheap_solution(rooms, guests)
  end


  def self.find_close_solution(rooms, distances, guests)

  end

  def find_close_solution(rooms, distances, guests)
    return self.find_close_solution(rooms, distances, guests)
  end


  def self.find_cheap_and_close_solution(rooms, distances, guests)

  end

  def find_cheap_and_close_solution(rooms, distances, guests)
    return self.find_cheap_and_close_solution(rooms, distances, guests)
  end


  def self.run_lp_solver_on(problem, rooms, subjects)
    has_run = system("glpsol -m smartfilter/#{problem}_model.lp -o smartfilter/#{problem}_solution.txt")
    if has_run
      while !system("ls smartfilter/#{problem}_solution.txt") do
        sleep(0.05)
      end
      LpSolutionHelper.read_solution_for(problem, rooms, subjects)
    end
  end

  def self.generate_model_name
    return "VSF#{rand(100)}#{rand(100)}_#{DateTime.now}"
  end
end