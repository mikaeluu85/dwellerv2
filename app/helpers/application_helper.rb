module ApplicationHelper
  def sv_pluralize(word)
    word.to_s.pluralize(:sv)
  end
end