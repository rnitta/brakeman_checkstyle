require 'brakeman'
require 'thor'
require 'rexml/document'
require "brakeman_checkstyle/version"

module BrakemanCheckstyle
  class CLI < Thor
    desc 'out', 'execute brakeman and output checkstyle-formatted xml'

    def out
      document = REXML::Document.new.tap do |d|
        d << REXML::XMLDecl.new
      end
      checkstyle = REXML::Element.new('checkstyle', document)

      brakeman_outputs = Brakeman.run(app_path: stdin_read, output_formats: [:to_s]).filtered_warnings

      offences = {}.tap do |warnings|
        brakeman_outputs.map(&:relative_path).uniq.each do |path|
          warnings[path] = []
        end
      end

      brakeman_outputs.each do |output|
        offences[output.relative_path] << to_attribute(output)
      end

      offences.each do |name, attributes|
        REXML::Element.new('file', checkstyle).tap do |f|
          f.attributes['name'] = name
          attributes.each do |attribute|
            REXML::Element.new('error', f).tap do |e|
              e.add_attributes(attribute)
            end
          end
        end
      end

      puts document
    end

    private

    def stdin_read
      $stdin.read
    end

    def to_attribute(offence)
      {
          'line' => offence.line,
          'severity' => to_checkstyle_severity(offence.confidence),
          'message' => offence.message,
          'source' => 'com.puppycrawl.tools.checkstyle.brakeman'
      }
    end

    def to_checkstyle_severity(confidence)
      case confidence
      when 3 then 'error'
      when 2 then 'warning'
      when 1 then 'info'
      else 'warning'
      end
    end

  end
end
