# frozen_string_literal: true

class TableSummary
  def initialize(visited_pages)
    @visited_pages = visited_pages
  end

  def print
    successful_visits, questionable_visits = visited_pages.partition { |_url, metadata| metadata.fetch(:status) == 200 }

    working_heading = 'Working pages:'
    working_content = Terminal::Table.new(
      headings: ['Url', 'HTTP status code', 'Number of internal pages it references'],
      rows: successful_visits.map { |url, metadata| [url, metadata.fetch(:status), metadata.fetch(:references)&.length] }
    )

    investigate_heading = 'Pages to investigate'
    investigate_content = Terminal::Table.new(
      headings: ['Url', 'HTTP status code', 'Pages that point to it'],
      rows: questionable_visits.map { |url, metadata| [url, metadata.fetch(:status), links_that_point_to(url).join("\n")] }
    )
    "#{working_heading}\n#{working_content}\n#{investigate_heading}\n#{investigate_content}"
  end

  private

  attr_reader :visited_pages

  def links_that_point_to(url)
    visited_pages.select { |_url, metadata2| metadata2[:references]&.include?(url) }.keys
  end
end
