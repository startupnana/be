class Ffmpeg < Executor
  def initialize images_dir, out_file, params
    @images_dir = images_dir
    @params = params
    @message = ""
    @out_file = out_file
  end


  def music_path
    "lib/assets/movie/#{@params[:vclip]}/music.mp3"
  end


  def execute
    @cmd = "ffmpeg -f image2 "
    @cmd += " -r #{@params[:ofps]} "
    @cmd += " -i #{@images_dir}/%05d.jpg "
    @cmd += " -i #{music_path} "
    @cmd += " -strict -2 "
    @cmd += " -b:v #{@params[:vbitrate]} -b:a #{@params[:abitrate]} "
    @cmd += " -ar 44100 " if @params[:vformat] == 'flv' || @params[:vformat] == 'mov'
    @cmd += " -vcodec mpeg4 -qscale #{@params[:qscale]} " if @params[:vformat] == 'mp4'
    @cmd += "  -c:v libx264 "
    @cmd += " #{@params[:ffmpeg_opt]} "
    @cmd += " #{@out_file} "
    super
  end
end
