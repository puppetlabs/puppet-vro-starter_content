require 'fileutils'

# VARIABLES
# These are common string variables that are used by the build tasks.

ENV['version']            ||= 'dev'
ENV['offline_repos_path'] ||= '/opt/puppetlabs/repos'
ENV['repos_name']         ||= "pe-demo-code-repos-#{ENV['version']}"
ENV['environment_name']   ||= "pe-demo-#{ENV['version']}"
ENV['platform_tar_flags'] ||= %x{uname} == 'Darwin' ? '--disable-copyfile' : ''

# TASKS
# These tasks result in actions or artifacts
#

task :default => [:repos_tarball]

desc "Create a tarball containing a self-contained version of all repositories needed to run r10k"
task :repos_tarball => "build/#{ENV['repos_name']}.tar.gz" do
  puts "repos_tarball task complete"
end

desc "Create a tarball containing an extracted environment (as would be built by r10k)"
task :environment_tarball => "build/#{ENV['environment_name']}.tar.gz" do
  puts "environment_tarball task complete"
end

desc "Clean up and remove the build directory"
task :clean do
  rm_rf 'build'
end

# FUNCTIONS
# Helper routines to capture logic that is required by more than one task
#

def all_files_in_git
  @all_files_in_git ||= %x{git ls-files}.split("\n")
end

def tar_transform_flags(from, to)
  case %x{uname}.chomp
  when 'Darwin'
    "-s /#{from}/#{to}/"
  else
    "--transform='s/#{from}/#{to}/'"
  end
end

def tarczf(file, target, transform_to)
  Dir.chdir('build') do
    flags = [
      ENV['platform_tar_flags'],
      tar_transform_flags(target, transform_to),
      "-czf #{file}",
      target
    ]
    sh "tar #{flags.join(' ')}"
  end
end

def git_clone_bare(from, to)
  puts "git cloning and repacking from #{from} to #{to}"
  verbose(false) do
    sh "git clone --quiet --bare --no-hardlinks '#{from}' '#{to}'"
    sh "GIT_DIR='#{to}' git repack -a --quiet"
    rm_f(File.join(to, 'objects', 'info', 'alternates'))
  end
end

# FILES
# These define the files Rake tracks and builds
#

file 'build/repos' => ['build/environment', 'build/control-repo'] do
  rm_rf 'build/repos'
  mkdir_p 'build/repos'

  Rake::FileList['build/environment/modules/*'].each do |mod_dir|
    mod_name   = File.basename(mod_dir)
    dotgit_dir = "#{mod_dir}/.git"
    repo_dir   = "build/repos/#{mod_name}.git"

    git_clone_bare(dotgit_dir, repo_dir)
  end

  control_dotgit_dir = 'build/control-repo/.git'
  control_repo_dir   = 'build/repos/control-repo.git'
  git_clone_bare(control_dotgit_dir, control_repo_dir)
end

file 'build/Puppetfile' => ['build/environment'] do
  File.open('build/Puppetfile', 'w') do |file|
    file.write("forge 'forgeapi.puppetlabs.com'\n\n")

    Rake::FileList["#{'build/environment/modules'}/*"].each do |mod_dir|
      name = File.basename(mod_dir)
      head = File.read(File.join(mod_dir, '.git', 'HEAD')).chomp
      ref  = head.match(%r{^ref: }) ? head.sub(%r{^ref: refs/heads/}, '') : head

      file.write("mod '#{name}',\n")
      file.write("  :git => '#{ENV['offline_repos_path']}/#{name}.git',\n")
      file.write("  :ref => '#{ref}'\n\n")
    end
  end
end

file 'build/control-repo' => ['build/Puppetfile'] do
  rm_rf 'build/control-repo'
  mkdir 'build/control-repo'
  Dir.chdir('build/control-repo') do
    sh "git clone ../../.git ."
    sh 'git branch -m production 2>/dev/null || git checkout -b production'
    cp '../Puppetfile', 'Puppetfile'
    sh "echo #{ENV['version']} > VERSION"
    sh 'git add Puppetfile VERSION'
    sh 'git commit -m "Lab environment control repo initialized" --quiet'
  end
end

file 'build/environment' => all_files_in_git do
  rm_rf 'build/environment'
  mkdir_p 'build/environment'

  # Recursively copy in all top-level files or directories
  all_files_in_git.map { |f| f.split('/').first }.uniq.each do |file|
    cp_r file, 'build/environment', :verbose => true
  end

  Dir.chdir('build/environment') do
    sh "r10k puppetfile install -v"
  end

  Dir.entries('build/environment/modules').reject{|e| e =~ /^\./}.each do |mod|
    Dir.chdir("build/environment/modules/#{mod}") do
      puts "Creating a new repo from snapshot for module #{mod}"
      verbose(false) do
        rm_rf '.git'
        sh 'git init --quiet .'
        sh 'git add -f *'
        sh 'git commit -m "create new repo from snapshot" --quiet'
      end
    end
  end
end

file "build/#{ENV['environment_name']}.tar.gz" => ['build/environment'] do
  file         = "#{ENV['environment_name']}.tar.gz"
  target       = File.basename('build/environment')
  transform_to = ENV['environment_name']
  tarczf(file, target, transform_to)
end

file "build/#{ENV['repos_name']}.tar.gz" => ['build/control-repo', 'build/repos'] do
  file         = "#{ENV['repos_name']}.tar.gz"
  target       = File.basename('build/repos')
  transform_to = ENV['repos_name']
  tarczf(file, target, transform_to)
end

