require 'spec_helper'

describe SnippetSupport do
  
  subject { Class.new { include SnippetSupport }.new }

  context ', checking a template snippet' do 

    it ' returns the default snippet' do
      subject.template_for(:head).should eq('layouts/snippets/_head')
    end

    it ' returns the secure snippet' do
      subject.template_for(:head, true).should eq('layouts/snippets/_secure_head')
    end

  end



end
