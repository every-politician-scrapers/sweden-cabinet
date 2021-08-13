#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class String
  def ucfirst
    sub(/^(.)/) { |s| s.capitalize }
  end
end

class MemberList
  class Member
    def name
      name_and_position.first
    end

    def position
      name_and_position.last.gsub('- och ','minister|').gsub(' samt ', '|').split('|').map(&:ucfirst)
    end

    private

    def name_and_position
      # Remove &shy hyphens
      # Ideally 'tidy' would get rid of these in whatever the best way
      # is, but for now just gsub them away.
      noko.text.gsub(/\u00AD/, '').tidy.split(', ', 2)
    end
  end

  class Members
    def pane
      noko.css('#nav-1').xpath('ancestor::div').first
    end

    def member_container
      noko.css('li.navdesk__sublist-item a[href*="/sveriges-regering/"]')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
