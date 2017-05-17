# -*- coding:utf-8 -*-

class Synthesizer < Executor
  attr_writer :params

  def initialize(action, face_img, output_file, work_dir = nil)
    @action = action
    @face_img = face_img
    @face_bin = output_file
    @work_dir = work_dir
    @message = ''
  end


  def feature_points_file
    "#{@work_dir}/feature_points.txt"
  end


  def face_img_size
    @size ||= FastImage.size @face_img
  end


  def execute
    if @action == 'SYNTH' and @params.key? :feature_points
      size = FastImage.size @face_img
      parser = FeaturePointsParser.new(JSON.parse(@params[:feature_points]), face_img_size.first, face_img_size.second)
      IO.write feature_points_file, parser.to_s
    end

    @cmd = "#{Config.mpsynth.bin}/mpsynth -i #{@face_img} -o #{@face_bin} -R #{Config.mpsynth.resources}"
    if @action.nil? #feature points mode
      @cmd += " -O #{feature_points_file}"
    else
      @cmd += " -a #{@action}"
      @cmd += " -t #{@params[:texsize]}"
      @cmd += " -m #{@params[:modelsize]}"
      @cmd += " -x #{@params[:expand]}"
      @cmd += " -b #{@params[:blur]}"
      @cmd += " -s #{@params[:facesize]}+#{@params[:facepos]}"
      @cmd += " -c #{@params[:cropmargin]} "
      @cmd += " -D" if @params[:autodetect] == 0
      @cmd += " -f #{@params[:format]}"
      @cmd += " -m #{@params[:modelsize]}"
      @cmd += " -e #{@params[:eyekeep]}"
      @cmd += " -x #{@params[:expand]}"
      @cmd += " -B #{@params[:backphoto]}"
      @cmd += " -C " if @action == 'SYNTH' and @params[:contour_equal_face]
      @cmd += " -n #{@params[:mkovrmodel]}" if @action.include? 'MKOVR'
      @cmd += " -n #{@params[:skindir]}" if @action == 'AGING'
      @cmd += " -S #{@work_dir}" if @action == 'AGING'
      @cmd += " -p #{feature_points_file}" if @action == 'SYNTH' and @params.key? :feature_points
    end
    super
  end


  def feature_points
    parser = FeaturePointsParser.new IO.read(feature_points_file), face_img_size.first, face_img_size.second
    parser.to_h
  end


  class FeaturePointsParser
    FeaturePointsKeys = ["face", "right_eye_inside", "left_eye_inside", "mouth", "right_eye_outside", "left_eye_outside", "body"]

    #convert to mpsynth letterboxed coordinates
    #XXX left right top bottom


    def initialize data, width, height
      @normalizer = MpsynthCoordinates.new width, height
      if data.kind_of? String
        line_pos = 0
        lines = data.lines
        @data = {}
        FeaturePointsKeys.each do |key|
          n = lines[line_pos].to_i
          line_pos += 1
          result = []
          n.times do
            coordinates = lines[line_pos].split
            result << { "x" => @normalizer.normalize_x(coordinates.first.to_f), "y" => @normalizer.normalize_y(coordinates.second.to_f) }
            line_pos += 1
          end
          @data[key] = result
        end
      else
        @data = data
      end
    end


    #Used to serialize to mpsynth format.
    def to_s
      str = ""
      FeaturePointsKeys.each do |key|
        str += "#{@data[key].count}\n"
        @data[key].each do |coordinate|
          str += "#{'%.6f' % @normalizer.denormalize_x(coordinate["x"])} #{'%.6f' % @normalizer.denormalize_y(coordinate["y"])}\n"
        end
      end
      str
    end


    #Used for JSON serialization
    def to_h
      @data
    end
  end
end
