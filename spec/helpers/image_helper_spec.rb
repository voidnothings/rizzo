require 'spec_helper'

describe ImageHelper do

  describe "#safe_image_tag" do
    it 'returns nil when no image url' do
      helper.safe_image_tag(nil).should == nil
    end

    it 'returns an image_tag for a card when image url exists' do
      img = double
      helper.should_receive(:image_tag).with('http://www.google.com/image.jpg', {}).and_return(img)
      helper.safe_image_tag('http://www.google.com/image.jpg', {}, true).should == "<div data-uncomment=true><!-- " + img + " --></div>"
    end

    it 'returns a commented image_tag for a card when lazyload is passed as an argument' do
      img = double
      helper.should_receive(:image_tag).with('http://www.google.com/image.jpg', {}).and_return(img)
      helper.safe_image_tag('http://www.google.com/image.jpg').should == img
    end

  end

  describe "#commented_image_tag" do
    it 'returns nil when no image url' do
      helper.commented_image_tag(nil).should == nil
    end

    it 'returns a commented image_tag when image url exists' do
      img = double
      helper.should_receive(:image_tag).with('http://www.google.com/image.jpg', {}).and_return(img)
      helper.commented_image_tag('http://www.google.com/image.jpg').should == "<div data-img=true><!-- " + img + " --></div>"
    end

  end


end
