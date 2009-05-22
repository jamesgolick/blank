Factory.sequence :name do |n|
  "Name #{n}"
end

Factory.sequence :email do |n|
  "name#{n}@host.com"
end

Factory.sequence :open_id_url do |n|
  "http://openid#{n}.factory.com"
end

Factory.define :person do |p|
  p.name                  { Factory.next :name }
  p.email                 { Factory.next :email }
  p.password              "monkey"
  p.password_confirmation "monkey"
end

Factory.define :person_with_open_id, :parent => :person do |p|
  p.open_id_url               { Factory.next :open_id_url }
  p.open_id_url_authenticated true
end

Factory.define :remembered_person, :parent => :person do |p|
  p.remember_token            { Person.make_token }
  p.remember_token_expires_at 10.days.from_now
end
