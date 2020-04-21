# frozen_string_literal: true

require 'jekyll'
require 'html/pipeline'
require 'nokogiri/html'
require 'typogruby'

TypogrubyFilter =
  Class.new(HTML::Pipeline::Filter) do
    def call # rubocop:disable Style/DocumentationMethod
      Typogruby.improve(html)
    end
  end

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

        ENCODING_HTML_DOCUMENT = (Encoding.default_external || 'UTF-8').to_s.freeze
        private_constant :ENCODING_HTML_DOCUMENT

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

          doc.output =
            if content.include? BODY_START_TAG
              replace_selected_content(content, config)
            else
              content
            end
        end

        #
        # Generates an HTML::Pipeline with a TypogrubyFilter configured.
        #
        # @return [HTML::Pipeline] HTML Pipeline ready to process content
        #
        def filter_pipeline
          @filter_pipeline ||= HTML::Pipeline.new([TypogrubyFilter])
        end

        #
        # Takes an HTML document and replaces each fragment matching a CSS
        # selector in config[:tag_selector] with typogrified HTML.
        #
        # @param [String] html A full HTML document with <!doctype> & <body>
        # @param [Jekyll::Configuration] config Config for this plugin,
        #                                including :tag_selector key to select
        #
        # @return [String] Full modified HTML document
        #
        def replace_selected_content(html, config)
          if config[:tag_selector]
            doc = Nokogiri::HTML(html, nil, ENCODING_HTML_DOCUMENT)
            elements = doc.css(config[:tag_selector])
            elements.each do |node|
              pipeline = filter_pipeline.call(node.to_html)
              node.replace(pipeline[:output].to_s)
            end
            doc.to_html
          else
            pipeline = filter_pipeline.call(html)
            pipeline[:output].to_s
          end
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
          Jekyll::Configuration.new({tag_selector: 'article'})
        end
      end
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  warn 'Typogrifying…'
  Jekyll::Typogrify::Auto.typogrify(doc)
end
