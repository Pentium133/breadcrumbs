class Breadcrumbs
  module Render
    class Base # :nodoc: all

      attr_reader :breadcrumbs, :options

      def initialize(breadcrumbs, options = {})
        @breadcrumbs = breadcrumbs
        @options     = default_options.merge(options)
      end

      # @abstract
      # @return [Hash] default options
      def default_options
        { :class => "breadcrumbs" }
      end

      # @abstract
      # @return [String] the rendered HTML
      def render
        ""
      end

      # Build a HTML tag.
      #
      #   tag(:p, "Hello!")
      #   tag(:p, "Hello!", :class => "hello")
      #   tag(:p, :class => "phrase") { "Hello" }
      #
      def tag(name, *args, &block)
        options = args.pop if args.last.kind_of?(Hash)
        options ||= {}

        content = args.first
        content = self.instance_eval(&block) if block_given?

        attrs = " " + options.collect {|n, v| %[%s="%s"] % [n, v] }.join(" ") unless options.empty?

        %[<#{name}#{attrs}>#{content}</#{name}>]
      end

      protected
      def wrap_item(url, text, options)
        if url
          tag(:a, text, options.merge(:href => url))
        else
          tag(:span, text, options)
        end
      end

      def escape(text)
        text.respond_to?(:html_safe?) && text.html_safe? ? text : Rack::Utils.escape_html(text)
      end
    end
  end
end
