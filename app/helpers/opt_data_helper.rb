module OptDataHelper
  def self.find_cheap_solution(rooms, guests)
    problem = generate_problem_name

    File.open("smartfilter/tasks/#{problem}.dat", 'w') do |data|
      write_rooms_set(rooms, data)
      write_base_params(rooms, guests, data)
      write_capacity_and_price_params(rooms, data)
    end

    run_solver_on(problem, 'cheap.mod', rooms)
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

    run_solver_on(problem, 'close.mod', rooms)
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

    run_solver_on(problem, 'close_and_cheap.mod', rooms)
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
      if lines.to_i <= rooms.size+1
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
      s.write("model smartfilter/models/#{model}\n")
      s.write("data smartfilter/tasks/#{problem}.dat;\n")
      s.write("solve;\n")
      s.write('display Occupation;')
    end
  end


  def self.write_rooms_set(rooms, data)
    data.write('set ROOMS:= ')
    rooms.each do |room|
      data.write("R#{room.id} ")
    end
    data.write(";\n")
  end


  def self.write_base_params(rooms, guests, data)
    min_capacity = Float::INFINITY
    rooms.each do |room|
      min_capacity = room.capacity if room.capacity < min_capacity
    end
    data.write("param min_capacity := #{min_capacity};\n")
    data.write("param guests := #{guests};\n")
  end


  def self.write_extra_params(rooms, distances, data)
    min_dist = Float::INFINITY
    min_price = Float::INFINITY

    rooms.each_with_index do |room, i|
      min_price = room.price.value_with_vat if room.price.value_with_vat < min_price

      rooms.each_with_index do |moor, j|
        min_dist = distances[i][j] if distances[i][j] < min_dist && distances[i][j] > 0.0
      end
    end

    data.write("param min_dist:= #{min_dist};\n")
    data.write("param min_price:= #{min_price};\n")
  end


  def self.write_capacity_params(rooms, data)
    data.write("param:\tcapacity :=\n")
    rooms.each do |room|
      data.write("\t\tR#{room.id}\t#{room.capacity}\n")
    end
    data.write(";\n")
  end


  def self.write_capacity_and_price_params(rooms, data)
    data.write("param:\tcapacity\tprice :=\n")
    rooms.each do |room|
      data.write("\t\tR#{room.id}\t#{room.capacity}\t#{room.price.value_with_vat}\n")
    end
    data.write(";\n")
  end


  def self.write_distance_params(rooms, distances, data)
    data.write("param\tdistance: ")
    rooms.each do |room|
      data.write("R#{room.id} ")
    end
    data.write(":=\n")
    rooms.each_with_index do |room, i|
      data.write("\t\tR#{room.id}\t")
      rooms.each_with_index do |moor, j|
        data.write("#{distances[i][j]}\t")
      end
      data.write("\n")
    end
    data.write(";\n")
  end

end