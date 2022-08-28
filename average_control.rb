require 'csv'

def check_args
  file = ARGV[0]

  unless File.exist?(file)
    puts "[ERROR] Can't read file. File path = #{file}"
    exit 1
  end
end

check_args

file = ARGV[0]
srr_control_start = ARGV[1].to_i
srr_control_end = ARGV[2].to_i

file1 = File.new('average_control.tsv', 'w')
file1 << "\t"
file1 << "average_control"
file1 << "\n"

arr = []
count = 0
CSV.foreach(file, col_sep: "\t", headers: false) do |row|
  if count == 0
    count += 1
    next 
  end
  file1 << row[0]
  file1 << "\t"

  row.each_with_index do |sample, i|
    if i == srr_control_start
      arr << sample

      srr_control_start += 1
      if srr_control_start == srr_control_end + 1
        arr2 = arr.map(&:to_f)
        ave = arr2.sum.fdiv(arr.length)
        file1 << ave
        file1 << "\n"
        srr_control_start = ARGV[1].to_i
        break 
      end
    end
  end
  arr = []
end
