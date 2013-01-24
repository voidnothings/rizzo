require 'sinatra'
require 'kss'
require 'sinatra/base'


class StyleGuideApp < Sinatra::Base

  get '/' do
    erb :index
  end

  get '/components' do
    @styleguide = Kss::Parser.new('app/assets/stylesheets')
    erb :components
  end

  get '/grid' do
    @styleguide = Kss::Parser.new('app/assets/stylesheets/_core')
    erb :grid
  end

  get '/mixins' do
    @styleguide = Kss::Parser.new('app/assets/stylesheets')
    erb :mixins
  end

  get '/inputs' do
    @styleguide = Kss::Parser.new('app/assets/stylesheets')
    erb :inputs
  end

  helpers do
    # Generates a styleguide block. A little bit evil with @_out_buf, but
    # if you're using something like Rails, you can write a much cleaner helper
    # very easily.
    def styleguide_block(section, &block)
      @section = @styleguide.section(section)
      @example_html = capture{ block.call }
      @escaped_html = ERB::Util.html_escape @example_html
      @_out_buf << erb(:_styleguide_block)
    end

    # Captures the result of a block within an erb template without spitting it
    # to the output buffer.
    def capture(&block)
      out, @_out_buf = @_out_buf, ""
      yield
      @_out_buf
    ensure
      @_out_buf = out
    end
  end
end