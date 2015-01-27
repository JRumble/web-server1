require 'socket'                                    # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 	# Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..." 
      		 # Output to stdout that server started
loop do                                            		 # Server runs forever
  client = server.accept                           		 # Wait for a client to connect. Accept returns a TCPSocket

  request = []
  while (line = client.gets.chomp) && !line.empty?  	# Read the request and collect it until it's empty
    request << line
  end
  puts request											# Output the full request to stdout
			

			filename = request[0].gsub(/GET \//, '').gsub(/ HTTP.*/, '')


			if File.exists?(filename)
				response_document = File.read(filename)

				headers =[]
				headers << "HTTP/1.1 200 OK"

				if filename =~ /.css/
				      content_type = "text/css"
				elsif filename =~ /.html/
				      content_type = "text/html"
				else
				      content_type = "text/plain"
				end

				headers << "Content-Type: text/html"
				headers << "Content-Length: #{response_document.length}"
		 		headers << "Connection: close"
				headers = headers.join("\r\n")
			else
  				response_document = "File Not Found\n" + filename 		# need to indicate end of the string with \n
				not_found_header = []
				not_found_header << "HTTP/1.1 404 Not Found"
				not_found_header << "Content-Type: text/plain" # is always text/plain
				not_found_header << "Content-Length: #{response_document.length}" # should the actual size of the response body
				not_found_header << "Connection: close"
				header = not_found_header.join("\r\n")
			
			end

		
  
	document = [headers, response_document].join("\r\n\r\n")
	documents = [header, response_document].join("\r\n\r\n")	

	 		
  client.puts(response_document)                       		# Output the current time to the client
  client.close                                      		# Disconnect from the client
end