{ rubyNix, symlinkJoin }:

let
  chefWorkstationEnv = rubyNix {
    name = "chef-workstation";
    gemset = ./gemset.nix;
  };
in
# adds symlinks of hello and stack to current build and prints "links added"
symlinkJoin { name = "chef-workstation"; paths = [ chefWorkstationEnv.envMinimal ]; postBuild = "echo links added"; }


#{ (other-stuff), openssl }:
#bundlerEnv {
#  name = "chef-workstation";
#  # nix-shell -p bundix zlib libiconv --run 'bundix --magic'

#  # Do not change this to pname & version until underlying issues with Ruby
#  # packaging are resolved ; see https://github.com/NixOS/nixpkgs/issues/70171

#  inherit targetRuby;
#  gemfile = ./Gemfile;
#  lockfile = ./Gemfile.lock;
#  gemset = ./gemset.nix;
#  ruby = targetRuby;
#  bundler = myBundler;
#  # buildInputs = [ yajl libffi ];
#  configureScript = "bundler config set --local force_ruby_platform true";
#  postInstall = ''
#    rm -f $out/bin/{bundle,bundler,erb,gem,irb,racc,rake,rbs,rdoc,ri,ruby,typeprof,rake,httpclient}
#  '';

#  # passthru.updateScript = bundlerUpdateScript "chefdk";

#  meta = with lib; {
#    #TODO
#    description =
#      "A streamlined development and deployment workflow for Chef platform";
#    homepage = "https://downloads.chef.io/chef-dk/";
#    license = licenses.asl20;
#    maintainers = with maintainers; [ offline nicknovitski ];
#    platforms = platforms.unix;
#    badPlatforms = [ "aarch64-linux" ];
#  };
# }

