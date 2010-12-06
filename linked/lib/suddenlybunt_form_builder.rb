# encoding: utf-8
class SuddenlybuntFormBuilder < Formtastic::SemanticFormBuilder 

  # ToDo: need to patch  
  @@inline_errors ||= :sentence

  def wysihat_input(method, options)
    options[:required] = method_required?(method) unless options.key?(:required)
    options[:as]     ||= :wysihat

    html_class = [ options[:as], (options[:required] ? :required : :optional) ]
    html_class << 'error' if @object && @object.respond_to?(:errors) && !@object.errors[method.to_sym].blank?

    wrapper_html = options.delete(:wrapper_html) || {}
    wrapper_html[:id]  ||= generate_html_id(method)
    wrapper_html[:class] = (html_class << wrapper_html[:class]).flatten.compact.join(' ')

    input_parts = [:input, :errors, :hints]#@@inline_order.dup
    input_parts = input_parts - [:errors, :hints] if options[:as] == :hidden

    buttons = [:bold, :italic, :underline, :strikethrough, :h1, :h2, :h3, :p, :justify_left, :justify_center, :justify_right, :insert_ordered_list, :insert_unordered_list, :link, :html, :image]
    button_titles = ["볼드", "이탤릭", "밑줄", "가로줄", "제목1", "제목2", "제목3", "본문 스타일로 복구", "왼쪽 정렬", "가운데 정렬", "오른쪽 정렬", "숫자 리스트 만들기", "일반 리스트 만들기", "링크만들기", "HTML", "이미지 업로드"]

    tooltip_js = "<script type=\"text/javascript\" charset=\"utf-8\">\nsetTimeout(function(event){"
    buttons.each_with_index do |button,idx|
      _tt = "new Tooltips(\".wysihat a.#{button.to_s.gsub("_","")}\", {mouseFollow:false,opacity:1,align:'toolbar',title:\"#{button_titles[idx]}\"});"
      tooltip_js += _tt
    end
    tooltip_js += "}, 500);\n</script>"


    list_item_content = input_parts.map do |type|
      if type == :input
        html_options = options.delete(:input_html) || {}
        html_options["buttons"] = buttons
        self.label(method, options_for_label(options)) <<
        self.send(:wysihat_editor, method, html_options) << Formtastic::Util.html_safe(tooltip_js)
      else
        send(:"inline_#{type}_for", method, options)
      end
    end.compact.join("\n")

    return template.content_tag(:li, Formtastic::Util.html_safe(list_item_content), wrapper_html)
  end

  def inline_hints_for(method, options) #:nodoc:
#    options[:hint] = localized_string(method, options[:hint], :hint)
    return if options[:hint].blank? or options[:hint].kind_of? Hash
    template.content_tag(:p, options[:hint].html_safe, :class => 'inline-hints')
  end  

  def inline_errors_for(method, options = nil) #:nodoc:
    if render_inline_errors?
      errors = [@object.errors[method.to_sym]]
      errors << [@object.errors[association_primary_key(method)]] if association_macro_for_method(method) == :belongs_to

      # paperclip
      if err = @object.errors["#{method}_file_name".to_sym]
        errors << [err]
      elsif err = @object.errors["#{method}_file_size".to_sym]
        errors << [err]
      elsif err = @object.errors["#{method}_content_type".to_sym]
        errors << [err]
      end

      errors = errors.flatten.compact.uniq
      errors = errors.empty? ? [] : [errors.first]

      send(:"error_#{@@inline_errors}", [*errors]) if errors.any?
    else
      nil
    end
  end

end
