require 'cutter/array'
require 'cutter/railtie' if defined?(Rails)

module Cutter
  autoload :Inspection, 'cutter/inspection'
  autoload :Stamper, 'cutter/stamper'
end
