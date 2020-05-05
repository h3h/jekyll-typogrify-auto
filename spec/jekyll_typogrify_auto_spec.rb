# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Jekyll::Typogrify::Auto) do
  let(:config_overrides) { {} }
  let(:configs) do
    Jekyll.configuration(
      config_overrides.merge({
        skip_config_files: false,
        collections:       {'docs' => {'output' => true}},
        source:            fixtures_dir,
        destination:       fixtures_dir('_site'),
      })
    )
  end

  let(:site)         { Jekyll::Site.new(configs) }
  let(:result)       { %(<span class="emdash">—</span>) }
  let(:posts)        { site.posts.docs.sort.reverse }
  let(:basic_post)   { find_by_title(posts, "Article and not") }
  let(:complex_post) { find_by_title(posts, 'Code block and not') }
  let(:bare_post)    { find_by_title(posts, 'Not') }

  before(:each) do
    site.reset
    site.read
    (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
    site.render
  end

  context "without a tag_selector in its config" do
    it "correctly decorates em dashes in posts with the selected tag" do
      expect(basic_post.output.scan(/(?=#{result})/).count).to eq(2)
    end

    it "doesn't replace em dashes in a code block but does outside" do
      expect(complex_post.output).to match(/dash\p{P}dash/)
      expect(complex_post.output).to include(result)
    end

    it "replaces em dashes in posts without the selected tag" do
      expect(bare_post.output).to include(result)
    end
  end

  context "with a tag_selector in its config" do
    let(:config_overrides) { {'jekyll-typogrify-auto' => {'tag_selector' => "article"}} }

    it "correctly decorates em dashes in posts with the selected tag" do
      expect(basic_post.output.scan(/(?=#{result})/).count).to eq(1)
    end

    it "doesn't replace em dashes in a post without the selected tag" do
      expect(complex_post.output).to match(/dash\p{P}dash/)
      expect(complex_post.output).not_to include(result)
    end
  end
end
