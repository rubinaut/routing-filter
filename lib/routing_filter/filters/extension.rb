# The Extension filter chops a file extension off from the end of the
# recognized path. When a path is generated the filter re-adds the extension 
# to the path accordingly.
# 
#   incoming url: /de/products/page/1
#   filtered url: /de/products
#   params:       params[:locale] = 'de'
# 
# You can install the filter like this:
#
#   # in config/routes.rb
#   Rails.application.routes.draw do
#     filter :locale
#   end
#
# To make your named_route helpers or url_for add the pagination segments you 
# can use:
#
#   products_path(:locale => 'de')
#   url_for(:products, :locale => 'de'))

module RoutingFilter
  class Extension < Filter
    attr_reader :extension, :exclude

    def initialize(*args)
      super
      @exclude   = options[:exclude]
      @extension = options[:extension] || 'html'
    end

    def around_recognize(path, env, &block)
      extract_extension!(path) unless excluded?(path)
      yield(path, env)
    end

    def around_generate(*args, &block)
      params = args.extract_options!                              # this is because we might get a call to root_url
      
      args << params
      
      yield.tap do |result|
        url = result.is_a?(Array) ? result.first : result
        append_extension!(url) if append_extension?(url)
      end
    end

    protected
    
      def extract_extension!(path)
        path.sub!(/\.#{extension}$/, '')
        $1
      end
      
      def append_extension?(url)
        !(blank?(url) || excluded?(url) || mime_extension?(url))
      end
      
      def append_extension!(url)
        url.replace url.sub(/(\?|$)/, ".#{extension}\\1")
      end
      
      def blank?(url)
        url.blank? || !!url.match(%r(^/(\?|$)))
      end
      
      def excluded?(url)
        case exclude
        when Regexp
          url =~ exclude
        when Proc
          exclude.call(url)
        end
      end
      
      def mime_extension?(url)
        url =~ /\.#{Mime::EXTENSION_LOOKUP.keys.join('|')}(\?|$)/
      end
  end
end