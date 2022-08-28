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

csvf = CSV.open(ARGV[0],col_sep: "\t")
header = csvf.readline    # 1行目を読み込みヘッダー情報として保存

file1 = File.new('output+1.tsv', 'w')

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

CSV.foreach(file, col_sep: "\t", headers: false) do |row|
  next if row[0] == nil
  num=row.count
  row.each_with_index do |hoge, i|
    if i == 0
      file1 << hoge
      file1 << "\t"
      next
    elsif i == num - 1
      file1 << hoge.to_f + 1
    else
      file1 << hoge.to_f + 1
      file1 << "\t"
    end
  end
  file1 << "\n"
end
