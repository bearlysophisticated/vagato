module LpModelHelper
  def self.find_cheap_solution(rooms, guests)
    problem = generate_model_name
    subjects = 0

    File.open("smartfilter/#{problem}_model.lp", 'w') do |model|
      write_variables(rooms, model)
      subjects = write_subjects(guests, rooms, model)
      write_cheap_object(rooms, model)
    end

    run_lp_solver_on(problem, rooms, subjects)
  end

  def find_cheap_solution(rooms, guests)
    return self.find_cheap_solution(rooms, guests)
  end


  def self.find_close_solution(rooms, distances, guests)
    problem = generate_model_name
    subjects = 0

    File.open("smartfilter/#{problem}_model.lp", 'w') do |model|
      write_variables(rooms, model)
      subjects = write_subjects(guests, rooms, model)
      write_close_object(distances, model)
    end

    run_lp_solver_on(problem, rooms, subjects)
  end

  def find_close_solution(rooms, distances, guests)
    return self.find_close_solution(rooms, distances, guests)
  end


  def self.find_cheap_and_close_solution(rooms, distances, guests)
    problem = generate_model_name
    subjects = 0

    File.open("smartfilter/#{problem}_model.lp", 'w') do |model|
      write_variables(rooms, model)
      subjects = write_subjects(guests, rooms, model)
      write_cheap_and_close_object(rooms, distances, model)
    end

    run_lp_solver_on(problem, rooms, subjects)
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


  def self.write_variables(rooms, model)
    rooms.each_key do |key|
      model.write("var #{key}, binary;\n")
    end
  end


  def self.write_subjects(guests, rooms, model)
    self.write_subject_to_guests(guests, rooms, model)
    self.write_subject_to_rooms_capacity(rooms, model)
  end


  def self.write_subject_to_guests(guests, rooms, model)
    model.write("s.t. g: ")
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
    model.write("minimize OPTIMUM: ")
    rooms.each_pair do |key, room|
      model.write("#{key}*#{room.price.value_with_vat}+")
    end
    model.write("0;\nend;")
  end


  def self.write_close_object(distances, model)
    model.write("minimize OPTIMUM: ")
    distances.each_pair do |start, sub_distances|
      sub_distances.each_pair do |destination, distance|
        model.write("((#{start}+#{destination})/2)*#{distance}+")
      end
      model.write("\n")
    end
    model.write("0;\nend;")
  end

  def self.write_cheap_and_close_object(rooms, distances, model)
    model.write("minimize OPTIMUM: ")

    # Per price object
    rooms.each_pair do |key, room|
      model.write("#{key}*#{room.price.value_with_vat/10000}+")
    end

    # Per distance object
    distances.each_pair do |start, sub_distances|
      sub_distances.each_pair do |destination, distance|
        model.write("((#{start}+#{destination})/2)*#{distance}+")
      end
      model.write("\n")
    end
    model.write("0;\nend;")
  end

end