assert('Discount#header') do
  m = Discount.new('markdown.css', "titlehoge")
  m.header.split('"').include?("markdown.css")
end
