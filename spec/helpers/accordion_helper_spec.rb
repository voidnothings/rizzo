require 'spec_helper'

describe AccordionHelper do
  include RSpec::Rails::ViewExampleGroup


  before do
    class << helper
      include Haml, Haml::Helpers
    end
    helper.init_haml_helpers
  end

  describe '#MAX_NAV_ITEMS_PER_GROUP' do
    it { AccordionHelper::MAX_NAV_ITEMS_PER_GROUP.should be 7 }
  end


  describe '#grouped_content_for' do

    let(:title) { 'Neighbourhoods' }
    let(:section){ title.downcase.dasherize }
    let(:content) { "some-long-content" }

    context 'renders content wrapped on an accordion' do
      let(:with_accordion){ helper.grouped_content_for(title, { :use_accordion => true } ){ content } }
      it { with_accordion.should have_css("div.accordion.accordion--#{section}") }
      it { with_accordion.should have_css("label.group__title--aside", text: title )}
      it { with_accordion.should have_css("#js-#{section}", :text=> 'some-long-content' ) }
    end

    context 'renders content without the accordion component' do
      let(:without_accordion){ helper.grouped_content_for(title){ content } }
      it { without_accordion.should_not have_css("div.accordion.accordion--#{section}") }
      it { without_accordion.should have_css("label.group__title--aside", text: title ) }
      it { without_accordion.should have_css("#js-#{section}", :text=> 'some-long-content' ) }
    end

   end


  describe '#accordion' do

    context 'renders content on a accordion component' do

      let(:title) { 'Neighbourhoods' }
      let(:content) { "<div class='accordion-test-content'>some-content</div>" }
      let(:section){ title.downcase.dasherize }
      let(:accordion){ helper.accordion_for(title){ content } }

      it { accordion.should have_css("div.accordion.accordion--#{section}") }
      it { accordion.should have_css("input#ac-#{section}.accordion__input") }
      it { accordion.should have_css('div.accordion__target.accordion__target--large') }
      it { accordion.should have_css("div.accordion__target > label[for=ac-#{section}]", text: title )}
      it { accordion.should have_css("#js-#{section}") }
      it { accordion.should have_css("label.accordion__handler[for=ac-#{section}]", text: '' )}

      it 'yields content' do
        accordion.should have_css("#js-#{section} div.accordion-test-content", :text=> 'some-content' )
      end

      context 'custom section name' do
        let(:section){ 'custom' }
        let(:accordion){ helper.accordion_for(title, {section: section }){ content } }
        it { accordion.should have_css("#js-#{section} div.accordion-test-content", :text=> 'some-content' ) }
      end

      context 'custom handlers text' do
        let(:expand_text){ 'read even more' }
        let(:collapse_text){ 'read a lot less' }
        let(:accordion){ helper.accordion_for(title, {expand_text: expand_text, collapse_text: collapse_text }){ content } }
        it { accordion.should have_css("label.accordion__handler[data-expand=\"#{expand_text}\"]", text: '' )}
        it { accordion.should have_css("label.accordion__handler[data-collapse=\"#{collapse_text}\"]", text: '' )}
      end

      context 'initial accordion open' do
        let(:section){ 'custom' }
        let(:accordion){ helper.accordion_for(title, {section: section, is_open: true }){ content } }
        it { accordion.should match("<input checked class='accordion__input' id='ac-#{section}' type='checkbox' />") }
      end

      context 'initial accordion closed' do
        let(:section){ 'custom' }
        let(:accordion){ helper.accordion_for(title, {section: section, is_open: false }){ content } }
        it { accordion.should match("<input class='accordion__input' id='ac-#{section}' type='checkbox' />") }
      end

    end

  end

  describe '#group_body' do

    let(:title) { 'Neighbourhoods' }
    let(:content) { "<div class='test-content'>another-content</div>" }
    let(:section){ title.downcase.dasherize }
    let(:group_body){ helper.group_body_for(title){ content } }

    it { group_body.should have_css("#js-#{section}") }
    it { group_body.should have_css("label.group__title--aside", text: title )}

    it 'yields content' do
      group_body.should have_css("#js-#{section} div.test-content", :text=> 'another-content' )
    end

    context 'custom section name' do
      let(:section){ 'custom' }
      let(:group_body){ helper.group_body_for(title, {section: section }){ content } }
      it { group_body.should have_css("#js-#{section} div.test-content", :text=> 'another-content' ) }
    end

  end

end

