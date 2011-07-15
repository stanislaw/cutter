#require 'cutter/railtie' if defined?(Rails)
#require 'cutter/inspection'
#require 'cutter/stamper'
require 'cutter/array'

module Cutter
  autoload :Railtie, 'cutter/railtie' if defined?(Rails)
  autoload :Inspection, 'cutter/inspection'
  autoload :Stamper, 'cutter/stamper'
end
