Puppet::Type.newtype :http, :is_capability => true do
  newparam :name, :is_namevar => true
  newparam :ip
  newparam :port
  newparam :host
end
