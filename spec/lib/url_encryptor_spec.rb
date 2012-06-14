require 'spec_helper'

# describe RedirectorHelper do
#   let(:message_encryptor)    { double "message_encryptor" }
#   let(:encrypted_url)        { "encrypted url" }
#   let(:decrypted_url)        { "decrypted url" }
#   let(:encoded_url)          { "encoded url" }
#   let(:decoded_url)          { "decoded url" }
#   let(:redirector_show_path) { double "redirector show path" }
#   let(:url)                  { "http://foo.bar.com?zip=zap" }
#   let(:redirected_url)       { "sancsaocnoewqnjcoewqijfdow" }

#   before do
#     ActiveSupport::MessageEncryptor.stub(:new => message_encryptor)
#   end
  
#   describe "#original_url_from_redirected_url" do
#     before do
#       message_encryptor.stub(:decrypt => decrypted_url)
#       URI.stub(:decode => decoded_url)
#     end
    
#     it "URI decodes the redirected url" do
#       URI.should_receive(:decode).with(redirected_url)
#       helper.original_url_from_redirected_url(redirected_url)
#     end

#     it "returns the decrypted, decoded url" do
#       message_encryptor.should_receive(:decrypt).with(decoded_url).and_return(decrypted_url)
#       helper.original_url_from_redirected_url(redirected_url).should eq decrypted_url
#     end
#   end
  
#   describe "#redirected_url_for" do    
#     before do
#       ActiveSupport::MessageEncryptor.stub(:new => message_encryptor)
#       message_encryptor.stub(:encrypt => encrypted_url)
#       URI.stub(:encode => encoded_url)
#       helper.stub(:redirector_path => redirector_show_path)
#     end
    
#     it "encrypts the url" do
#       message_encryptor.should_receive(:encrypt).with(url)
#       helper.redirected_url_for(url)
#     end

#     it "url encodes the encrypted url" do
#       URI.should_receive(:encode).with(encrypted_url)
#       helper.redirected_url_for(url)
#     end

#     it "returns an url to the redirector show action for the encoded encrypted url " do
#       helper.should_receive(:redirector_path).and_return(redirector_show_path)
#       helper.redirected_url_for(url).should eq redirector_show_path
#     end
#   end
# end
