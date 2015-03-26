module OptModelHelper
  def self.find_cheap_solution(rooms, guests)
    problem = generate_model_name
    subjects = 0

    File.open("smartfilter/#{problem}_model.lp", 'w') do |model|
      write_lp_variables(rooms, model)
      subjects = write_subjects(guests, rooms, model)
      write_cheap_object(rooms, model)
    end

    run_lp_solver_on(problem, rooms, subjects)
  end

  def find_cheap_solution(rooms, guests)
    self.find_cheap_solution(rooms, guests) #return
  end


  def self.find_close_solution(rooms, distances, guests)
    problem = generate_model_name
    subjects = 0

    File.open("smartfilter/#{problem}_model.lp", 'w') do |model|
      write_lp_variables(rooms, model)
      subjects = write_subjects(guests, rooms, model)
      write_close_object(distances, model)
    end

    run_lp_solver_on(problem, rooms, subjects)
  end

  def find_close_solution(rooms, distances, guests)
    self.find_close_solution(rooms, distances, guests) #return
  end


  def self.find_cheap_and_close_solution(rooms, distances, guests, lowest_price, nearest_distance)
    problem = generate_model_name

    File.open("smartfilter/#{problem}_model.nlp", 'w') do |model|
      write_which_solver('bonmin', model)
      write_params(lowest_price, nearest_distance, model)
      write_nlp_variables(rooms, model)
      write_subjects(guests, rooms, model)
      write_cheap_and_close_object(rooms, distances, model)
      write_display_output(rooms, model)
    end

    run_ampl_solver_on(problem, rooms)
  end

  def find_cheap_and_close_solution(rooms, distances, guests)
     self.find_cheap_and_close_solution(rooms, distances, guests) #return
  end


  def self.run_lp_solver_on(problem, rooms, subjects)
    has_run = system("glpsol -m smartfilter/#{problem}_model.lp -o smartfilter/#{problem}_solution.txt")
    if has_run
      until system("ls smartfilter/#{problem}_solution.txt") do
        sleep(0.05)
      end
      OptSolutionHelper.read_lp_solution_for(problem, rooms, subjects)
    end
  end


  def self.run_ampl_solver_on(problem, rooms)
    command = "ampl smartfilter/#{problem}_model.nlp > smartfilter/#{problem}_solution.txt"
    has_run = system(command)

    if has_run
      until system("ls smartfilter/#{problem}_solution.txt") do
        sleep(0.05)
      end

      lines = `cat smartfilter/#{problem}_solution.txt | wc -l`
      if lines.to_i <= rooms.size+1
        puts 'NOT FEASIBLE'
        return Array.new
      else
        system("cat smartfilter/#{problem}_solution.txt | tail -n#{rooms.size+2} | head -n#{rooms.size+1} > smartfilter/#{problem}_raw_solution.txt")
        OptSolutionHelper.read_ampl_solution_for(problem, rooms)
      end
    end
  end


  def self.generate_model_name
    return "#{DateTime.now}_VSF#{rand(100)}#{rand(100)}"
  end


  def self.write_which_solver(solver, model)
    model.write("option solver #{solver};\n")
  end


  def self.write_params(lowest_price, nearest_distance, model)
    model.write("param lpr = #{lowest_price};\n")
    model.write("param ldst = #{nearest_distance};\n")
  end


  def self.write_lp_variables(rooms, model)
    rooms.each_key do |key|
      model.write("var #{key}, binary;\n")
    end
  end


  def self.write_nlp_variables(rooms, model)
    rooms.each_key do |key|
      model.write("var #{key}, binary; let #{key} := 1;\n")
    end
  end


  def self.write_subjects(guests, rooms, model)
    self.write_subject_to_guests(guests, rooms, model)
    self.write_subject_to_rooms_capacity(rooms, model)
  end


  def self.write_subject_to_guests(guests, rooms, model)
    model.write('s.t. g: ')
    rooms.each_key do |key|
      model.write("#{key}+")
    end
    model.write("0=#{guests};\n")
  end


  def self.write_subject_to_rooms_capacity(rooms, model)
    capacity = 0
    subjects = 0
    prev_key = nil
    rooms.each_pair do |key, room|
      if capacity == 0 && room.capacity > 1
        capacity = room.capacity-1
        prev_key = key

      elsif room.capacity > 1
        model.write("s.t. s#{subjects}: #{prev_key}=#{key};\n")
        prev_key = key
        capacity -= 1
        subjects += 1
      end
    end
    return subjects
  end


  def self.write_cheap_object(rooms, model)
    model.write('minimize OPTIMUM: ')
    rooms.each_pair do |key, room|
      model.write("#{key}*#{room.price.value_with_vat}+")
    end
    model.write("0;\nend;")
  end


  def self.write_close_object(distances, model)
    model.write('minimize OPTIMUM: ')
    distances.each_pair do |start, sub_distances|
      sub_distances.each_pair do |destination, distance|
        model.write("((#{start}+#{destination})/2)*#{distance}+")
      end
      model.write("\n")
    end
    model.write("0;\nend;")
  end


  def self.write_cheap_and_close_object(rooms, distances, model)
    model.write('minimize OPTIMUM: ')

    # Per price object
    pr_ob_written = 0
    model.write("(sqrt((\n")
    rooms.each_pair do |key, room|
      model.write("#{key}*((#{room.price.value_with_vat} - lpr)^2) + \n")
      pr_ob_written += 1
    end
    model.write("0) / #{pr_ob_written})) / lpr + \n")

    # Per distance object
    dst_ob_written = 0
    model.write("(sqrt((\n")
    distances.each_pair do |start, sub_distances|
      sub_distances.each_pair do |destination, distance|
        model.write("(#{start}*#{destination})*((#{distance}-ldst)^2) + ")
        dst_ob_written += 1
      end
      model.write("\n")
    end
    model.write("0) / #{dst_ob_written})) / ldst;\n")
    model.write("solve;\n")
  end


  def self.write_display_output(rooms, model)
    model.write('display ')
    r_idx = 1
    rooms.each_key do |key|
      model.write("#{key}")
      if r_idx < rooms.size
        model.write(', ')
      end
      r_idx += 1
    end
    model.write(';')
  end

end