class Mkmov < Executor
  attr_reader :message

  def initialize face_bin, out_dir
    @face_bin = face_bin
    @out_dir = out_dir
    @message = ""
  end


  def execute
    @cmd = "#{Config.mpsynth.bin}/mkmov -f #{@face_bin} -o #{@out_dir} -n 2 -C #{Config.mkmov.capture_file} -P"
    super
  end

end
