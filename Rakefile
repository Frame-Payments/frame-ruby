# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create

require "standard/rake"

task default: %i[test standard]

# Regenerate the SDK surface manifest consumed by the cross-SDK conformance
# audit (FRA-4516 producer / FRA-4457 consumer).
desc "Generate the surface manifest (surface-manifest.json)"
task :surface_manifest do
  sh File.expand_path("bin/generate-surface-manifest", __dir__)
end
