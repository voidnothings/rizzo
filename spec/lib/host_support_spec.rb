require 'spec_helper'
require 'host_support'

describe HostSupport do
  let(:request)        { double "request" }
  let(:path)           { double "path" }
  let(:subdomain)      { double "subdomain" }
  let(:host_with_port) { "foo.bar.lonelyplanet.com:8080" }

  subject { Class.new { include HostSupport }.new }

  before do
    subject.stub(:request => request)
    request.stub(:host_with_port => host_with_port)
  end

  describe "#host_with_subdomain_and_path" do
    context "when passed a path" do
      context "starting with a '/'" do
        it "prepends a '/'" do
          subject.host_with_subdomain_and_path("www", "path").should eq "//www.lonelyplanet.com:8080/path"
        end
      end

      context "not starting with a '/'" do
        it "does not prepend a '/'" do
          subject.host_with_subdomain_and_path("www", "/path").should eq "//www.lonelyplanet.com:8080/path"
        end
      end
    end

    it "gets the host with subdomain" do
      subject.should_receive(:host_with_subdomain).with(subdomain)
      subject.host_with_subdomain_and_path(subdomain)
    end
  end

  describe "#host_with_subdomain" do
    it "gets the host without subdomain" do
      subject.should_receive(:host_without_subdomain)
      subject.host_with_subdomain
    end

    it "prepends the host with '//' for relative protocols" do
      subject.host_with_subdomain.should =~ /\/\//
    end

    context "when not passed a subdomain" do
      it "returns the host with subdomain 'www'" do
        subject.host_with_subdomain.should eq "//www.lonelyplanet.com:8080"
      end
    end

    context "when passed a subdomain" do
      it "overwrites the request subdomain with the subdomain" do
        subject.host_with_subdomain("hotels").should eq "//hotels.lonelyplanet.com:8080"
      end
    end
  end

  describe "#host_without_subdomain" do
    it "returns the request host and port without any subdomain" do
      subject.host_without_subdomain.should eq "lonelyplanet.com:8080"
    end
  end

  #%w(hotels www shop).each do |subdomain|
  #  describe "##{subdomain}_url" do
  #    it "returns host_with_subdomain_and_path('#{subdomain}', path)" do
  #      should_receive(:host_with_subdomain_and_path).with(subdomain, path)
  #      send("#{subdomain}_url", path)
  #    end
  #  end
  #end
end
