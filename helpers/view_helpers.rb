module ViewHelpers

  def delete_button(desc, url)
    %Q{
    <form method="post" action="#{url}">
      <input type="hidden" name="_method" value="delete" />
      <button type="submit">#{desc}</button>
    </form>}.strip
  end

  def update_button(desc, url, attrs = {})
    inputs = attrs.map { |k,v| "<input type=\"hidden\" name=\"article[#{k}]\" value=\"#{v}\" />" }
    %Q{
    <form method="post" action="#{url}">
      <input type="hidden" name="_method" value="put" />
      #{inputs.join('\n')}
      <button type="submit">#{desc}</button>
    </form>}.strip
  end
  
  def simple_format(text, html_options={})
    start_tag = tag('p', html_options)
    text = text.to_s.dup
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    text.insert 0, start_tag
    text << "</p>"
  end

  def select(name, options, opts={})
    "<select name=\"#{name}\" #{html_opts(opts)}>\n#{options.map{|t,v| "<option value=\"#{v}\">#{h(t)}</option>"}.join("\n")}\n</select>"
  end

  def model_select(name, objects, opts={})
    meth = opts.delete(:meth)||:name
    select(name, objects.map{|o| [o.send(meth), o.id]}, opts)
  end

  def h(text)
    CGI.escapeHTML(text)
  end
  
  def url_for(entity, *args)
    parts = if entity.is_a?(Array)
      entity.first.class.name.downcase.underscore.pluralize
    elsif entity.respond_to?(:pk)
      [entity.class.name.downcase.underscore.pluralize, entity.pk]
    else
      entity
    end
    "/#{[parts, *args].flatten.join('/')}"
  end


end