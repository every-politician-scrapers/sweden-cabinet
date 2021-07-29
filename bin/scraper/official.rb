#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      name_and_position.first
    end

    field :position do
      name_and_position.last
    end

    private

    def name_and_position
      # Remove &shy hyphens
      # Ideally 'tidy' would get rid of these in whatever the best way
      # is, but for now just gsub them away.
      noko.text.gsub(/\u00AD/, '').tidy.split(', ', 2)
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.map { |member| fragment(member => Member).to_h }
    end

    private

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
