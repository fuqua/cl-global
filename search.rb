#!/usr/bin/env ruby

require 'open-uri'
require 'mechanize'
require 'colorize'

unless ARGV[0] && ARGV[1]
  puts 'Usage: ./search.rb <query> <maxPrice>'
  exit
end

query = ARGV[0]
maxPrice = ARGV[1]
craigslist_url = 'http://dallas.craigslist.org'

url = []
url << "http://dallas.craigslist.org/search/mca"
url << "?catAbb=mca"
url << "&query=#{query}"
url << "&zoomToPosting="
url << "&minAsk=500"
url << "&maxAsk=#{maxPrice}"
url << "&srchType=T"
url = url.join

mech = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}

mech.get(url) do |page|
  page.search("//p[@class='row']").each do |row|
    link = row.search('a')[0]
    link_href = /^http/ =~ link['href'] ? link['href'] : craigslist_url + link['href']
    link_text = row.search('a')[1].text
    city = row.search("small").text
    price = row.search("span[@class='price']")[0].text

    puts "#{price.cyan} -  #{link_text.yellow} \n\t #{link_href.green} \n\n"
  end
end

