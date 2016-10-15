Time::DATE_FORMATS.merge!(
    human: lambda {|time| time.strftime("%a, #{time.day.ordinalize} of %b %Y at %I:%M%p") }
)