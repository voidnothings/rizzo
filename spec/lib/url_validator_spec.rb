require 'spec_helper'

describe Rizzo::UrlValidator do
  let(:expected_url)            { "http://www.lonelyplanet.com/africa" }
  let(:expected_url_with_port)  { "http://www.lonelyplanet.com:80/africa" }
  subject { Rizzo::UrlValidator.validate(url) }

  describe 'validate' do
    let(:url) { expected_url }
    
    it { should eq(expected_url) }
  end

  context 'different domain' do
    let(:url) { "http://www.google.com/africa" }

    it { should eq(expected_url) }
  end

  describe 'protocol' do
    context 'https' do
      let(:url) { "https://www.lonelyplanet.com/africa" }

      it { should eq(url) }
    end

    context 'unsupported protocol' do
      let(:url) { "ftp://www.lonelyplanet.com/africa" }

      it { should eq(expected_url_with_port) }
    end
  end

  context 'ensures correct port' do
    let(:url) { "http://www.lonelyplanet.com:22/africa" }

    it { should eq(expected_url) }
  end

end
