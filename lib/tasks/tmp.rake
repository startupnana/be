namespace :tmp do
  desc "Remove old files from public dir."
  task clean_old_files: :environment do
    life_time = eval Config.temp_files.max_life
    Dir.glob("public/TMP_*").each { |filename| FileUtils.rm_rf(filename) if Time.now.utc - File.ctime(filename) > life_time }
    Dir.glob("/tmp/delayed_work_dir/*").each { |filename| FileUtils.rm_rf(filename) if Time.now.utc - File.ctime(filename) > life_time }
    Dir.glob("#{Config.mpsynth.tmp_dir}/*").each { |filename| FileUtils.rm_rf(filename) if Time.now.utc - File.ctime(filename) > life_time }
  end

end
