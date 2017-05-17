require "RestClient"

if ARGV.empty?
  puts "Usage: ruby test/jenkins/test_server.rb server_root"
  exit -1
end

puts "using #{ARGV[0]}"

User = 'mpapi'
Password = 'mp2014webapi'
Server = "http://#{User}:#{Password}@#{ARGV[0]}"
SuccessFilePath = 'test/fixtures/success.jpg'

BasicAuth = {:username => User, :password => Password}

#Sanity check
def test_ping
  begin
    return RestClient.get("#{Server}/synthesizer/ping") == 'pong'
  rescue
  end
  false
end

#Basic feature
def test_synth
  begin
    return RestClient.post("#{Server}/synthesizer/synthesize", File.open(SuccessFilePath, 'rb')).length > 424242
  rescue
  end
  false
end

#Check if X is working
def test_aging
  begin
    return  RestClient.post("#{Server}/synthesizer/aging/2d", File.open(SuccessFilePath, 'rb'), headers: {params: {skindir: 'lib/assets/mpsynth/aging/'}}).length > 4242
  rescue
  end
  false
end

ret = 0 #Success!

if test_ping
  puts "Ping test OK"
else
  ++ret
  puts "Ping test KO"
end

if test_synth
  puts "Synth test OK"
else
  puts "Synth test KO"
  ++ret
end

if test_aging
  puts "Aging test OK"
else
  puts "Aging test KO"
  ++ret
end

exit ret
