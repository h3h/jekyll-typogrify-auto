# frozen_string_literal: true

RSpec.describe(Jekyll::Typogrify::Auto) do
  Jekyll.logger.log_level = :error

  let(:config_overrides) { {} }
  let(:configs) do
    Jekyll.configuration(
      config_overrides.merge(
        # rubocop:disable Style/StringHashKeys
        'skip_config_files' => false,
        'collections'       => { 'docs' => { 'output' => true } },
        'source'            => fixtures_dir,
        'destination'       => fixtures_dir('_site')
        # rubocop:enable Style/StringHashKeys
      )
    )
  end
end
