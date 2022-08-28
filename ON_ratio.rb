require 'csv'

def check_args
  file = ARGV[0]

  unless File.exist?(file)
    puts "[ERROR] Can't read file. File path = #{file}"
    exit 1
  end
end

check_args
sample_file = ARGV[0]
control_file = ARGV[1]

csvf = CSV.open(ARGV[0],col_sep: "\t")
header = csvf.readline    # 1行目を読み込みヘッダー情報として保存

file1 = File.new('ON_ratio.tsv', 'w')

header.each_with_index do |header_2, i|
  num=header.count
  if i == 0
    file1 << header_2
    file1 << "\t"
    next
  elsif i == num - 1
    file1 << header_2
  else
    file1 << header_2
    file1 << "\t"
  end
end
file1 << "\n"

arr = []
count = 0
CSV.foreach(sample_file, col_sep: "\t", headers: false) do |row_sample|
  if count == 0
    count += 1
    next 
  end
  file1 << row_sample[0]
  file1 << "\t"
  CSV.foreach(control_file, col_sep: "\t", headers: false) do |row_control|
    if row_sample[0] == row_control[0]
      row_sample.delete_at(0)
      arr = row_sample.map { |srr| srr.to_f/row_control[1].to_f }
      count2 = arr.count
      arr.each_with_index do |num, i|
        file1 << num
        file1 << "\t" unless count2 == i + 1
      end
      file1 << "\n"
      break
    end
  end
end
