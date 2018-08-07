# frozen_string_literal: true

class RelationshipGenerator
  def initialize(visited_pages)
    @visited_pages = visited_pages
  end

  def generate
    header = 'digraph G {'
    relationships = generate_pairs.map do |pointers|
      from, to = pointers
      "\"#{from}\" -> \"#{to}\""
    end.join("\n")
    footer = '}'
    "#{header}\n#{relationships}\n#{footer}"
  end

  private

  def generate_pairs
    references = Set.new
    visited_pages.each do |from, metadata|
      metadata.fetch(:references).to_a.each do |to|
        references << [from, to]
      end
    end
    references
  end

  attr_reader :visited_pages
end
