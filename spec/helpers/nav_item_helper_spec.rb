require 'spec_helper'

describe NavItemHelper do

  include RSpec::Rails::ViewExampleGroup

  before do
    class << helper
      include Haml, Haml::Helpers
    end
    helper.init_haml_helpers
  end

  describe '#nav_item_aside' do

    let(:description) { nil }
    let(:count) { nil }
    let(:name) { 'Lisbon' }
    let(:href) { '/portugal/lisbon/hotels' }
    let(:item) { { path: href, name: name, description: description, count: count }}

    let(:extra_style) { nil }
    let(:section) { 'neighbourhoods' }

    context 'renders a standard aside nav_item without count and description' do
      let(:nav_item){ helper.nav_item_aside(item, section) }
      it { nav_item.should have_css("a.nav__item--stack.nav__item--chevron") }
      it { nav_item.should have_css("a.js-#{section}-item") }
      it { nav_item.should have_css("a[href='#{href}']", :text=> name) }
      it { nav_item.should_not have_css("span.nav__standfirst") }
      it { nav_item.should_not have_css("span.facet--inline-count") }
    end

    context 'renders a standard aside nav_item with counts' do
      let(:count) { 127 }
      let(:nav_item){ helper.nav_item_aside(item, section) }
      it { nav_item.should have_css("a.nav__item--stack.nav__item--chevron") }
      it { nav_item.should_not have_css("span.nav__standfirst") }
      it { nav_item.should have_css("span.facet--inline-count", :text => count) }
    end

    context 'renders a standard aside nav_item with description' do
      let(:description) { 'sunny, sunny, sunny days' }
      let(:nav_item){ helper.nav_item_aside(item, section) }
      it { nav_item.should have_css("a.nav__item--stack.nav__item--chevron") }
      it { nav_item.should have_css("span.nav__standfirst", :text => description) }
      it { nav_item.should_not have_css("span.facet--inline-count") }
    end

    context 'renders a standard aside nav_item without description' do
      let(:description) { 'sunny, sunny, sunny days' }
      let(:nav_item){ helper.nav_item_aside(item, section, :show_description => false) }
      it { nav_item.should have_css("a.nav__item--stack.nav__item--chevron") }
      it { nav_item.should_not have_css("span.nav__standfirst") }
      it { nav_item.should_not have_css("span.facet--inline-count") }
    end

   end

   describe '#nav_item_aside_style' do

    let(:section) { 'neighbourhoods' }
    let(:current) { nil }
    let(:extra_style) { nil }

    context 'default nav item style' do
      let(:nav_style){ helper.nav_item_aside_style(section, current) }
      it { nav_style.should match "nav__item--stack nav__item--chevron js-#{section}-item"}
    end

    context 'current nav item style' do
      let(:current) { true }
      let(:nav_style){ helper.nav_item_aside_style(section, current) }
      it { nav_style.should match "nav__item--stack nav__item--chevron js-#{section}-item nav__item--current--stack"}
    end

    context 'nav item style with extra style' do
      let(:extra_style) { 'another-class-definition' }
      let(:nav_style){ helper.nav_item_aside_style(section, current, extra_style) }
      it { nav_style.should match "nav__item--stack nav__item--chevron js-#{section}-item #{extra_style}"}
    end

   end

   describe 'nav items current item' do

     context 'has current item' do

       let(:items){
         [
           { path: '/foo1', name: 'foo1', current: false },
           { path: '/foo2', name: 'foo2', current: false },
           { path: '/foo3', name: 'foo3', current: true }
       ]
       }

       it { helper.has_current_item?(items).should be_true}

     end

     context 'does not have a current item' do

       let(:items){
         [
           { path: '/foo1', name: 'foo1', current: false },
           { path: '/foo2', name: 'foo2', current: false },
           { path: '/foo3', name: 'foo3', current: false }
       ]
       }

       it { helper.has_current_nav_item?(items).should be_false}

     end

   end


end


