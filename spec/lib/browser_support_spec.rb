require 'spec_helper'

describe BrowserSupport do
  
  subject { Class.new { include BrowserSupport }.new }

  context ', Sniffing' do 
    it 'identifies the client browser as IE' do
      subject.is_browser_ie?('.Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C').should be true
    end
    #   
    it 'does not identifies the client browser as IE' do
      subject.is_browser_ie?('OTHER 8.0').should be false
    end

    it 'identifies the client browser as IE6' do
      subject.is_browser_ie6?('Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)').should be true
    end

    it 'identifies the client browser as IE7' do
      subject.is_browser_ie7?('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C').should be true
    end

    it 'identifies the client browser as IE8' do
      subject.is_browser_ie8?('Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C').should be true
    end

    it 'identifies the client browser as IE9' do
      subject.is_browser_ie9?('Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0').should be true
    end

    it 'identifies the client browser as Chrome' do
      subject.is_browser_chrome?('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.8 (KHTML, like Gecko) Chrome/20.0.1104.0 Safari/536.8').should be true
    end

    it 'identifies the client browser as Safari' do
      subject.is_browser_safari?('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.54.16 (KHTML, like Gecko) Version/5.1.4 Safari/534.54.16').should be true
    end

    it 'identifies the client browser as Firefox' do
      subject.is_browser_firefox?('Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-GB; rv:1.9.2.27) Gecko/20120216 Firefox/3.6.27').should be true
      subject.is_browser_chrome?('Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-GB; rv:1.9.2.27').should be false
    end

    it 'identifies the client browser as Opera' do
      subject.is_browser_opera?('Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; Edition MacAppStore; en) Presto/2.10.229 Version/11.61').should be true
      subject.is_browser_ie?('Opera/9.80 (Macintosh; Intel Mac OS X 10.6.8; U; Edition MacAppStore; en) Presto/2.10.229 Version/11.61').should be false
    end

    it 'identifies the client browser as Mobile' do
      subject.is_browser_mobile?('Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3').should be true
      subject.is_browser_mobile?('Mozilla/5.0 (Linux; U; Android 0.5; en-us) AppleWebKit/522+ (KHTML, like Gecko) Safari/419.3').should be true
    end

    it 'sets the appropriate browser tag' do
      subject.client_browser('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C').should == "ie ie7"
      subject.client_browser('Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3').should == "mobile"
    end

    it 'checks if the browser is IE and the version is less than 9.0' do
      subject.is_client_browser_less_then_ie9?('.Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C').should be true
      subject.is_client_browser_less_then_ie9?('Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-GB; rv:1.9.2.27').should be false
    end

    it 'checks if browser is supported' do
      subject.is_client_browser_supported?('Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)').should be false
      subject.is_client_browser_supported?('Mozilla/4.0 (compatible; MSIE 5.23; Mac_PowerPC)').should be false
      subject.is_client_browser_supported?('.Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C').should be true
    end

    it 'checks if browser is unsupported' do
      subject.is_client_browser_unsupported?('Mozilla/5.0 (Windows; U; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)').should be true
      subject.is_client_browser_unsupported?('Mozilla/4.0 (compatible; MSIE 5.23; Mac_PowerPC)').should be true
      subject.is_client_browser_unsupported?('.Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C').should be false
    end

  end
end