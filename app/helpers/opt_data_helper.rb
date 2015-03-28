module OptDataHelper
  def self.find_cheap_solution(rooms, guests)
    problem = generate_problem_name

    File.open("smartfilter/tasks/#{problem}.dat", 'w') do |data|
      write_rooms_set(rooms, data)
      write_base_params(rooms, guests, data)
      write_capacity_and_price_params(rooms, data)
    end

    run_solver_on(problem, PROPERTIES['smartfilter-models']['cheap'], rooms)
  end

  def find_cheap_solution(rooms, guests)
    self.find_cheap_solution(rooms, guests) #return
  end


  def self.find_close_solution(rooms, distances, guests)
    problem = generate_problem_name

    File.open("smartfilter/tasks/#{problem}.dat", 'w') do |data|
      write_rooms_set(rooms, data)
      write_base_params(rooms, guests, data)
      write_capacity_params(rooms, data)
      write_distance_params(rooms, distances, data)
    end

    run_solver_on(problem, PROPERTIES['smartfilter-models']['close'], rooms)
  end

  def find_close_solution(rooms, distances, guests)
    self.find_close_solution(rooms, distances, guests) #return
  end


  def self.find_cheap_and_close_solution(rooms, distances, guests)
    problem = generate_problem_name

    File.open("smartfilter/tasks/#{problem}.dat", 'w') do |data|
      write_rooms_set(rooms, data)
      write_base_params(rooms, guests, data)
      write_extra_params(rooms, distances, data)
      write_capacity_and_price_params(rooms, data)
      write_distance_params(rooms, distances, data)
    end

    run_solver_on(problem, PROPERTIES['smartfilter-models']['cheap_and_close'], rooms)
  end

  def find_cheap_and_close_solution(rooms, distances, guests)
     self.find_cheap_and_close_solution(rooms, distances, guests) #return
  end


  def self.run_solver_on(problem, model, rooms)
    write_solver_script(problem, model)

    command = "ampl smartfilter/tasks/#{problem}.solve > smartfilter/tasks/#{problem}.solution"
    has_run = system(command)

    if has_run
      until system("ls smartfilter/tasks/#{problem}.solution") do
        sleep(0.05)
      end

      lines = `cat smartfilter/tasks/#{problem}.solution | wc -l`
      if lines.to_i <= rooms.size+3
        puts 'NOT FEASIBLE'
        return Array.new
      else
        system("cat smartfilter/tasks/#{problem}.solution | tail -n#{rooms.size+4} | head -n#{rooms.size+2} > smartfilter/tasks/#{problem}.raw_solution")
        OptSolutionHelper.read_solution_for(problem, rooms)
      end
    end
  end


  def self.generate_problem_name
    return "#{DateTime.now}_VSF#{rand(100)}#{rand(100)}"
  end


  def self.write_solver_script(problem, model)
    File.open("smartfilter/tasks/#{problem}.solve", 'w') do |s|
      s.write("option solver bonmin;\n")
      s.write(Property.find_by_key(model).value.to_s)
      s.write("\ndata smartfilter/tasks/#{problem}.dat;\n")
      s.write("solve;\n")
      s.write('display Occupation;')
    end
  end


  def self.write_rooms_set(rooms, data)
    data.write('set ROOMS:= ')
    rooms.each_key do |room_key|
      data.write("#{room_key} ")
    end
    data.write(";\n")
  end


  def self.write_base_params(rooms, guests, data)
    min_capacity = Float::INFINITY
    rooms.each_value do |room|
      min_capacity = room.capacity if room.capacity < min_capacity
    end
    data.write("param min_capacity := #{min_capacity};\n")
    data.write("param guests := #{guests};\n")
  end


  def self.write_extra_params(rooms, distances, data)
    min_dist = Float::INFINITY
    min_price = Float::INFINITY

    i = 0
    rooms.each_value do |room|
      min_price = room.price.value_with_vat if room.price.value_with_vat < min_price

      j = 0
      rooms.each_value do |moor|
        min_dist = distances[i][j] if distances[i][j] < min_dist && distances[i][j] > 0.0
        j += 1
      end
      i += 1
    end

    data.write("param min_dist:= #{min_dist};\n")
    data.write("param min_price:= #{min_price};\n")
  end


  def self.write_capacity_params(rooms, data)
    data.write("param:\tcapacity :=\n")
    rooms.each_pair do |key, room|
      data.write("\t\t#{key}\t#{room.capacity}\n")
    end
    data.write(";\n")
  end


  def self.write_capacity_and_price_params(rooms, data)
    data.write("param:\tcapacity\tprice :=\n")
    rooms.each_pair do |key, room|
      data.write("\t\t#{key}\t#{room.capacity}\t#{room.price.value_with_vat}\n")
    end
    data.write(";\n")
  end


  def self.write_distance_params(rooms, distances, data)
    data.write("param\tdistance: ")
    rooms.each_key do |key|
      data.write("#{key} ")
    end
    data.write(":=\n")
    i = 0
    rooms.each_key do |key|
      data.write("\t\t#{key}\t")
      j = 0
      rooms.each_value do |moor|
        data.write("#{distances[i][j]}\t")
        j += 1
      end
      data.write("\n")
      i += 1
    end
    data.write(";\n")
  end
end