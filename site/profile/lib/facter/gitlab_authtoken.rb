# gitlab_authtoken.rb

Facter.add('gitlab_authtoken') do
  setcode do
    if File.exist? '/bin/gitlab-rails'
      Facter::Core::Execution.exec(%q{echo "User.find_by(username: 'root').authentication_token" | gitlab-rails console production | sed -n 4s/\"//pg})
    end
  end
end
