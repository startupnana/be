class MpsynthesizerAgingController < MpsynthesizerController
  before_action :setup_files, only: :aging

  def aging
    params[:mode] == '3d' ? aging_3d : aging_2d
  end

  def setup_files
    super
    return if params[:mode] == '2d'
    work_dir = "#{Rails.public_path}/#{@job_id}"
    FileUtils.mv @work_dir, work_dir
    @work_dir = work_dir
    @output_file = "#{@work_dir}/face.bin"
    @input_file = "#{@work_dir}/face.jpg"
  end


  protected


  def validate_params action
    if params[:mode] == '3d'
      param! :skindir, String, required: true, transform: lambda { |s| Shellwords.escape s }
    end
    super
  end


  private


  def check_3d_result
    return false unless File.file? @output_file
    return false unless File.file? "#{@work_dir}/old/hige_mesh.bin"
    return false unless File.file? "#{@work_dir}/old/hige.png"
    return false unless File.file? "#{@work_dir}/young/hige_mesh.bin"
    return false unless File.file? "#{@work_dir}/young/hige.png"
    true
  end


  def aging_3d
    @relative_dir = @work_dir.sub Rails.public_path.to_s, ''
    if run_mpsynth 'AGING'
      if check_3d_result
        render :json => {
                   :bin => "#{request.base_url}/#{@relative_dir}/face.bin",
                 :old => {
                   :bin => "#{request.base_url}/#{@relative_dir}/old/hige_mesh.bin",
                   :png => "#{request.base_url}/#{@relative_dir}/old/hige.png"
                 },
                 :young => {
                   :bin => "#{request.base_url}/#{@relative_dir}/young/hige_mesh.bin",
                   :png => "#{request.base_url}/#{@relative_dir}/young/hige.png"
                 }
               }
      else
        render_error
      end
    end
  end


  def aging_2d
    if run_mpsynth 'AGING'
      @mkmov = Mkmov.new @output_file, @work_dir
      @mkmov.execute
      result_file = "#{@work_dir}/00001.png"
      if File.file? result_file
        render body: IO.binread(result_file), content_type: "image/png"
      else
        render :json => {
                 :error => {
                   :message => @mkmov.message,
                   :code => ApplicationController::ErrorCode::UnknowError
                 }
               }, :status => :unprocessable_entity
      end
    end
    destroy_files
  end
end
