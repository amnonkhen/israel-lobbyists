desc "scrape lobbyists from the knesset website"
task :scrape => :environment do
	require 'mechanize'
	require 'logger'
	require 'json'
	require 'set'
	require 'rubygems'
	
	mechanize = Mechanize.new { |agent| 
		agent.user_agent_alias = 'Windows Chrome'
	}
	mechanize.log = Logger.new "lobbyists_scrape.log"
	mechanize.log.level = Logger::INFO
	
	# load the lobbyists page
	page = mechanize.get('http://www.knesset.gov.il/lobbyist/heb/lobbyist.aspx')
	
	# iterate the list of lobbyists
	# each item in the lobbyists list is a link that runs javascript
	
	all_clients = Set.new
	all_lobbyists_links = page.links_with(:href => /javascript/)
	progress_bar = RakeProgressbar.new(all_lobbyists_links.size)
	all_lobbyists = all_lobbyists_links.map do |lobbyist_node| 
		theForm = page.form('aspnetForm')
		theForm['__EVENTTARGET'] = lobbyist_node.href.sub("javascript:__doPostBack('","").sub("','')","")
		theForm['__EVENTARGUMENT'] = ''
		page = mechanize.submit(theForm)
		progress_bar.inc
		lobbyist = Lobbyist.create
		lobbyist.name = page.at("//span[contains(@id, 'LobbyistDetails') and contains(@id, 'name')]").text
		lobbyist.corp = page.at("//span[contains(@id, 'LobbyistDetails') and contains(@id, 'Corporation_name')]").text
		lobbyist.email = page.at("//span[contains(@id, 'LobbyistDetails') and contains(@id, 'Profession')]").text
		# TODO: add client attributes: sector, type 
		page.search("//span[contains(@id, 'LobbyistDetails') and contains(@id, 'Represent') and contains(@id, 'represent')]").collect {|node| node.text.strip}.each { |c|
			client_attr = Hash[
				[:name, :sectors, :representation_type].zip(c.split('-').collect {|node| node.strip})]
			client = Client.where(['name = ?', client_attr[:name]]).first
			if client == nil
				client = Client.create
				client.attributes = client_attr
			end
			if client.valid?
				lobbyist.clients << client
				client.save
			end
		}
		lobbyist.save
		lobbyist
	end
	progress_bar.finished
end
