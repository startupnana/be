# -*- coding:utf-8 -*-

require 'json'

class Itemedit < Executor
    def execute_glasses_getallphafill(input_file, output_file)
      @cmd = "#{Config.mpsynth.bin}/getalphafill -i '#{input_file}' -o '#{output_file}' "
      @message = `#{@cmd}  2>&1`
      return false unless File.exist? output_file
      true
    end

    def execute_glasses_fp(input_glasses_file, input_fp_file, out_png, out_txt )
      @cmd = "#{Config.mpsynth.bin}/itemEditCui '#{input_glasses_file}' '#{input_fp_file}' '#{out_png}' '#{out_txt}'"
      @message = `#{@cmd}  2>&1`
      return false unless File.exist? out_png
      true
    end
end
