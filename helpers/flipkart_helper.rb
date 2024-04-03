module Flipkart
$flipkart_login_popup_button = "//span[@role='button'][text() = '✕']"
$flipkart_global_search_inputbox = "//input[@title='Search for Products, Brands and More']"
$flipkart_select_category_checkbox = "//span[text() = 'CATEGORIES']/ancestor::div//a[@title='?']/preceding-sibling::span"
$flipkart_select_brand_checkbox = "//div[@title='?']//input/following-sibling::div[1]"
$flipkart_flipkart_assured_checkbox = "//label[contains(@class,'shbqsL')]//input/following-sibling::div[1]"
$flipkart_sort_by_filter = "//span[text()='Sort By']/following-sibling::div[text()='?']"
$flipkart_result_text = "//div[@class='_2kHMtA']"
$flipkart_product_detail_link = "(//div[@class='_2kHMtA']/a)[?]"
$flipkart_product_name_text = "(//div[@class='_4rR01T'])[?]"
$flipkart_product_price_text = "(//div[@class='_30jeq3 _1_WHN1'])[?]"

	def self.global_search_item item_name
		if element_present $flipkart_login_popup_button
			return_element($flipkart_login_popup_button).click
		end
		return_element($flipkart_global_search_inputbox).send_keys [item_name, :enter]
	end
	
	def self.select_category category
		obj_locator = $flipkart_select_category_checkbox.sub('?',category)
		return_element(obj_locator).click
	end
	
	def self.select_brand brand
		obj_locator = $flipkart_select_brand_checkbox.sub('?',brand)
		return_element(obj_locator).click
		#com_scroll_till_element $flipkart_flipkart_assured_checkbox
		sleep 2
		return_element($flipkart_flipkart_assured_checkbox).click
	end
	
	def self.select_sort_filter sort_by
		obj_locator = $flipkart_sort_by_filter.sub('?',sort_by)
		return_element(obj_locator).click
	end
	
	def self.read_result_from_screen
		elements = page.all(:xpath, $flipkart_result_text)
		count = elements.length
		result_array = Array.new
		for i in 1..count do
			link = return_element($flipkart_product_detail_link.sub('?',i.to_s))['href']
			name = return_element($flipkart_product_name_text.sub('?',i.to_s)).text
			price = return_element($flipkart_product_price_text.sub('?',i.to_s)).text
			result_array.push({:product_name => "#{name}", :product_link => "#{link}", :product_price => "#{price}"})
		end
		return result_array
	end
end