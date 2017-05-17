
class FaceFp < Executor

  def initialize bin_file
    @bin_file = bin_file
  end

  def execute
    @cmd = "#{Config.facefp.bin}/facefp -i #{@bin_file} -R #{Config.facefp.resources}"
    super
  end
end
