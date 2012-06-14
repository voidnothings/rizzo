class RedirectorController < ActionController::Base
  def show
    target_url = Rizzo::UrlEncryptor.decrypt(params[:encrypted_url])
    increment_stats_bucket_for_redirected_url target_url
    redirect_to target_url
  rescue Rizzo::UrlEncryptor::BadUrl
    increment_stats_bucket_for_bad_redirected_url params[:encrypted_url]
    render :status => :bad_request, :nothing => true
  end

  private

  def increment_stats_bucket_for_bad_redirected_url(bad_url = "blank")
    increment_stats_bucket("redirector", "bad_url", bad_url)
  end

  def increment_stats_bucket_for_redirected_url(url)
    uri  = URI.parse(url)
    host = uri.hostname.gsub(/\./, "-")
    path = uri.path.present? && uri.path.gsub(/\//, ".")
    increment_stats_bucket("redirector", "#{host}#{path}")
  end

  def increment_stats_bucket(*bucket_parts)
    Stats.increment(bucket_parts.join(".")) if defined?(Stats)
  end
end
