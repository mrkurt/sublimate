guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/sublimate/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end

