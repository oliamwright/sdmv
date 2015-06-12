module ApplicationHelper
  def keywords_to_show (keywords)
    html_output = ""

    unless keywords.blank?
      keywords_hash = eval(keywords)
      keys = keywords_hash.keys
      keys.each do |key|
        html_output += key.to_s + " (" + keywords_hash[key].to_s + ")<br/>"
      end
    end

    html_output.html_safe
  end
end
