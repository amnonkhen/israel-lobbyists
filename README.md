# israel-lobbyists
This project is about visualization of the lobbysists in the Israeli Knesset
Its initial goal was to learn new technologies while solving an interesting problem.

The data is scraped from the Knesset's website http://www.knesset.gov.il/lobbyist/heb/lobbyist.aspx. The scraping is implemented as a Ruby Rake task with the mechanize library.
After being scraped the data is saved to sqlite3 db using rails.
The visulation is done on the client side.



