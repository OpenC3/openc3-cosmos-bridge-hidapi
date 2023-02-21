# encoding: ascii-8bit

# Create the overall gemspec
spec = Gem::Specification.new do |s|
  s.name = 'openc3-cosmos-bridge-hidapi'
  s.summary = 'OpenC3 openc3-cosmos-bridge-hidapi'
  s.description = <<-EOF
    openc3-cosmos-hidapi gem to support hidapi bridges
  EOF
  s.licenses = ['AGPL-3.0-only', 'Nonstandard']
  s.authors = ['Ryan Melton']
  s.email = ['ryan@openc3.com']
  s.homepage = 'https://github.com/OpenC3/openc3'
  s.platform = Gem::Platform::RUBY

  if ENV['VERSION']
    s.version = ENV['VERSION'].dup
  else
    time = Time.now.strftime("%Y%m%d%H%M%S")
    s.version = '0.0.0' + ".#{time}"
  end
  s.files = Dir.glob("{targets,lib,tools,microservices}/**/*") + %w(Rakefile README.md LICENSE.txt bridge.txt)

  s.add_dependency 'myhidapi'
end
