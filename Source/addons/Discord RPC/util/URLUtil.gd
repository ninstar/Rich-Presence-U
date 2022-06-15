class_name URLUtil

static func dict_to_url_encoded(data: Dictionary) -> String:
	var client: HTTPClient = HTTPClient.new()
	return client.query_string_from_dict(data)
