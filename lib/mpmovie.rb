class Mpmovie < Executor
  def initialize bin, content_dir, images_dir, output_dir
    @bin = bin
    @content_dir = content_dir
    @images_dir = images_dir
    @output_dir = output_dir
    FileUtils.mkdir @output_dir
  end


  def execute
    @cmd = "#{Config.mpsynth.bin}/mpmovie "
    @cmd += " -i #{@bin} "
    @cmd += " -o #{@output_dir} "
    @cmd += " -a #{@content_dir}/anim.ani2  "
    @cmd += " -f #{@content_dir}/faceanim.txt "
    @cmd += " -v #{@images_dir} "
    super
  end
end
