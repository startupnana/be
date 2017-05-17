class MpitemeditController < ApplicationController
    before_action :setup_files
    after_action :destroy_files
    
    def setup_files
      super
      @glasses_png_name = 'glass.png'
      @input_file = "#{@work_dir}/face.jpg"
      @rename_file = "#{@work_dir}/#{@glasses_png_name}"
      @output_file = "#{@work_dir}/glass_bg.png"
      FileUtils.mv  @input_file, @rename_file
      if params[:fpfile].present?
         upload_path = params[:fpfile].path
         @input_fp_file = "#{@work_dir}/fp.txt"
         @output_png_file = "#{@work_dir}/glasss.png"
         @output_fp_file = "#{@work_dir}/glass.txt"
        `cp #{upload_path} #{@input_fp_file}`
      end
    end

    def render_error(code, meassage)
      Rails.logger.error meassage
      render :json => {
                :error => {
                :message => meassage,
                :code => code
                }
            }, :status => :unprocessable_entity
    end

    def getglassesbg 
        begin
          if File.file? @rename_file
            @itemedit = Itemedit.new 
            @itemedit.execute_glasses_getallphafill @rename_file, @output_file
            if File.file? @output_file
              render body: Base64.encode64(File.new(@output_file).read), content_type: "image/png"
            else
              render_error @itemedit.message, ApplicationController::ErrorCode::UnknowError
            end
          else
            render_error 'glass.png Not Found', ApplicationController::ErrorCode::FileNotFound
          end
        rescue
          destroy_files
          raise
        end
    end
    
    def genglassesfp
        begin
            if (File.file? @rename_file) and (File.file? @input_fp_file)
                @itemedit = Itemedit.new 
                @itemedit.execute_glasses_fp @rename_file, @input_fp_file, @output_png_file, @output_fp_file
                if (File.file? @output_png_file) and (File.file? @output_fp_file)
                    render :json => {
                        :glass => Base64.encode64(File.new(@rename_file).read),
                        :glasss => Base64.encode64(File.new(@output_png_file).read),
                        :txt => Base64.encode64(File.new(@output_fp_file).read)
                    }
                else
                    render_error @itemedit.message, ApplicationController::ErrorCode::UnknowError
                end
            else
                render_error 'glass.png or fp.txt Not Found', ApplicationController::ErrorCode::FileNotFound
            end
        rescue
            destroy_files
            raise
        end
    end
    
end