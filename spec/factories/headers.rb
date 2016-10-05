module Factory
  class << self

    def headers
      {"X-Frame-Options"=>"ALLOWALL", "X-XSS-Protection"=>"1; mode=block", "X-Content-Type-Options"=>"nosniff", "Cache-Control"=>"no-cache, no-store", "Pragma"=>"no-cache", "Expires"=>"Fri, 01 Jan 1990 00:00:00 GMT", "Content-Type"=>"text/html; charset=utf-8", "Set-Cookie"=>"XSRF-TOKEN=Ab42; path=/\n_guidespark2_session=aB42; domain=app.guidespark.dev; path=/; HttpOnly"}
    end
  end
end
