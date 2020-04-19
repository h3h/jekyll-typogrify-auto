# frozen_string_literal: true

require 'spec_helper'

RSpec.describe(Jekyll::Typogrify::Auto) do
  Jekyll.logger.log_level = :error

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
  let(:result)       { %(<span class="em">—</span>") }
  let(:posts)        { site.posts.docs.sort.reverse }
  let(:basic_post)   { find_by_title(posts, "I'm a post") }
  let(:complex_post) { find_by_title(posts, 'Code Block') }

  before(:each) do
    site.reset
    site.read
    (site.pages | posts | site.docs_to_write).each { |p| p.content.strip! }
    site.render
  end

  it "correctly decorates em dashes in posts" do
    expect(basic_post.output).to include(result)
  end

  it "doesn't replace mentions in a code block but does outside" do
    expect(complex_post.output).to match(
      %r{<pre\b.*?dash — dash.*?</pre>}
    )
    expect(complex_post.output).to include(result)
  end
end
