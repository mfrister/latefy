# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.identifier = 'es.rockt.stefan.AweSong'
  app.name = 'fuck-yeah-awesome-track'
  app.icons << 'icon.png'
  app.vendor_project('vendor/deezer', :static,
    :products => ['libDeezer.a'],
    :headers_dir => 'Headers')
  app.interface_orientations = [:portrait]

  app.vendor_project('vendor/GracenoteMusicID.framework', :static,
    :products => ['GracenoteMusicID'],
    :headers_dir => 'Headers')

  app.frameworks += [
    'MediaPlayer',
    'AudioTool',
    'CoreDate',
    'CoreLocation',
    'AVFoundation',
    'MapKit',
    'CoreMedia'
  ]

  app.libs << '/usr/lib/libxml2.dylib'
end

desc 'compiles interfaces/*.xib to resources/*.nib'
task :compile_interfaces do
  Dir.glob(File.join('interfaces', '*.xib')).each do |path|
    basename = File.basename path, '.xib'
    out_path = "resources/#{basename}.nib"
    puts "compiling #{path} to #{out_path}"
    command = "ibtool --compile #{out_path} #{path}"
    system command
  end
end
