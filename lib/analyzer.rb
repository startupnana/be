# -*- coding:utf-8 -*-

require 'json'

class Analyzer < Executor
    attr_reader :response

    def initialize(face_file, result_file)
        @face_file = face_file
        @result_file = result_file
        @response = {}
    end


    def execute
      @cmd = "#{Config.mpsynth.bin}/mpanalyzer '#{@face_file}' '#{@result_file}' -r #{Config.mpsynth.resources}"

      @message = `#{@cmd}  2>&1`
      return false unless File.exist? @result_file

      File.open(@result_file) do |f|
        ## each attribute
        attribute = Hash.new
        attribute["feature_points"] = Hash.new
        while (s = f.gets) != nil
          attr = s.split(" ")
          if attr[0].start_with? 'FP_'
            attribute["feature_points"][attr[0]] = {"x" => attr[2].to_i, "y" => attr[3].to_i}
          else
            attribute[attr[0]] = attr[2].to_f
          end
        end
        @response = attribute
        true
      end
    end
end
