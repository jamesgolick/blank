Factory.sequence :name do |n|
  "Name #{n}"
end

Factory.sequence :email do |n|
  "name#{n}@host.com"
end

Factory.define :person do |p|
  p.name                  { Factory.next :name }
  p.email                 { Factory.next :email }
  p.password              "monkey"
  p.password_confirmation "monkey"
end

Factory.define :remembered_person, :parent => :person do |p|
  p.remember_token            { Person.make_token }
  p.remember_token_expires_at 10.days.from_now
end
