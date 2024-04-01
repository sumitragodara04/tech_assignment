describe "Flipkart's Search Functionality" do
  it "Flipkart Mobile Search" do
		data = DATA_HELPER.read_test_data
		visit data["Site URL"]
		Flipkart.global_search_item data["Search Product"]
		Flipkart.select_category data["Category"]
		Flipkart.select_brand data["Brand"]
		Flipkart.select_sort_filter data["Sorting"]
		sleep 5
		result = Flipkart.read_result_from_screen
		result.each do |details|
			puts "Product Link - #{details[:product_link]}"
			puts "Product Name - #{details[:product_name]}"
			puts "Product Price - #{details[:product_price]}"
		end
  end
end