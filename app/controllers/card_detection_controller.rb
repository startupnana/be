class CardDetectionController < ApplicationController
  before_action :setup_files

  module ErrorCode
    include ApplicationController::ErrorCode
    CardRecognitionFailed = 3
  end

  def setup_files
    super
    work_dir = "#{Rails.public_path}/#{@job_id}"
    FileUtils.mv @work_dir, work_dir
    @work_dir = work_dir
    @input_file = "#{@work_dir}/face.jpg"
  end


  def detect
    @relative_dir = @work_dir.sub Rails.public_path.to_s, ''
    if run_hough
      @relative_dir = @work_dir.sub Rails.public_path.to_s, ''
      render :json => {
               :pd => @hough.pd,
               :debug_picture => "#{request.base_url}/#{@relative_dir}/#{@hough.out_file}"
             }
      else
      render :json => {
               :error => {
                 :message => @hough.message,
                 :code => ErrorCode::CardRecognitionFailed
               }
             }, :status => :unprocessable_entity
      destroy_files
    end
  end

  def run_hough
    @hough = Hough.new @work_dir, @input_file
    @hough.execute
    File.size?("#{@work_dir}/#{@hough.out_file}")
  end
end
