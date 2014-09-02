module  MembersHelper

  def abridged_url(str)
    if str.present?
      uri = URI(str)
      "#{uri.host}#{uri.path}#{uri.query}#{uri.fragment}"
    else # string is blank
      ''
    end
  end
end
