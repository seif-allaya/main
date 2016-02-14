require 'roo'
require 'colorize'
require 'optparse'
require 'json'

def open_json(document)
  extension = document[(document.length-4)..(document.length)]
  if extension.upcase() =="JSON"
    puts "[OK] file extension verified, Importing : ".colorize(:green)<< document
    file = File.read(document)
    json_data = JSON.parse(file)
  else
    puts "[OH] Bad file extention. quitting :(".colorize(:red)
    abort()
  end
  return json_data
end

def convert(data, output_file)
  puts "[OK] Set of data detected :".colorize(:green) << "#{data.length} "
  CSV.open(output_file, "wb") do |csv|
    # Reading the headers
    csv << data[0].keys
    # remove the headersœ
    data.slice! 0
    # Add the data
    data.each { |line|
      csv << line.values
     }
   end
end

def main
  options = {}
  optparse = OptionParser.new do |opts|
    opts.banner = "Usage: ruby excel_to_json.rb [options]"
     opts.on('-i', '--input filename', 'Input a valid .xlsx file') { |file| options[:jsonfile] = file }
     opts.on('-o', '--output filename', 'Output directory') { |dir| options[:csvfile] = dir }
     opts.on('-v', '--verbose', 'Run verbosely') { |v| options[:verbose] = v }
   end
   begin
     optparse.parse!
     if options[:jsonfile].nil?
       raise OptionParser::MissingArgument
     end
   rescue OptionParser::ParseError => e
     puts "[OH] No file supplied, Noting to do!!".colorize(:red)
     puts optparse
     exit
   end
   # Read the JSON file
   data = open_json(options[:jsonfile])
   if options[:csvfile].nil?
      options[:csvfile] = options[:jsonfile][-4] << "csv"
     end
    convert(data,options[:csvfile])
end

main()
