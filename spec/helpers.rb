# frozen_string_literal: true

module Helpers
  def json_sample_file(filename)
    current_dir = File.dirname(__FILE__)
    file_path = current_dir.gsub('spec', "spec/support/files/#{filename}_sample.json")
    File.read(file_path)
  end
end
