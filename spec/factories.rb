Factory.define :user do |f|
  f.sequence(:uid) {|n| "example#{n}@example.com"}
  f.refresh_token "refresh"
  f.expires_at(Time.now + 1.day)
  f.admin false
  f.firstname "Adam"
end

Factory.define :printout do |f|
  f.content "nl This is a printout"
  f.association :user
end
