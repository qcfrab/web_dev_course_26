require 'date'

if ARGV.length != 4
  puts "The arguments count is incorrect."
  puts "Example: ruby build_calendar.rb teams.txt 01.08.2026 01.06.2027 calendar.txt"
  exit
end

teams_file = ARGV[0]
calendar_file = ARGV[3]

unless File.exist?(teams_file)
  puts "File #{teams_file} not found"
  exit
end

begin
  start_date = Date.parse(ARGV[1])
  end_date = Date.parse(ARGV[2])
rescue
  puts "Incorrect date format."
  exit
end

if start_date > end_date
  puts "The start date cannot be later than the end date."
  exit
end

f = File.read(teams_file)
teams = {}
team_names = []

f.each_line do |line|
  clean_line = line.split(". ", 2)[1]
  parts = clean_line.split(" — ", 2)
  teams[parts[0]] = parts[1]
  team_names << parts[0]
end

combs = team_names.combination(2).to_a.shuffle!

game_days = []
(start_date..end_date).each do |day|
  if day.friday? || day.saturday? || day.sunday?
    game_days << day
  end
end

all_available_slots = []
times = %w[12:00 15:00 18:00]

game_days.each do |day|
  times.each do |time|
    all_available_slots << day.to_s + " " + time
    all_available_slots << day.to_s + " " + time
  end
end

if all_available_slots.size < combs.size
  puts "Not enough slots to host games."
  exit
end

step = all_available_slots.size / combs.size

current_slot = 0

File.open(calendar_file, "w") do |file|
  combs.each do |comb|
    file.puts all_available_slots[current_slot] + " : " + comb[0].to_s + " — " + comb[1].to_s
      current_slot += step
  end
end