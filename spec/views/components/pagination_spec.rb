require 'spec_helper'

describe "components/_pagination.html.haml" do

  default_properties = {
    :total => 5,
    :current => 1,
    :num_visible => 5,
    :path => "/?page=%i"
  }

  describe 'backward links' do

    it 'renders previous and first page links when not on the first page' do

      view.stub(properties: default_properties.merge( :current => 2 ))

      render

      rendered.should have_css('.pagination__backwards')
      rendered.should have_css('.pagination__link--prev')
      rendered.should have_css('.pagination__link--first')

    end

    it 'does not render previous and first page links when on the first page' do

      view.stub(properties: default_properties)

      render

      rendered.should_not have_css('.pagination__backwards')
      rendered.should_not have_css('.pagination__link--prev')
      rendered.should_not have_css('.pagination__link--first')

    end

  end

  describe 'forward links' do

    it 'renders next and last page links when not on the last page' do

      view.stub(properties: default_properties)

      render

      rendered.should have_css('.pagination__forwards')
      rendered.should have_css('.pagination__link--next')
      rendered.should have_css('.pagination__link--last')

    end

    it 'does not render next and last page links when on the last page' do

      view.stub(properties: default_properties.merge( :current => 5 ))

      render

      rendered.should_not have_css('.pagination__forwards')
      rendered.should_not have_css('.pagination__link--next')
      rendered.should_not have_css('.pagination__link--last')

    end

  end

  describe 'pagination numbers' do

    it 'renders pagination numbers given a total of 5' do

      view.stub(properties: default_properties)

      render

      rendered.should have_css('.pagination__numbers')

    end

    it 'does not render pagination given a total of 1' do

      view.stub(properties: default_properties.merge( :total => 1 ))

      render

      rendered.should_not have_css('.pagination__numbers')

    end

    it 'renders selected variation on for the current page number' do

      view.stub(properties: default_properties)

      render

      rendered.should have_css('.pagination__numbers .pagination__link.pagination__link--current:nth-child(1)')

    end

    it 'renders numbers 1-5 given a total of 20 and current page number of 2' do

      view.stub(properties: default_properties.merge( :total => 20, :current => 2 ))

      render

      links = Capybara.string(rendered).all('.pagination__numbers .pagination__link').map { |el| el.text }
      links.should eq( ['1', '2', '3', '4', '5'] )

    end

    it 'renders numbers 8-12 given a total of 20 and current page number of 10' do

      view.stub(properties: default_properties.merge( :total => 20, :current => 10 ))

      render

      links = Capybara.string(rendered).all('.pagination__numbers .pagination__link').map { |el| el.text }
      links.should eq( ['8', '9', '10', '11', '12'] )

    end

    it 'renders numbers 16-20 given a total of 20 and current page number of 18' do

      view.stub(properties: default_properties.merge( :total => 20, :current => 18 ))

      render

      links = Capybara.string(rendered).all('.pagination__numbers .pagination__link').map { |el| el.text }
      links.should eq( ['16', '17', '18', '19', '20'] )

    end

  end

  describe 'pagination link URLs' do

    it 'formats the given path string for the correct number' do

      view.stub(properties: default_properties)

      render

      # The current page is not a link
      links = Capybara.string(rendered).all('.pagination__numbers a.pagination__link').map { |el| el[:href] }
      links.should eq( ['/?page=2', '/?page=3', '/?page=4', '/?page=5'] )

    end

    it 'appends the given URL parameter if it does not already exist in the given path' do
    end

    it 'replaces the given URL parameter if it already exists in the given path' do
    end

  end

end