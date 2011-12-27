Gem::Specification.new do |s|
  s.name        = 'sublimate'
  s.version     = '0.1.2'
  s.date        = '2011-12-26'
  s.summary     = "Fog with large files"
  s.description = "Store ginormous files on S3 or the Rackspace Cloud using this gem."
  s.authors     = ["Kurt Mackey"]
  s.email       = 'mrkurt@gmail.com'
  s.files       = Dir.glob("lib/**/*") + %w(Readme.md)
  s.homepage    =
    'https://github.com/mrkurt/sublimate'

  s.add_dependency('fog', '>= 1.1.2')
end
