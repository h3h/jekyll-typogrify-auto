# frozen_string_literal: true

RSpec.describe(Jekyll::Typogrify::Auto) do
  Jekyll.logger.log_level = :error

  let(:config_overrides) { {} }
  let(:configs) do
    Jekyll.configuration(
      config_overrides.merge({
        skip_config_files: false,
        collections:       {docs: {output: true}.stringify_keys}.stringify_keys,
        source:            fixtures_dir,
        destination:       fixtures_dir('_site'),
      }).stringify_keys
    )
  end
end
