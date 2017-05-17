class Executor
  attr_reader :message, :cmd

  def execute
    @message = `#{@cmd} 2>&1`
    result = $?            # $? => "pid [PID] exit [status]"
    result = result.to_s.split(" ")
    result[3].to_i == 0
  end
end
