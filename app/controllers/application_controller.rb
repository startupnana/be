class ApplicationController < ActionController::Base
  module ErrorCode
    InvalidParameter = 1
    UnknowError = 2
    FaceRecognitionFailed = 3
    FileNotFound = 4
  end

  protect_from_forgery with: :null_session
  before_filter :global_authenticate!

  def global_authenticate!
      if !authenicate_with_db!
          authenticate!
      end
  end

  def authenticate!
    authenticate_or_request_with_http_basic do |user, password|
      HTTPAuthUsers.detect do |u|
        user == u['user'] && password == u['password']
      end
    end
  end

  def authenicate_with_db!
      authenticate_or_request_with_http_basic do |user, password|
          return User.where(:username => user, :password => password).exists?
      end
  end

  #   name: Config.auth.user, password: Config.auth.password
  rescue_from RailsParam::Param::InvalidParameterError, with: :invalid_parameter


  def ping
    render :text => 'pong'
  end
  protected


  def setup_files
    now = Time.now
    @job_id   = "TMP_#{now.strftime("%Y%m%d%H%M%S")}_#{now.usec}_#{Random.rand 1000}"
    @work_dir = "#{Config.mpsynth.tmp_dir}/#{@job_id}"
    @output_file = "#{@work_dir}/output.bin"
    `mkdir -pv #{@work_dir}`
    @input_file = "#{@work_dir}/face.jpg"
    if params[:file].blank?
      File.open(@input_file, 'wb') { |file| file.write(request.raw_post) }
    else
      upload_path = params[:file].path
      `cp #{upload_path} #{@input_file}` #XXX Apparently analyser has trouble with files not ending in .jpg
    end
  end


  def destroy_files
    return if Config.temp_files.keep_files
    `rm -rvf #{@work_dir}` unless @work_dir.blank?
  end


  def invalid_parameter e
    destroy_files
    render :json => {:error => {
                       :message => "#{e.param} : #{e.message}",
                       :code => ErrorCode::InvalidParameter}
                    },
           status: :unprocessable_entity
  end
end
