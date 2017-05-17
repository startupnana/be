class MpanalyzerController < ApplicationController
  before_action :setup_files
  after_action :destroy_files

  def analyze
    begin
      analyzer = Analyzer.new @input_file, @output_file
      if analyzer.execute
        render :json => analyzer.response
      else
        code = analyzer.message.include?('failed to recoginze face') ?
                 ApplicationController::ErrorCode::FaceRecognitionFailed :
                 ApplicationController::ErrorCode::UnknowError
        render :json => {:error => {
                           :message => analyzer.message,
                           :code => code
                         }
                        }, :status => :unprocessable_entity

      end
    rescue
      destroy_files
      raise
    end
  end

  private

end
