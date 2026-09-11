#!/usr/bin/env ruby

require "json"
require "pathname"

site = Pathname(ARGV.fetch(0, "_site"))
raise "build output not found: #{site}" unless site.directory?

html_files = site.glob("**/*.html")
raise "no rendered HTML found" if html_files.empty?

types = []
html_files.each do |path|
  html = path.read
  html.scan(%r{<script type="application/ld\+json">(.*?)</script>}m).each do |match|
    data = JSON.parse(match.first)
    Array(data["@graph"]).each { |node| types << node["@type"] }
  rescue JSON::ParserError => error
    raise "invalid JSON-LD in #{path}: #{error.message}"
  end
end

%w[Organization WebSite BlogPosting ItemList FAQPage].each do |type|
  raise "missing schema type: #{type}" unless types.include?(type)
end

guide = site.join("drinking-games-guide/index.html")
raise "guide route missing" unless guide.file?
guide_html = guide.read
raise "FAQ answers are not visible" unless guide_html.include?("Do players have to drink alcohol?") && guide_html.include?("non-alcoholic option")

robots = site.join("robots.txt").read
raise "robots.txt does not allow crawling" unless robots.include?("User-agent: *\nAllow: /")
raise "sitemap missing" unless site.join("sitemap.xml").file?
raise "negative route unexpectedly exists" if site.join("this-route-must-not-exist/index.html").exist?

puts "Validated #{html_files.length} rendered HTML files"
puts "JSON-LD types: #{types.compact.uniq.sort.join(', ')}"
puts "Crawlability: robots.txt and sitemap.xml present"
puts "Routes: guide present; negative route absent"
