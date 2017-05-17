class Hough < Executor

  def initialize work_dir, in_file
    @work_dir = work_dir
    @in_file = in_file
    @message = ''
  end

  def out_file
    'out.png'
  end

  def pd
    @message.gsub!(/[^\d\.]/, '').to_f #everything but a digit and a dot.
  end

  #XXX: change hough so that don't need to chroot.
  def execute
    pwd = `pwd`.strip
    @cmd = "cd '#{@work_dir}' && #{pwd}/#{Config.hough.bin}/hough #{@in_file} -r #{pwd}/#{Config.mpsynth.resources}"
    super
  end
end
