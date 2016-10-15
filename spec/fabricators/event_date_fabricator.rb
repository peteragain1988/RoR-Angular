Fabricator(:event_date) do
  start { 1.day.from_now }
  finish { 2.days.from_now }
  event
end