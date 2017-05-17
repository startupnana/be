class MpsynthesizerMoviemakerController < MpsynthesizerController
  include LongTasks
  before_action :prepare_new_job, if: "request.post?"

  VideoFormats = ['mp4', 'flv', 'mov']

  def validate_params action
    param! :vclip, String, required: true, transform: lambda { |s| Shellwords.escape s }
    param! :ofps, Integer, default: 24
    param! :vbitrate, Integer, default: 96000
    param! :abitrate, Integer, default: 122200
    param! :qscale, Integer, default: 5
    param! :saturation, Integer, default: 50
    param! :plycnt, Integer
    param! :streaming, Integer
    param! :ovrimgzip, Integer
    param! :vformat, String, default: 'flv', in: VideoFormats
    param! :ffmpeg_opt, String, transform: lambda { |s| Shellwords.escape s }
    params[:img0].present? or raise InvalidParameterError.new "Should include >= 1 image"
    super
  end


  def shoot
    validate_params ''
    for i in 0..3
      filename = "img#{i}"
      File.open("#{workdir}/#{filename}.jpg", 'wb') { |file| file.write(params[filename.to_sym].read) } unless params[filename.to_sym].blank?
    end
    Delayed::Job.enqueue ShootJob.new(out_file, workdir, params.except(:img0, :img1, :img2, :img3))
    render json: {:uid => @uid}
  end


  def new_uid
    "MOV_#{super}"
  end


  def out_file
    return "#{workdir}/out.#{params[:vformat]}" unless params[:vformat].blank?
    VideoFormats.each do |format|
      path = "#{workdir}/out.#{format}"
      return path if File.exists?("#{workdir}/out.#{format}")
    end
    "" #404
  end


  ShootJob = Struct.new(:out_file, :workdir, :params) do
    def perform
      i = 0
      @images_dir = "lib/assets/movie/#{params[:vclip]}/video"
      Dir.glob("#{workdir}/*.jpg").each do |img|
        content_dir = "lib/assets/movie/#{params[:vclip]}/content#{i}"
        params[:mkovrmodel] = "#{content_dir}/face.mko"
        bin_file = "#{workdir}/face#{i}.bin"
        @executor = synthesizer = Synthesizer.new 'MKOVRSYNTH', img, bin_file, workdir
        synthesizer.params = params
        synthesizer.execute or raise
        raise if synthesizer.message.include?('detection error') || !File.exist?(bin_file)
        output_dir = "#{workdir}/video#{i}"
        @executor = mpmovie = Mpmovie.new bin_file, content_dir, @images_dir, output_dir
        mpmovie.execute or raise

        @images_dir = output_dir
        i += 1
      end
      @executor = ffmpeg = Ffmpeg.new @images_dir, out_file, params
      ffmpeg.execute or raise
    rescue
      code = @executor.message.include?('detection error') ?
               ApplicationController::ErrorCode::FaceRecognitionFailed :
               ApplicationController::ErrorCode::UnknowError
      json = {
        :error => {
          :message => @executor.message,
          :cmd => @executor.cmd,
          :code => code
        }
      }.to_json
      File.open("#{workdir}/error.json","w") do |f|
        f.write(json)
        puts json
      end
    end
  end
end
