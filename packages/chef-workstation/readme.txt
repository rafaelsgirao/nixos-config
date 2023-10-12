wget https://raw.githubusercontent.com/chef/chef-workstation/main/components/gems/ Gemfile.lock, Gemfile

nix shell github:inscapist/bundix/main

nix-shell -p zlib libiconv gecode_3 autoconf --run 'bundix --magic'
