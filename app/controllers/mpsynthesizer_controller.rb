class MpsynthesizerController < ApplicationController
  before_action :setup_files, only: [:synthesize, :makeover, :makeover_synthesize, :feature_points]
  after_action :destroy_files, only: [:synthesize, :makeover, :makeover_synthesize, :feature_points]


  def makeover
    run_mpsynth 'MKOVR'
  end


  def synthesize
    run_mpsynth 'SYNTH'
  end


  def makeover_synthesize
    run_mpsynth 'MKOVRSYNTH'
  end

  def feature_points
    begin
      @synthesizer = Synthesizer.new nil, @input_file, '/dev/null', @work_dir
      @synthesizer.execute
      raise if @synthesizer.message.include?('detection error')
      render :json => @synthesizer.feature_points.to_json
    rescue
      destroy_files
      render_error
    end
  end

  protected

  def validate_params action
    param! :autodetect, Integer, default: 1
    param! :format, String, default: "BIN", in: ['SWF', 'BIN', 'PNG']  #REMOVE
    param! :texsize, Integer, in:[256, 512, 1024, 2048], default: 512
    param! :modelsize, Integer, in:[256, 512, 1024, 2048], default: 256
    param! :eyekeep, Integer, in: [1, 0], default: 1
    param! :expand, Integer, default: 16
    param! :blur, Integer, default: 64
    param! :facepos, Float, range: (-1.0)..(1.0), default: 0.5
    param! :facesize, Float, range: (-1.0)..(1.0), default: 0.5
    param! :cropmargin, Integer, in: [1, 0], default: 1
    param! :backphoto, Integer, in: [1, 0], default: 1
    param! :contour_equal_face, Integer, in: [1, 0], default: 0
    param! :face_fp, :boolean, default: false
    if action.include? 'MKOVR'
      param! :mkovrmodel, String, required: true, transform: lambda { |s| Shellwords.escape s }
    end
  end

  def render_error
    code = @synthesizer.message.include?('detection error') ?
             ApplicationController::ErrorCode::FaceRecognitionFailed :
             ApplicationController::ErrorCode::UnknowError
    Rails.logger.error @synthesizer.message
    render :json => {
               :error => {
               :message => @synthesizer.message,
               :code => code
               }
           }, :status => :unprocessable_entity
  end

  private

  def run_mpsynth action
    validate_params action
    begin
      @synthesizer = Synthesizer.new action, @input_file, @output_file, @work_dir
      @synthesizer.params = params
      @synthesizer.execute
      raise if @synthesizer.message.include?('detection error')
      if params[:face_fp]
        @face_fp = FaceFp.new @output_file
        @face_fp.execute or raise
      end
      render :text => Base64.encode64(File.new(@output_file).read) unless action == 'AGING'
    rescue
      destroy_files
      render_error
      return false
    end
    true
  end
end
