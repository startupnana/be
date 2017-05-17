module LongTasks
  def job_result
    @uid = params[:uid]
    if @uid.length <= 42
      render :nothing => true, :status => :not_found
    elsif processing?
      render :nothing => true, :status => :accepted #202
    elsif File.exists?(out_file)
      send_file out_file
    elsif File.exists?(error_file)
      send_file error_file, :status => :unprocessable_entity
    else
      render :nothing => true, :status => :not_found
    end
  end

  protected


  def processing?
    Delayed::Job.exists?(["handler LIKE ?",  "%#{@uid}%"])
  end


  def error_file
    "#{workdir}/error.json"
  end


  def workdir
    "/tmp/delayed_work_dir/#{@uid}"
  end


  def prepare_new_job
    @uid = new_uid
    `mkdir -p '#{workdir}'`
  end


  def out_file
    "#{workdir}/out.txt"
  end

  def new_uid
    (0...42).map { (65 + rand(26)).chr }.join
  end
end
