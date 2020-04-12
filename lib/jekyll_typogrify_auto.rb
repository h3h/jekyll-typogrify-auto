# frozen_string_literal: true

require 'jekyll'
require 'html/pipeline'
require 'html/pipeline/typogruby_filter'

module Jekyll
  module Typogrify
    #
    # Jekyll plugin to automatically typogrify post & page content.
    #
    class Auto
      class << self
        BODY_START_TAG = '<body'
        private_constant :BODY_START_TAG

        CONFIG_KEY = 'jekyll-typogrify-auto'
        private_constant :CONFIG_KEY

        CONFIG_TYPOGRUBY_KEY = 'typogruby'
        private_constant :CONFIG_TYPOGRUBY_KEY

        #
        # Main plugin method to typogrify post & page content.
        #
        # @param [Jekyll::Page|Jekyll::Post] doc Page or Post to be modified
        #
        # @return [Jekyll::Page|Jekyll::Post] Page or Post with modified content
        #
        def typogrify(doc)
          content = doc.output
          config = config_for_doc(doc)

          if content.include? BODY_START_TAG
            html_content = select_content(content, config)

            processed_markup = filter_pipeline(
              config.fetch(CONFIG_KEY, {}).fetch(CONFIG_TYPOGRUBY_KEY, {})
            ).call(html_content)[:output].to_s

            doc.output = processed_markup
          else
            doc.output = content
          end
        end

        #
        # Generates an HTML::Pipeline with a TypogrubyFilter configured.
        #
        # @param [Jekyll::Configuration] config Typogruby-specific config values
        #
        # @return [HTML::Pipeline] Configured Pipeline to process content
        #
        def filter_pipeline(config)
          @filter_pipeline ||= HTML::Pipeline.new(
            [HTML::Pipeline::TypogrubyFilter],
            config
          )
        end

        #
        # <Description>
        #
        # @param [<Type>] html <description>
        # @param [Jekyll::Configuration] config Config for this plugin
        #
        # @return [<Type>] <description>
        #
        def select_content(_html, _config)
          ''
        end

        #
        # Assemble useful configuration values for the given document
        #
        # @param [Jekyll::Page|Jekyll::Post] doc The doc for which config is needed
        #
        # @return [Jekyll::Configuration] Config values for the doc
        #
        def config_for_doc(doc)
          config_defaults.merge(
            doc.site.config.merge(
              doc.data.fetch(CONFIG_KEY, {})
            )
          )
        end

        #
        # Returns a set of default configuration values for the plugin
        #
        # @return [Jekyll::Configuration]
        #
        def config_defaults
          Jekyll::Configuration.new({
            tag_selector: 'article'
          })
        end
      end
    end
  end
end
