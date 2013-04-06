# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-hue"
  s.version     = "0.0.2"
  s.authors     = "interstateone"
  s.email       = "brandon@brandonevans.ca"
  s.homepage    = "http://www.brandonevans.ca"
  s.summary     = %q{Hue got me babe}
  s.description = %q{This lets you control Philips Hue lights with Siri}

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "json"
end
