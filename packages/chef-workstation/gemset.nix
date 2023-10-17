{
  activesupport = {
    dependencies = [ "base64" "bigdecimal" "concurrent-ruby" "connection_pool" "drb" "i18n" "minitest" "mutex_m" "tzinfo" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18jqxsjz9vs89v9jwz4f5vw9yj91cc2l2jwlzfgnxg8wmyjbqw47";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "7.1.1";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05r1fwy487klqkya7vzia8hnklcxy4vr92m9dmni3prfwk6zpw33";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.8.5";
  };
  appbundler = {
    dependencies = [ "mixlib-cli" "mixlib-shellout" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a7v2dkfrqazb5fq6rif73x3pjnvqs94yxfvin6v62am5lmzr43m";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.13.4";
  };
  artifactory = {
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wify8rhjwr5bw5y6ary61vba290vk766cxw9a9mg05yswmaisls";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.0.15";
  };
  ast = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04nc8x27hlzlrr5c2gn7mar4vdr0apw5xg22wp6m8dx3wqr04a0y";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.4.2";
  };
  aws-eventstream = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pyis1nvnbjxk12a43xvgj2gv0mvp4cnkc1gzw0v1018r61399gz";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.2.0";
  };
  aws-partitions = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x5vxx3vrzhpbg11cmx6fishjmdd5b3l4cr7nc5y5ykk0j1dvzvz";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.836.0";
  };
  aws-sdk-account = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kb21xfx9mkazv129bklcwbhk1sj95f17h49lgav76n9m5cx3ld0";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.18.0";
  };
  aws-sdk-alexaforbusiness = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jzaiydgy5dksw2j22anlrriys57173bb97nivkhh36kl0p4qs5a";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.65.0";
  };
  aws-sdk-amplify = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fv4w1npqglxm9sl6939akjw3y1ivhpl55i75azvbzx0f7abh3b8";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.32.0";
  };
  aws-sdk-apigateway = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bz9gavqg7v34zwf40iv2qn2cjlxm77ahdzjh545jxzm3c2m336h";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.88.0";
  };
  aws-sdk-apigatewayv2 = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09yjn68bwg73mm0qa89w6r89rc5dg3xy3kqnwc9qgnxk2d259m2a";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.51.0";
  };
  aws-sdk-applicationautoscaling = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lp008dcyiqcz90fkck5dgx23ycgk04rhd0n1ywz14rg45844nfn";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.51.0";
  };
  aws-sdk-athena = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19lbrcy1l8dn2pzr1sg73ynlcrllsvwfqag35r50mxy46hv260gh";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.75.0";
  };
  aws-sdk-autoscaling = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hv9nfzbn478vjv88c6jybf4nsii1c04vzqckgh4pajm5mc8kk7p";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.92.0";
  };
  aws-sdk-batch = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06lxajqdjwxdc9wx17igsdxj608charbpwhnfnb83dcrfaavkqms";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.73.0";
  };
  aws-sdk-budgets = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17gqxr2qh8jfx904h5hzf1j2xbdz30kbmrf527yylhji0546qar8";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.60.0";
  };
  aws-sdk-cloudformation = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10wsjs9zcv23mj4bbqlm6jy4qp769145fxc3bv97naibmlyb1wjq";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.91.0";
  };
  aws-sdk-cloudfront = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jd80rp2az3gy181n7ahryhlf5pricq5aj539av86xiwz6h6rvml";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.83.0";
  };
  aws-sdk-cloudhsm = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fsg5qnb0r5gbpd2zx842bmn47f4lna5sx7svvhayczqdk03jvs8";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.48.0";
  };
  aws-sdk-cloudhsmv2 = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "106khq01k5zalki1n6qq25xnpllg5g382mjign8d88f5jhnaz6km";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.51.0";
  };
  aws-sdk-cloudtrail = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pjcs940zfck5i0d87jqp08gsxpbig35vkz3rlwpvxx8ig67119v";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.69.0";
  };
  aws-sdk-cloudwatch = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xcfm6bdflwkgfgqkflc7wis7c8crq4j5sb0wc77m7plwlvbblk9";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.81.0";
  };
  aws-sdk-cloudwatchevents = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dbafxhkp3x5fgibc3i663mnf44kbmfh9ia9cq6fwn45cw2bpfik";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.62.0";
  };
  aws-sdk-cloudwatchlogs = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y1w190mkm6ykgqzbsmjc8c6n21jrz27z8gkhxgpmgkwgfhp2xdn";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.71.0";
  };
  aws-sdk-codecommit = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07zlbpv8dg1284pg6hslxv3vdb6s0qvsc9n6j833yjr2c3fk9g3a";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.60.0";
  };
  aws-sdk-codedeploy = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c2w6lz3vm1v7is5dzdffrjx9iyfds33db9i0a11zrnh98xsr4n2";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.60.0";
  };
  aws-sdk-codepipeline = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qpbf0xsp9sc43d6iwjrk3hp4a3rih0x6mjgn5x4ixqj4408qhd3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.62.0";
  };
  aws-sdk-cognitoidentity = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hhhnlipplr9fv8lvq612y49n4xasqdjkkxd7m002drp2zm7rzbj";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.45.0";
  };
  aws-sdk-cognitoidentityprovider = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v2lf191jinkl3kfbl6zdv29cn7xbpyksshww1mz29a323j5bm4x";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.76.0";
  };
  aws-sdk-configservice = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1akyjzaiia25n0g152cyyamczfj2pg6s36drp7c3cpanrmgp68az";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.99.0";
  };
  aws-sdk-core = {
    dependencies = [ "aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wvrz7d2rw17ihj2fmvaq91cg35pvk1asl4skncsk4w3mx7dlajp";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.185.1";
  };
  aws-sdk-costandusagereportservice = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18kg3r200xjymmwhaw64mw1mfiff0cqcps83sb4xz0pvyg04j5ld";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.50.0";
  };
  aws-sdk-databasemigrationservice = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ss4x2syf6c5ray6g61cxxcx2q7mzqv0gk00d1dl7g4c5z9avhwi";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.80.0";
  };
  aws-sdk-dynamodb = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ff1g8rn9d03bvvsdkp4wbafngxxigznazxhx60pkjhqpi80j5il";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.95.0";
  };
  aws-sdk-ec2 = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v6sk9r66575ki55vjs0jim1yx5xwd01bz571qf9g92yzcbmg0rf";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.413.0";
  };
  aws-sdk-ecr = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0igfpl3mkx1d51h2gwwjj6dl6zrlbj7r7y1dh34hxbhnaqv8ahjb";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.65.0";
  };
  aws-sdk-ecrpublic = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03jhn4zc58n1n88a7adcgr4nv8zms0gwkbkarq2z3kxclanyn0ms";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.23.0";
  };
  aws-sdk-ecs = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1djdq4rzm8xysr8xg1jfyh5xl368r98r1gp5c23mbyr1nya7z0si";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.130.0";
  };
  aws-sdk-efs = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17fc2z03g5x1hhbvjj7ivfag3mb0fpfslpv7dr6zn243b2wx4iz9";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.67.0";
  };
  aws-sdk-eks = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xdvx9nhg486fdha5kyd2bd9zvp8p6hlckg3s14k5fx5yvs9fgyv";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.90.0";
  };
  aws-sdk-elasticache = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q9pmzlp2b26sqaf7q009w20hjznl2m678l8md49mk5jmk88wbdc";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.92.0";
  };
  aws-sdk-elasticbeanstalk = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nh4925a4ifw15j29nb7sn1xbl1xyk82qbnmkshbdhaxcs2xf76n";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.61.0";
  };
  aws-sdk-elasticloadbalancing = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mzvnyxpay4h06qaqxksz8wp6nsm81wyq2p10bq5xjx0chymhb3k";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.49.0";
  };
  aws-sdk-elasticloadbalancingv2 = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bbkpcnjyc6b1hj46gsmlx0lk63pm9fhbpl67lrliq56l27bf8gs";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.93.0";
  };
  aws-sdk-elasticsearchservice = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bbb7n0jzh0s6733hla3q0z702xwrrbvcpmwaw74aqgajbw90dph";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.77.0";
  };
  aws-sdk-emr = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wybb0aadsk8x3whwlid58g40613c9rrl48g43ikgpqz9f3b44ac";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.53.0";
  };
  aws-sdk-eventbridge = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mnpcklsm8dicz35yj89jr870xii1xghfdjfqif1lxii4vvhlqba";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.46.0";
  };
  aws-sdk-firehose = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0686k7n3mx63i3hpj4f0q7kiz8q4qvws43drw18a5bv85afz7gf2";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.58.0";
  };
  aws-sdk-glue = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pjw4vfniswiprjr5vivgq3vilw05gqqr5mkkwhx38y6xc8kr7ga";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.145.0";
  };
  aws-sdk-guardduty = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qsf3sznszsaflxmv7x5mfypggirb5dkz9m90xmxp7vd9nxb6jn6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.80.0";
  };
  aws-sdk-iam = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f5zlwniwlvav51zk8afpm5fkvir9yriglg2qnfxfpq6lb555yix";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.87.0";
  };
  aws-sdk-kafka = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09sr4ssx4ygkv3g9kl1f4rgv0v9kz6xv7v3ib6crc601vlvw3833";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.63.0";
  };
  aws-sdk-kinesis = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sk23wk7cscnaaki4g1b379ldc64rqgmwms0biah2azpwcpi79kh";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.52.0";
  };
  aws-sdk-kms = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01z32ryrl18al0hazyimww808ij144pgs5m8wmp0k49i7k33hnlw";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.72.0";
  };
  aws-sdk-lambda = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w8k6v8b9glwz6qh2l7g6j497fkwssp27n12hw33yk611hhnsgd7";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.106.0";
  };
  aws-sdk-mq = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pr2v6lf2rcnfsdbs5s5ig5mlvnfm1xwy2y8jcyp9w4s933ps9fg";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.40.0";
  };
  aws-sdk-networkfirewall = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09yvk39rh6bkb409kcrwrj67vqhg7mnpwbj66s5x0as7ny3n6bgl";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.35.0";
  };
  aws-sdk-networkmanager = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c42w9705rxbgl51sbb9sl6zmimvkmzc4p407xv826fqykjr95c3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.37.0";
  };
  aws-sdk-organizations = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "169dz3ip2vz22mk6hczsd1v6lf2v428i0jhpllnay11zsficc6p1";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.77.0";
  };
  aws-sdk-ram = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rm6sr5kvdy9q1xjg00c80648l8j3cpc6l5fakfxiqhp256bf2ac";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.26.0";
  };
  aws-sdk-rds = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08sysj3ggijchrvl9c2v80vhaj9p169zgbwg09z9sc7bgq7gvlvi";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.197.0";
  };
  aws-sdk-redshift = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h189ppw0rhg3wiy3cww9sn1ir0z13dc8avs2v03v9plz0rax9n6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.99.0";
  };
  aws-sdk-route53 = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b8yizqc73w68442g4z44j64k0lm2fc2vwqw21ypcgplw0ld1r6x";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.80.0";
  };
  aws-sdk-route53domains = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mxmmq3lz8xxffg6s10i6n73g7s1makfxx46l9zd1a3p9ykycpf3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.52.0";
  };
  aws-sdk-route53resolver = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kdaxc6y3nvjcsqlcial78h2rca0z70bjx5isiv0diymjj3j9rh4";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.49.0";
  };
  aws-sdk-s3 = {
    dependencies = [ "aws-sdk-core" "aws-sdk-kms" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qwdkbwp3f5illkkmivzdr9gcrcg69yv73xlfp6fc7fmhlm30irm";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.136.0";
  };
  aws-sdk-s3control = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kf3i430b6lwzf7dmm506jvm7xy0rj4zhc9kywcg4rc1fp0bmzh3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.43.0";
  };
  aws-sdk-secretsmanager = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xkx39yi2mlwyh3lyg6h39nzj5n059nc6idaqlnsjlrkkrh3i13i";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.46.0";
  };
  aws-sdk-securityhub = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pxxxr36rd3yfrnmbbi9g2sbgc55kgg4mbnvxll2q7mi0in2s38k";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.94.0";
  };
  aws-sdk-servicecatalog = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zjxbpr5jj3znrsynazcjznaqcqbfpy646nzvl3c83gcwrsqj8s7";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.60.0";
  };
  aws-sdk-ses = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xii4i4dia1w6hizfxvni8jawpikv9g26ixiw349x33l09f12cbw";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.41.0";
  };
  aws-sdk-shield = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08n16c48z0hk940jr4dy2lxhbm7vvniwnc2q2yskgyk4vr3jpfd1";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.58.0";
  };
  aws-sdk-signer = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ysspl6n2rw5hr3bz38k46k04nkbri0c54fc109kgw57fxfwq3fk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.32.0";
  };
  aws-sdk-simpledb = {
    dependencies = [ "aws-sdk-core" "aws-sigv2" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15vrakmbxz7pg9vf2gi8ssb6jg4k5jwrsik6x0hkjf3n4g3vfgqs";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.29.0";
  };
  aws-sdk-sms = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0insv746srjma85wvxdz7rh2agp0cxfg96qmhwcsy4ccfaxsfjpx";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.50.0";
  };
  aws-sdk-sns = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ql5gzrqrpkr8w2yjihy296b1qcv4w4pwydg28kjaxny60spig69";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.67.0";
  };
  aws-sdk-sqs = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02wv7kj0dipqxmqckwhd8l7ydm2c8s9l3pw8f4vgm3wr4wgqbw1y";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.64.0";
  };
  aws-sdk-ssm = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r0l3w4s1b3w21q6hs4qsbac56vc82pavxrxvrkr7w5lybhz7n79";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.158.0";
  };
  aws-sdk-states = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00ja9hkx4rdgd0242l8vmbfmb1qgvys3xs2ryap3ms3qaa76sach";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.39.0";
  };
  aws-sdk-synthetics = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10zh51r45pzbnx8fxjz8pppwlgbzpbvs4kaji1mi53cwpfprlhsz";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.19.0";
  };
  aws-sdk-transfer = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "087y19nzkh26a7rac5ci7d792mdjfwg1mfm884r118g89y4imcdf";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.73.0";
  };
  aws-sdk-waf = {
    dependencies = [ "aws-sdk-core" "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "036655pbqkvzwd05svimvn2v96srz370zmhczg1jzsca0249hxfr";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.43.0";
  };
  aws-sigv2 = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bnsw26vd0z3gayrqxhjg94ccjdygpk00bmhdjhzagmgngmdbhrk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z889c4c1w7wsjm3szg64ay5j51kjl4pdf94nlr1yks2rlanm7na";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.6.0";
  };
  azure_graph_rbac = {
    dependencies = [ "ms_rest_azure" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mmx8jp85xa13j3asa9xnfi6wa8a9wwlp0hz0nj70fi3ydmcpdag";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.17.2";
  };
  azure_mgmt_key_vault = {
    dependencies = [ "ms_rest_azure" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f4fai5l3453yirrwajds0jgah60gvawffx53a0jyv3b93ag88mz";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.17.7";
  };
  azure_mgmt_resources = {
    dependencies = [ "ms_rest_azure" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p4hsa7xha8ifml58hmkxdkp7vyhm7sw624xam1mrq0hvzawvkm3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.18.2";
  };
  azure_mgmt_security = {
    dependencies = [ "ms_rest_azure" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11h2dyz4awzidvfj41h7k2q7mcqqcgzvm95fxpfxz609pbvck0g2";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.19.0";
  };
  azure_mgmt_storage = {
    dependencies = [ "ms_rest_azure" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ik06knz7fxn9q2x874d7q1v2fb00askwh36wbl75fnsi2m5m6rq";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.23.0";
  };
  base64 = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cydk9p2cv25qysm0sn2pb97fcpz1isa7n3c8xm1gd99li8x6x8c";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.1.1";
  };
  bcrypt_pbkdf = {
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ndamfaivnkhc6hy0yqyk2gkwr6f3bz6216lh74hsiiyk3axz445";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.0";
  };
  berkshelf = {
    dependencies = [ "chef" "chef-config" "cleanroom" "concurrent-ruby" "minitar" "mixlib-archive" "mixlib-config" "mixlib-shellout" "octokit" "retryable" "solve" "thor" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n35byk6bwqjhb0xa44bbgz3flb0hbgf9bkass86ihkfi43a4k1q";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "8.0.9";
  };
  bigdecimal = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07y615s8yldk3k13lmkhpk1k190lcqvmxmnjwgh4bzjan9xrc36y";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.1.4";
  };
  binding_of_caller = {
    dependencies = [ "debug_inspector" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "078n2dkpgsivcf0pr50981w95nfc2bsrp3wpf9wnxz1qsp8jbb9s";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.0";
  };
  bson = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19vgs9rzzyvd7jfrzynjnc6518q0ffpfciyicfywbp77zl8nc9hk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "4.15.0";
  };
  builder = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.2.4";
  };
  byebug = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nx3yjf4xzdgb8jkmk2344081gqr22pgjqnmjg2q64mj5d6r9194";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "11.1.3";
  };
  chef = {
    dependencies = [ "addressable" "aws-sdk-s3" "aws-sdk-secretsmanager" "chef-config" "chef-utils" "chef-vault" "chef-zero" "corefoundation" "diff-lcs" "erubis" "ffi" "ffi-libarchive" "ffi-yajl" "iniparse" "inspec-core" "license-acceptance" "mixlib-archive" "mixlib-authentication" "mixlib-cli" "mixlib-log" "mixlib-shellout" "net-ftp" "net-sftp" "ohai" "plist" "proxifier2" "syslog-logger" "train-core" "train-rest" "train-winrm" "unf_ext" "uuidtools" "vault" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iafkrjiwkrv3mn420byr96y3g8ik4bqbfms3yqvhyfjx1c2z6fz";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "18.3.0";
  };
  chef-apply = {
    dependencies = [ "chef" "chef-cli" "chef-telemetry" "license-acceptance" "mixlib-cli" "mixlib-config" "mixlib-install" "mixlib-log" "pastel" "r18n-desktop" "toml-rb" "train-core" "train-winrm" "tty-spinner" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06ps1r07kzzbyrlxz9g53q62ycig5bf8qpvxs9fl2kw2gmqr075c";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.9.6";
  };
  chef-bin = {
    dependencies = [ "chef" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jgckljj72d1h6id7libw42v4g6pi5azwcagl9xbbp4fdg1f2jkx";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "18.3.0";
  };
  chef-cli = {
    dependencies = [ "addressable" "chef" "cookbook-omnifetch" "diff-lcs" "ffi-yajl" "license-acceptance" "minitar" "mixlib-cli" "mixlib-shellout" "pastel" "solve" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jxyv1020y041lx0zsmc3hnrrrycrs1jy9c1j1zhqkkaqw0yjnsi";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "5.6.14";
  };
  chef-config = {
    dependencies = [ "addressable" "chef-utils" "fuzzyurl" "mixlib-config" "mixlib-shellout" "tomlrb" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pvjf3qbb3apg9vdy4zykamm7801qz4m6256wjqn73fs87zs50y1";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "18.3.0";
  };
  chef-telemetry = {
    dependencies = [ "chef-config" "concurrent-ruby" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l9icc3nfdj28mip85vf31v5l60qsfqq3a5dscv7jryh1k94y05x";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.1";
  };
  chef-utils = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0087jwhqslfm3ygj507dmmdp3k0589j5jl54mkwgbabbwan7lzw2";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "18.3.0";
  };
  chef-vault = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hnvngygbdpvpflls3png2312y1svh6k9wj7g5i084q4p72qv22i";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "4.1.11";
  };
  chef-zero = {
    dependencies = [ "ffi-yajl" "hashie" "mixlib-log" "rack" "uuidtools" "webrick" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l20bljvh0imfraxx3mbq08sf9rwxkbl7rl9rsjzfynz53ch2sv5";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "15.0.11";
  };
  chef_deprecations = {
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1laacczg962ph6pcr9fn7afgh6hyf4mhkyir4c1n01jq0pxhg8vm";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.0";
  };
  cheffish = {
    dependencies = [ "chef-utils" "chef-zero" "net-ssh" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mdcysbzphhm03qdqhrf669jzh5kdykkbpv3k3xcgldpkjs4nk8l";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "17.1.5";
  };
  chefspec = {
    dependencies = [ "chef" "chef-cli" "rspec" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vx7x51w01yf4r4nilm7alk4qpm9dpyb6mmid2w7nik6zg21b2h7";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "9.3.6";
  };
  chefstyle = {
    dependencies = [ "rubocop" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jsszysayv6sqdby977b7a4mwx1d2m0z6mx47jq7w60943290ckg";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.2.2";
  };
  citrus = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l7nhk3gkm1hdchkzzhg2f70m47pc0afxfpl6mkiibc9qcpl3hjf";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.0.2";
  };
  cleanroom = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1r6qa4b248jasv34vh7rw91pm61gzf8g5dvwx2gxrshjs7vbhfml";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.0";
  };
  coderay = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.3";
  };
  concurrent-ruby = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.2.2";
  };
  connection_pool = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x32mcpm2cl5492kd6lbjbaf17qsssmpx9kdyr7z1wcif2cwyh0g";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.4.1";
  };
  cookbook-omnifetch = {
    dependencies = [ "mixlib-archive" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gqh66p6fxg438qpvc67s0y7ji9mvan6layyd7w9ljwva1snvy2n";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.12.2";
  };
  cookstyle = {
    dependencies = [ "rubocop" ];
    groups = [ "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0np0y94x1rgn13bwkd4hc5ysimn9ax57ihrpz5rl4fwrn3lybm1s";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "7.32.2";
  };
  corefoundation = {
    dependencies = [ "ffi" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14rgy3d636l9zy7zmw04j7pjkf3bn41vx7kb265l4zhxrik7gh19";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.3.13";
  };
  date = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03skfikihpx37rc27vr3hwrb057gxnmdzxhmzd4bf4jpkl0r55w1";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.3.3";
  };
  debug_inspector = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01l678ng12rby6660pmwagmyg8nccvjfgs3487xna7ay378a59ga";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.0";
  };
  declarative = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.0.20";
  };
  dep-selector-libgecode = {
    groups = [ "dep_selector" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09frwp3np5c64y8g5rnbl46n7riknmdjprhndsh6zzajkjr9m3xj";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3.5";
  };
  dep_selector = {
    dependencies = [ "dep-selector-libgecode" "ffi" ];
    groups = [ "dep_selector" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fkh56srml6346rg4h0zssbgx3bjx1vhgv71y9rhw1iqb6p05dqg";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.6";
  };
  diff-lcs = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3";
  };
  docker-api = {
    dependencies = [ "excon" "multi_json" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g7dbniz15b3l2sy6xh0j0998dr5jypf3xg3bsygp0108vv7waxy";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.2.0";
  };
  domain_name = {
    dependencies = [ "unf" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lcqjsmixjp52bnlgzh4lg9ppsk52x9hpwdjd53k8jnbah2602h0";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.5.20190701";
  };
  drb = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h9c2qiam82y3caapa2x157j1lkk9954hrjg3p22hxcsk8fli3vb";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.1.1";
  };
  dry-configurable = {
    dependencies = [ "concurrent-ruby" "dry-core" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qzq7aaw020qq06d2lpjq03a3gqnkyya040fjgyfp5q3dlr9c44v";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.13.0";
  };
  dry-container = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aaj0ffwkbdagrry127x1gd4m6am88mhhfzi7czk8isdcj0r7gi3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.11.0";
  };
  dry-core = {
    dependencies = [ "concurrent-ruby" "zeitwerk" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dpm9dk11x2zcjsymkl5jcz5nxhffsg7qqy5p6h92cppzbwmm656";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.9.1";
  };
  dry-inflector = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rw0xxx1yga8r8bwgpywgshvqwd0w6shy0s4y1qrsz0cjxfwga0i";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.3.0";
  };
  dry-logic = {
    dependencies = [ "concurrent-ruby" "dry-core" "zeitwerk" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12ikf5j5n7bhwd0mzi27ikwdr944l78sp86ndvkbqpfq607335ys";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3.0";
  };
  dry-struct = {
    dependencies = [ "dry-core" "dry-types" "ice_nine" "zeitwerk" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "177jvjlkjshv80cmy54jnfd18lryzaigd8mbm39iaigah7afhwf4";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.5.2";
  };
  dry-types = {
    dependencies = [ "concurrent-ruby" "dry-container" "dry-core" "dry-inflector" "dry-logic" "zeitwerk" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xpbh437hw16h8qxw7454vkabnq7w9g51sh4qs3z82xl8qvkhdqy";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.6.1";
  };
  ed25519 = {
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zb2dr2ihb1qiknn5iaj1ha1w9p7lj9yq5waasndlfadz225ajji";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3.0";
  };
  erubi = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08s75vs9cxlc4r1q2bjg4br8g9wc5lc5x5vl0vv4zq5ivxsdpgi7";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.12.0";
  };
  erubis = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.7.0";
  };
  excon = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "104vrqqy6bszbhpvabgz9ra7dm6lnb5jwzwqm2fks0ka44spknyl";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.104.0";
  };
  faraday = {
    dependencies = [ "faraday-em_http" "faraday-em_synchrony" "faraday-excon" "faraday-httpclient" "faraday-multipart" "faraday-net_http" "faraday-net_http_persistent" "faraday-patron" "faraday-rack" "faraday-retry" "ruby2_keywords" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c760q0ks4vj4wmaa7nh1dgvgqiwaw0mjr7v8cymy7i3ffgjxx90";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.10.3";
  };
  faraday-cookie_jar = {
    dependencies = [ "faraday" "http-cookie" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00hligx26w9wdnpgsrf0qdnqld4rdccy8ym6027h5m735mpvxjzk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.0.7";
  };
  faraday-em_http = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12cnqpbak4vhikrh2cdn94assh3yxza8rq2p9w2j34bqg5q4qgbs";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vgrbhkp83sngv6k4mii9f2s9v5lmp693hylfxp2ssfc60fas3a6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.0";
  };
  faraday-excon = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h09wkb0k0bhm6dqsd47ac601qiaah8qdzjh8gvxfd376x1chmdh";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.0";
  };
  faraday-follow_redirects = {
    dependencies = [ "faraday" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y87p3yk15bjbk0z9mf01r50lzxvp7agr56lbm9gxiz26mb9fbfr";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.3.0";
  };
  faraday-httpclient = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fyk0jd3ks7fdn8nv3spnwjpzx2lmxmg2gh4inz3by1zjzqg33sc";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.1";
  };
  faraday-multipart = {
    dependencies = [ "multipart-post" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09871c4hd7s5ws1wl4gs7js1k2wlby6v947m2bbzg43pnld044lh";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.4";
  };
  faraday-net_http = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fi8sda5hc54v1w3mqfl5yz09nhx35kglyx72w7b8xxvdr0cwi9j";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.1";
  };
  faraday-net_http_persistent = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dc36ih95qw3rlccffcb0vgxjhmipsvxhn6cw71l7ffs0f7vq30b";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.2.0";
  };
  faraday-patron = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19wgsgfq0xkski1g7m96snv39la3zxz6x7nbdgiwhg5v82rxfb6w";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.0";
  };
  faraday-rack = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h184g4vqql5jv9s9im6igy00jp6mrah2h14py6mpf9bkabfqq7g";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.0";
  };
  faraday-retry = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "153i967yrwnswqgvnnajgwp981k9p50ys1h80yz3q94rygs59ldd";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.3";
  };
  faraday_middleware = {
    dependencies = [ "faraday" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jik2kgfinwnfi6fpp512vlvs0mlggign3gkbpkg5fw1jr9his0r";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.0";
  };
  fauxhai-chef = {
    dependencies = [ "net-ssh" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a30ky24q25jbqp71fb7j12h2il0xpw24aii8z83i7nxxjv2wys5";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "9.3.8";
  };
  ffi = {
    groups = [ "default" "dep_selector" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yvii03hcgqj30maavddqamqy50h7y6xcn2wcyq72wn823zl4ckd";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.16.3";
  };
  ffi-libarchive = {
    dependencies = [ "ffi" ];
    groups = [ "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vxvvyah5f2gmflzks16bj3fqrj4fagn6sxhslwdxm8agf95lz6f";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.13";
  };
  ffi-yajl = {
    dependencies = [ "libyajl2" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dj3y95260rvlclkkcxak6c1dsrzbyr4wik7jv3y949r4w9adfk9";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.6.0";
  };
  fog-core = {
    dependencies = [ "builder" "excon" "formatador" "mime-types" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06m6hxq8vspx9h9bgc2s19m56jzasvl45vblrfv1q5h1qg1k6amw";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.3.0";
  };
  fog-json = {
    dependencies = [ "fog-core" "multi_json" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zj8llzc119zafbmfa4ai3z5s7c4vp9akfs0f9l2piyvcarmlkyx";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.2.0";
  };
  fog-openstack = {
    dependencies = [ "fog-core" "fog-json" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xh9qs00l1d7rxsr9qjlba8dprh9km8ya06y59qf17vncihl1xa7";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.0";
  };
  formatador = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l06bv4avphbdmr1y4g0rqlczr38k6r65b3zghrbj2ynyhm3xqjl";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.0";
  };
  fuzzyurl = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03qchs33vfwbsv5awxg3acfmlcrf5xbhnbrc83fdpamwya0glbjl";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.9.0";
  };
  gcewinpass = {
    dependencies = [ "google-api-client" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sm8c1x0mhg7c346gq20p9jdws4q823y4r6xld9qqyxv45kq1ck4";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.0";
  };
  google-api-client = {
    dependencies = [ "addressable" "googleauth" "httpclient" "mini_mime" "representable" "retriable" "rexml" "signet" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q1lsyyyfvff7727sr01j8qx6b30qpx6h0bna5s0bfz853fhl33b";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.52.0";
  };
  googleauth = {
    dependencies = [ "faraday" "jwt" "memoist" "multi_json" "os" "signet" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cm60nbmwzf83fzy06f3iyn5a6sw91siw8x9bdvpwwmjsmivana6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.14.0";
  };
  gssapi = {
    dependencies = [ "ffi" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qdfhj12aq8v0y961v4xv96a1y2z80h3xhvzrs9vsfgf884g6765";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3.1";
  };
  guard = {
    dependencies = [ "formatador" "listen" "lumberjack" "nenv" "notiffany" "pry" "shellany" "thor" ];
    groups = [ "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02bwv3396cqsn980a3yzh6l3xm8f7rqjfnphssrajf6m4cxkv2d3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.18.1";
  };
  gyoku = {
    dependencies = [ "builder" "rexml" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kd2q59xpm39hpvmmvyi6g3f1fr05xjbnxwkrdqz4xy7hirqi79q";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.4.0";
  };
  hashdiff = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nynpl0xbj0nphqx1qlmyggq58ms1phf5i03hk64wcc0a17x1m1c";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.1";
  };
  hashie = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02bsx12ihl78x0vdm37byp78jjw2ff6035y7rrmbd90qxjwxr43q";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "4.1.0";
  };
  highline = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1f8cr014j7mdqpdb9q17fp5vb5b8n1pswqaif91s3ylg5x3pygfn";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.1.0";
  };
  http-accept = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09m1facypsdjynfwrcv19xcb1mqg8z6kk31g8r33pfxzh838c9n6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.7.0";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13rilvlv8kwbzqfb644qp6hrbsj82cbqmnzcvqip1p6vqx36sxbk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.5";
  };
  httpclient = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.8.3";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qaamqsh5f3szhcakkak8ikxlzxqnv49n2p7504hcz2l0f4nj0wx";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.14.1";
  };
  ice_nine = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.11.2";
  };
  inifile = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c5zmk7ia63yw5l2k14qhfdydxwi1sah1ppjdiicr4zcalvfn0xi";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.0.0";
  };
  iniparse = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wb1qy4i2xrrd92dc34pi7q7ibrjpapzk9y465v0n9caiplnb89n";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.5.0";
  };
  inspec = {
    dependencies = [ "cookstyle" "faraday_middleware" "inspec-core" "mongo" "progress_bar" "rake" "train" "train-aws" "train-habitat" "train-kubernetes" "train-winrm" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x0800iwkzb9jchys88p6csi728akbkp3lxviaq5wqjx8kjqyy8v";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "5.22.3";
  };
  inspec-bin = {
    dependencies = [ "inspec" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vfmzawc0bh0kqkf2nz1dyn4vhp4y4pifqasnm88c7dgxi3sifns";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "5.22.3";
  };
  inspec-core = {
    dependencies = [ "addressable" "chef-telemetry" "faraday" "faraday-follow_redirects" "hashie" "license-acceptance" "method_source" "mixlib-log" "multipart-post" "parallel" "parslet" "pry" "rspec" "rspec-its" "rubyzip" "semverse" "sslshake" "thor" "tomlrb" "train-core" "tty-prompt" "tty-table" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q0r74h9i2x6697df6cd3fpm69raqsigw6m6vr5jy6w9ip50vdvk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "5.22.3";
  };
  ipaddress = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x86s0s11w202j6ka40jbmywkrx8fhq8xiy8mwvnkhllj57hqr45";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.8.3";
  };
  jmespath = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.6.2";
  };
  json = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nalhin1gda4v8ybk6lq8f407cgfrj6qzn234yra4ipkmlbfmal6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.6.3";
  };
  jsonpath = {
    dependencies = [ "multi_json" "to_regexp" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zim5bl7zsbccd502iy63f7c3b6dw0a820z7q8kpv66hncavb7gp";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.9.9";
  };
  jwt = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16z11alz13vfc4zs5l3fk6n51n2jw9lskvc4h4prnww0y797qd87";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.7.1";
  };
  k8s-ruby = {
    dependencies = [ "dry-configurable" "dry-struct" "dry-types" "excon" "hashdiff" "jsonpath" "recursive-open-struct" "yajl-ruby" "yaml-safe_load_stream3" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09q2lxwcsdmnqi91c62gc89bvwlq0arn5nvrl6g1whg46zvmis5z";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.14.0";
  };
  kitchen-dokken = {
    dependencies = [ "docker-api" "lockfile" "test-kitchen" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x6fyqgsa8jzipkiig0w7bp4mfz7p59lk8cw4n0mfhyn91f91l08";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.19.1";
  };
  kitchen-google = {
    dependencies = [ "gcewinpass" "google-api-client" "test-kitchen" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12zfndcj8bzrwfmmjn3rcjan70ds9r6lyz47f2gckbmszf6g3sjj";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.4.0";
  };
  kitchen-inspec = {
    dependencies = [ "hashie" "inspec" "test-kitchen" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08cpy9zm1i60w8i4hnwnhjz2hghwxjxkal1qz8nfyimhn26dvb7k";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.6.2";
  };
  kitchen-openstack = {
    dependencies = [ "fog-openstack" "ohai" "test-kitchen" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gq3101fqpsjiincqaf8lsldwh2ymz0y2hw14vymj09sa9cls9rl";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "6.2.0";
  };
  knife = {
    dependencies = [ "bcrypt_pbkdf" "chef" "chef-config" "chef-utils" "chef-vault" "erubis" "ffi" "ffi-yajl" "highline" "license-acceptance" "mixlib-archive" "mixlib-cli" "net-ssh" "net-ssh-multi" "ohai" "pastel" "proxifier2" "train-core" "train-winrm" "tty-prompt" "tty-screen" "tty-table" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09d20rqajdnq0rilph2arjfk3h5b59rxdb5hzn7xw8fr1sa7hi3v";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "18.3.0";
  };
  kramdown = {
    dependencies = [ "rexml" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ic14hdcqxn821dvzki99zhmcy130yhv5fqfffkcf87asv5mnbmn";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.4.0";
  };
  kramdown-parser-gfm = {
    dependencies = [ "kramdown" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a8pb3v951f4x7h968rqfsa19c8arz21zw1vaj42jza22rap8fgv";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.0";
  };
  libyajl2 = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vx0mv0bbcy0qh3ik08b42vrq4kw1zg51121r18c0vvp4p3zcpda";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.1.0";
  };
  license-acceptance = {
    dependencies = [ "pastel" "tomlrb" "tty-box" "tty-prompt" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12h5a3j57h50xkfpdz9gr42k0v8g1qxn2pnj5hbbzbmdhydjbjzf";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.1.13";
  };
  listen = {
    dependencies = [ "rb-fsevent" "rb-inotify" ];
    groups = [ "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13rgkfar8pp31z1aamxf5y7cfq88wv6rxxcwy7cmm177qq508ycn";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.8.0";
  };
  little-plugger = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.4";
  };
  lockfile = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dij3ijywylvfgrpi2i0k17f6w0wjhnjjw0k9030f54z56cz7jrr";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.1.3";
  };
  logging = {
    dependencies = [ "little-plugger" "multi_json" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zflchpx4g8c110gjdcs540bk5a336nq6nmx379rdg56xw0pjd02";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.3.1";
  };
  lumberjack = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p43330qzn4r0rg2955g6g3xxd26y0k3nxajcwrymqm26rpiacp8";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.2.9";
  };
  mdl = {
    dependencies = [ "kramdown" "kramdown-parser-gfm" "mixlib-cli" "mixlib-config" "mixlib-shellout" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a463jx8v4a3lgmmfalq73c337d66hc21q4vnfar1qf4lhk5wyi0";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.13.0";
  };
  memoist = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i9wpzix3sjhf6d9zw60dm4371iq8kyz7ckh2qapan2vyaim6b55";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.16.2";
  };
  method_source = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.0";
  };
  mime-types = {
    dependencies = [ "mime-types-data" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q8d881k1b3rbsfcdi3fx0b5vpdr5wcrhn88r2d9j7zjdkxp5mw5";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.5.1";
  };
  mime-types-data = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yjv0apysnrhbc70ralinfpcqn9382lxr643swp7a5sdwpa9cyqg";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.2023.1003";
  };
  mini_mime = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.5";
  };
  minitar = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "126mq86x67d1p63acrfka4zx0cx2r0vc93884jggxnrmmnzbxh13";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.9";
  };
  minitest = {
    groups = [ "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bkmfi9mb49m0fkdhl2g38i3xxa02d411gg0m8x0gvbwfmmg5ym3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "5.20.0";
  };
  mixlib-archive = {
    dependencies = [ "mixlib-log" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17vw0h8ag45608hvm02g43bkfvqy8l3lwk9lqj7b5kzdw6ynvn6a";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.7";
  };
  mixlib-authentication = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07m6q8icjjzrv7k2vsjqmviswqv6cigc577hf48liy7b1i4l9gn5";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.0.10";
  };
  mixlib-cli = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ydxlfgd7nnj3rp1y70k4yk96xz5cywldjii2zbnw3sq9pippwp6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.1.8";
  };
  mixlib-config = {
    dependencies = [ "tomlrb" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j0122lv2qgccl61njqi0pj6sp6nb85y07gcmw16bwg4k0c8nx6p";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.0.27";
  };
  mixlib-install = {
    dependencies = [ "mixlib-shellout" "mixlib-versioning" "thor" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ma2hcz22ryqgwaxqf553yh3ixqa39jri1xnk39ikw3zr0ck0gwr";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.12.27";
  };
  mixlib-log = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n5dm5iz90ijvjn59jfm8gb8hgsvbj0f1kpzbl38b02z0z4a4v7x";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.0.9";
  };
  mixlib-shellout = {
    dependencies = [ "chef-utils" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zkwg76y96nkh1mv0k92ybq46cr06v1wmic16129ls3yqzwx3xj6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.2.7";
  };
  mixlib-versioning = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cqyrcgw2xwxmjhwa31ipmphkg5aa6x4fd5c5j9y7hifw32pb1vr";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.2.12";
  };
  molinillo = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p846facmh1j5xmbrpgzadflspvk7bzs3sykrh5s7qi4cdqz5gzg";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.8.0";
  };
  mongo = {
    dependencies = [ "bson" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mkksik7mffwm29dz0pxjfz87rmm578nqzg8bc4kp076xqjwn2xp";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.13.2";
  };
  ms_rest = {
    dependencies = [ "concurrent-ruby" "faraday" "timeliness" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jiha1bda5knpjqjymwik6i41n69gb0phcrgvmgc5icl4mcisai7";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.7.6";
  };
  ms_rest_azure = {
    dependencies = [ "concurrent-ruby" "faraday" "faraday-cookie_jar" "ms_rest" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06i37b84r2q206kfm5vsi9s1qiiy09091vhvc5pzb7320h0hc1ih";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.12.0";
  };
  multi_json = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.15.0";
  };
  multipart-post = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lgyysrpl50wgcb9ahg29i4p01z0irb3p9lirygma0kkfr5dgk9x";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.3.0";
  };
  mutex_m = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pkxnp7p44kvs460bbbgjarr7xy1j8kjjmhwkg1kypj9wgmwb6qa";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.1.2";
  };
  nenv = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r97jzknll9bhd8yyg2bngnnkj8rjhal667n7d32h8h7ny7nvpnr";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.3.0";
  };
  net-ftp = {
    dependencies = [ "net-protocol" "time" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bqy9xg5225x102873j1qqq1bvnwfbi8lnf4357mpq6wimnw9pf9";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.0";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dxckrlw4q1lcn3qg4mimmjazmg9bma5gllv72f8js3p36fb3b91";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.1";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1si2nq9l6jy5n2zw1q59a5gaji7v9vhy8qx08h4fg368906ysbdk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "4.0.0";
  };
  net-sftp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r33aa2d61hv1psm0l0mm6ik3ycsnq8symv7h84kpyf2b7493fv5";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "4.0.0";
  };
  net-ssh = {
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jyj6j7w9zpj2zhp4dyhdjiwsn9rqwksj7s7fzpnn7rx2xvz2a1a";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "7.2.0";
  };
  net-ssh-gateway = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l3v761y32aw0n8lm0c0m42lr4ay8cq6q4sc5yc68b9fwlfvb70x";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.0.0";
  };
  net-ssh-multi = {
    dependencies = [ "net-ssh" "net-ssh-gateway" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13kxz9b6kgr9mcds44zpavbndxyi6pvyzyda6bhk1kfmb5c10m71";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.2.1";
  };
  netrc = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.11.0";
  };
  nokogiri = {
    dependencies = [ "racc" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = null;
    targets = [{
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hhqzm7p4lww7v3i33im26bmiryfqr0p3iknbadyv5ypf8yysb47";
      target = "x86_64-linux";
      targetCPU = "x86_64";
      targetOS = "linux";
      type = "gem";
    }
      {
        remotes = [ "https://rubygems.org" ];
        sha256 = "1f2a532j8hbz2f0d3ixnx156b9rgfgnmqz9z450a8ibhw03il28l";
        target = "aarch64-linux";
        targetCPU = "aarch64";
        targetOS = "linux";
        type = "gem";
      }];
    version = "1.15.4";
  };
  nori = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "066wc774a2zp4vrq3k7k8p0fhv30ymqmxma1jj7yg5735zls8agn";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.6.0";
  };
  notiffany = {
    dependencies = [ "nenv" "shellany" ];
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f47h3bmg1apr4x51szqfv3rh2vq58z3grh4w02cp3bzbdh6jxnk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.1.3";
  };
  octokit = {
    dependencies = [ "faraday" "sawyer" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15lvy06h276jryxg19258b2yqaykf0567sp0n16yipywhbp94860";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "4.25.1";
  };
  ohai = {
    dependencies = [ "chef-config" "chef-utils" "ffi" "ffi-yajl" "ipaddress" "mixlib-cli" "mixlib-config" "mixlib-log" "mixlib-shellout" "plist" "train-core" "wmi-lite" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15fz0ws8q9635rl5y4jyiwxbibr9ilba4askazhrgy4pcmmgs34q";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "18.1.3";
  };
  options = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s650nwnabx66w584m1cyw82icyym6hv5kzfsbp38cinkr5klh9j";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.3.2";
  };
  os = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gwd20smyhxbm687vdikfh1gpi96h8qb1x28s2pdcysf6dm6v0ap";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.4";
  };
  parallel = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jcc512l38c0c163ni3jgskvq1vc3mr8ly5pvjijzwvfml9lf597";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.23.0";
  };
  parser = {
    dependencies = [ "ast" "racc" ];
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r69dbh6h6j4d54isany2ir4ni4gf2ysvk3k44awi6amz18nggpd";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.2.2.4";
  };
  parslet = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12nrzfwjphjlakb9pmpj70hgjwgzvnr8i1zfzddifgyd44vspl88";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.8.2";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xash2gj08dfjvq4hy6l1z22s5v30fhizwgs10d6nviggpxsj7a8";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.8.0";
  };
  plist = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wzhnbzraz60paxhm48c50fp9xi7cqka4gfhxmiq43mhgh5ajg3h";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.7.0";
  };
  progress_bar = {
    dependencies = [ "highline" "options" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04kv6h5mdjd9zf8mcf2dplxls06n2jf72281s74k6b2ar731hc47";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3.3";
  };
  proxifier2 = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cmk01qdk3naa86grjd5arf6xxy9axf5y6a0sqm7zis9lr4d43h3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.0";
  };
  pry = {
    dependencies = [ "coderay" "method_source" ];
    groups = [ "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lgvnhnwgji1d30vpwlsydk2sabv5azigq9nlfjp0nc4f6wdkdvl";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.13.0";
  };
  pry-byebug = {
    dependencies = [ "byebug" "pry" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1y41al94ks07166qbp2200yzyr5y60hm7xaiw4lxpgsm4b1pbyf8";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.10.1";
  };
  pry-remote = {
    dependencies = [ "pry" "slop" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10g1wrkcy5v5qyg9fpw1cag6g5rlcl1i66kn00r7kwqkzrdhd7nm";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.1.8";
  };
  pry-stack_explorer = {
    dependencies = [ "binding_of_caller" "pry" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h7kp99r8vpvpbvia079i58932qjz2ci9qhwbk7h1bf48ydymnx2";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.6.1";
  };
  public_suffix = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n9j7mczl15r3kwqrah09cxj8hxdfawiqxa60kga2bmxl9flfz9k";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "5.0.3";
  };
  r18n-core = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0438li8g5jvj3mmjigdiglnpjdnhxvn5dd7n1dxmrp4i0a74akis";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "5.0.1";
  };
  r18n-desktop = {
    dependencies = [ "r18n-core" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nacclz89dv7n2gkb4jwkqgas6lk24mb1g905qcps2n89wylmhin";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "5.0.1";
  };
  racc = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11v3l46mwnlzlc371wr3x6yylpgafgwdf0q7hc7c1lzx6r414r5g";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.7.1";
  };
  rack = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15rdwbyk71c9nxvd527bvb8jxkcys8r3dj3vqra5b3sa63qs30vv";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.2.8";
  };
  rainbow = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.1.1";
  };
  rake = {
    groups = [ "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w6qza25bq1s825faaglkx1k6d59aiyjjk3yw3ip5sb463mhhai9";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "13.0.1";
  };
  rb-fsevent = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jm76h8f8hji38z3ggf4bzi8vps6p7sagxn3ab57qc0xyga64005";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.10.1";
  };
  rb-readline = {
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14w79a121czmvk1s953qfzww30mqjb2zc0k9qhi0ivxxk3hxg6wy";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.5.5";
  };
  recursive-open-struct = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nnyr6qsqrcszf6c10n4zfjs8h9n67zvsmx6mp8brkigamr8llx3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.1.3";
  };
  regexp_parser = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d9a5s3qrjdy50ll2s32gg3qmf10ryp3v2nr5k718kvfadp50ray";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.8.2";
  };
  representable = {
    dependencies = [ "declarative" "trailblazer-option" "uber" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kms3r6w6pnryysnaqqa9fsn0v73zx1ilds9d1c565n3xdzbyafc";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.2.0";
  };
  rest-client = {
    dependencies = [ "http-accept" "http-cookie" "mime-types" "netrc" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qs74yzl58agzx9dgjhcpgmzfn61fqkk33k1js2y5yhlvc5l19im";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.1.0";
  };
  retriable = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.1.2";
  };
  retryable = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pymcs9fqcnz6n6h033yfp0agg6y2s258crzig05kkxs6rldvwy9";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.0.5";
  };
  rexml = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05i8518ay14kjbma550mv0jm8a6di8yp5phzrd8rj44z9qnrlrp0";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.2.6";
  };
  rspec = {
    dependencies = [ "rspec-core" "rspec-expectations" "rspec-mocks" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19dyb6rcvgi9j2mksd29wfdhfdyzqk7yjhy1ai77559hbhpg61w9";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.11.0";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "118hkfw9b11hvvalr7qlylwal5h8dihagm9xg7k4gskg7587hca6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.11.0";
  };
  rspec-expectations = {
    dependencies = [ "diff-lcs" "rspec-support" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l1bzk6a68i1b2qix83vs40r0pbjawv67hixiq2qxsja19bbq3bc";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.11.1";
  };
  rspec-its = {
    dependencies = [ "rspec-core" "rspec-expectations" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15zafd70gxly5i0s00nky14sj2n92dnj3xpj83ysl3c2wx0119ad";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3.0";
  };
  rspec-mocks = {
    dependencies = [ "diff-lcs" "rspec-support" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vsqp9dij2rj9aapcn3sz7qzw0d8ln7x9p46h9rzd3jzb7his9kk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.11.2";
  };
  rspec-support = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1c01iicvrjk6vv744jgh0y4kk9d0kg2rd2ihdyzvg5p06xm2fpzq";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.11.1";
  };
  rubocop = {
    dependencies = [ "parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width" ];
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l3q96il8zx5zl041lxvmfrndxxpk08fksza1gqshhjjzms7c2rk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.25.1";
  };
  rubocop-ast = {
    dependencies = [ "parser" ];
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "188bs225kkhrb17dsf3likdahs2p1i1sqn0pr3pvlx50g6r2mnni";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.29.0";
  };
  ruby-progressbar = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.13.0";
  };
  ruby-shadow = {
    groups = [ "ruby_shadow" ];
    platforms = [{
      engine = "maglev";
    }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }];
    source = {
      fetchSubmodules = false;
      rev = "3b8ea40b0e943b5de721d956741308ce805a5c3c";
      sha256 = "0v0q9f5zxfhajaa52va5czpzpf4p8d05777l414lgyrdiklllgd5";
      type = "git";
      url = "https://github.com/chef/ruby-shadow";
    };
    targets = [ ];
    version = "2.5.0";
  };
  ruby2_keywords = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.0.5";
  };
  rubyntlm = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b8hczk8hysv53ncsqzx4q6kma5gy5lqc7s5yx8h64x3vdb18cjv";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.6.3";
  };
  rubyzip = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0grps9197qyxakbpw02pda59v45lfgbgiyw48i0mq9f2bn9y6mrz";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.3.2";
  };
  sawyer = {
    dependencies = [ "addressable" "faraday" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jks1qjbmqm8f9kvwa81vqj39avaj9wdnzc531xm29a55bb74fps";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.9.2";
  };
  semverse = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vrh6p0756n3gjnk6am1cc4kmw6wzzd02hcajj27rlsqg3p6lwn9";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.0.2";
  };
  shellany = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ryyzrj1kxmnpdzhlv4ys3dnl2r5r3d2rs2jwzbnd1v96a8pl4hf";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.0.1";
  };
  signet = {
    dependencies = [ "addressable" "faraday" "jwt" "multi_json" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fzakk5y7zzii76zlkynpp1c764mzkkfg4mpj18f5pf2xp1aikb6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.18.0";
  };
  slop = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.6.0";
  };
  solve = {
    dependencies = [ "molinillo" "semverse" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "059lrsf40rl5kclp1w8pb0fzz5sv8aikg073cwcvn5mndk14ayky";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "4.0.4";
  };
  sslshake = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r3ifksx8a05yqhv7nc4cwan8bwmxgq5kyv7q7hy2h9lv5zcjs8h";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3.1";
  };
  strings = {
    dependencies = [ "strings-ansi" "unicode-display_width" "unicode_utils" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yynb0qhhhplmpzavfrrlwdnd1rh7rkwzcs4xf0mpy2wr6rr6clk";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.1";
  };
  strings-ansi = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "120wa6yjc63b84lprglc52f40hx3fx920n4dmv14rad41rv2s9lh";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.0";
  };
  syslog-logger = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14y20phq1khdla4z9wvf98k7j3x6n0rjgs4f7vb0xlf7h53g6hbm";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.6.8";
  };
  test-kitchen = {
    dependencies = [ "bcrypt_pbkdf" "chef-utils" "ed25519" "license-acceptance" "mixlib-install" "mixlib-shellout" "net-scp" "net-ssh" "net-ssh-gateway" "thor" "winrm" "winrm-elevated" "winrm-fs" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00gy0j39i4qncgcgy3y29h9f96ylpy3zrylny459ihn4s3p6pj79";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.5.0";
  };
  thor = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k7j2wn14h1pl4smibasw0bp66kg626drxb59z7rzflch99cd4rg";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.2.2";
  };
  time = {
    dependencies = [ "date" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13pzdsgf3v06mymzipcpa7p80shyw328ybn775nzpnhc6n8y9g30";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.2";
  };
  timeliness = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gvp9b7yn4pykn794cibylc9ys1lw7fzv7djx1433icxw4y26my3";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.3.10";
  };
  timeout = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d9cvm0f4zdpwa795v3zv4973y5zk59j7s1x3yn90jjrhcz1yvfd";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.4.0";
  };
  to_regexp = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rgabfhnql6l4fx09mmj5d0vza924iczqf2blmn82l782b6qqi9v";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.1";
  };
  toml-rb = {
    dependencies = [ "citrus" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19nr4wr5accc6l2y3avn7b02lqmk9035zxq42234k7fcqd5cbqm1";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.2.0";
  };
  tomlrb = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00x5y9h4fbvrv4xrjk4cqlkm4vq8gv73ax4alj3ac2x77zsnnrk8";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3.0";
  };
  trailblazer-option = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18s48fndi2kfvrfzmq6rxvjfwad347548yby0341ixz1lhpg3r10";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.1.2";
  };
  train = {
    dependencies = [ "activesupport" "azure_graph_rbac" "azure_mgmt_key_vault" "azure_mgmt_resources" "azure_mgmt_security" "azure_mgmt_storage" "docker-api" "google-api-client" "googleauth" "inifile" "train-core" "train-winrm" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rz2x1a6za52mh12a6aqfzd0hykycd7pbx5ifiz5apcwirypma2i";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.10.8";
  };
  train-aws = {
    dependencies = [ "aws-sdk-account" "aws-sdk-alexaforbusiness" "aws-sdk-amplify" "aws-sdk-apigateway" "aws-sdk-apigatewayv2" "aws-sdk-applicationautoscaling" "aws-sdk-athena" "aws-sdk-autoscaling" "aws-sdk-batch" "aws-sdk-budgets" "aws-sdk-cloudformation" "aws-sdk-cloudfront" "aws-sdk-cloudhsm" "aws-sdk-cloudhsmv2" "aws-sdk-cloudtrail" "aws-sdk-cloudwatch" "aws-sdk-cloudwatchevents" "aws-sdk-cloudwatchlogs" "aws-sdk-codecommit" "aws-sdk-codedeploy" "aws-sdk-codepipeline" "aws-sdk-cognitoidentity" "aws-sdk-cognitoidentityprovider" "aws-sdk-configservice" "aws-sdk-core" "aws-sdk-costandusagereportservice" "aws-sdk-databasemigrationservice" "aws-sdk-dynamodb" "aws-sdk-ec2" "aws-sdk-ecr" "aws-sdk-ecrpublic" "aws-sdk-ecs" "aws-sdk-efs" "aws-sdk-eks" "aws-sdk-elasticache" "aws-sdk-elasticbeanstalk" "aws-sdk-elasticloadbalancing" "aws-sdk-elasticloadbalancingv2" "aws-sdk-elasticsearchservice" "aws-sdk-emr" "aws-sdk-eventbridge" "aws-sdk-firehose" "aws-sdk-glue" "aws-sdk-guardduty" "aws-sdk-iam" "aws-sdk-kafka" "aws-sdk-kinesis" "aws-sdk-kms" "aws-sdk-lambda" "aws-sdk-mq" "aws-sdk-networkfirewall" "aws-sdk-networkmanager" "aws-sdk-organizations" "aws-sdk-ram" "aws-sdk-rds" "aws-sdk-redshift" "aws-sdk-route53" "aws-sdk-route53domains" "aws-sdk-route53resolver" "aws-sdk-s3" "aws-sdk-s3control" "aws-sdk-secretsmanager" "aws-sdk-securityhub" "aws-sdk-servicecatalog" "aws-sdk-ses" "aws-sdk-shield" "aws-sdk-signer" "aws-sdk-simpledb" "aws-sdk-sms" "aws-sdk-sns" "aws-sdk-sqs" "aws-sdk-ssm" "aws-sdk-states" "aws-sdk-synthetics" "aws-sdk-transfer" "aws-sdk-waf" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b0p6ig4dfd2y1cfwdlzxj7wsbllwyzxd1wg87z1vs78v892ip5n";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.36";
  };
  train-core = {
    dependencies = [ "addressable" "ffi" "json" "mixlib-shellout" "net-scp" "net-ssh" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fr2hydxs1rzmi7c1c1wcfi0m2piks3vl8hdhh8rpgjz041dm4w4";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "3.10.8";
  };
  train-habitat = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qdi2q5djzfl6x3fv2vrvybjdvrnx53nfh4vzrcl2h7nrf801n6v";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.22";
  };
  train-kubernetes = {
    dependencies = [ "k8s-ruby" "train" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02gy54pybd53hbaay1kllk269pjwbjzfr3jlgxa6sd68ljy7s5w2";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.1.12";
  };
  train-rest = {
    dependencies = [ "aws-sigv4" "rest-client" "train-core" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qwa4vwzz9lipvibd83ra6lb7a345xxyg8r13z7p0982jsrspp33";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.5.0";
  };
  train-winrm = {
    dependencies = [ "winrm" "winrm-elevated" "winrm-fs" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07haiwh7jcg00mmiarj5g7k9kclq40yqd4j4r3c01qn2cq1sw2xb";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.2.13";
  };
  tty-box = {
    dependencies = [ "pastel" "strings" "tty-cursor" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12yzhl3s165fl8pkfln6mi6mfy3vg7p63r3dvcgqfhyzq6h57x0p";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.7.0";
  };
  tty-color = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aik4kmhwwrmkysha7qibi2nyzb4c8kp42bd5vxnf8sf7b53g73g";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.6.0";
  };
  tty-cursor = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.7.1";
  };
  tty-prompt = {
    dependencies = [ "pastel" "tty-reader" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j4y8ik82azjxshgd4i1v4wwhsv3g9cngpygxqkkz69qaa8cxnzw";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.23.1";
  };
  tty-reader = {
    dependencies = [ "tty-cursor" "tty-screen" "wisper" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cf2k7w7d84hshg4kzrjvk9pkyc2g1m3nx2n1rpmdcf0hp4p4af6";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.9.0";
  };
  tty-screen = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18jr6s1cg8yb26wzkqa6874q0z93rq0y5aw092kdqazk71y6a235";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.8.1";
  };
  tty-spinner = {
    dependencies = [ "tty-cursor" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hh5awmijnzw9flmh5ak610x1d00xiqagxa5mbr63ysggc26y0qf";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.9.3";
  };
  tty-table = {
    dependencies = [ "pastel" "strings" "tty-screen" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fcrbfb0hjd9vkkazkksri93dv9wgs2hp6p1xwb1lp43a13pmhpx";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.12.0";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.0.6";
  };
  uber = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.1.0";
  };
  unf = {
    dependencies = [ "unf_ext" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.1.4";
  };
  unf_ext = {
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yj2nz2l101vr1x9w2k83a0fag1xgnmjwp8w8rw4ik2rwcz65fch";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.0.8.2";
  };
  unicode-display_width = {
    groups = [ "default" "development" "omnibus_package" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d0azx233nags5jx3fqyr23qa2rhgzbhv8pxp46dgbg1mpf82xky";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.5.0";
  };
  unicode_utils = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h1a5yvrxzlf0lxxa1ya31jcizslf774arnsd89vgdhk4g7x08mr";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.4.0";
  };
  uuidtools = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s8h35ia80p919kidb66nfp8904rhdmn41z9ghsx4ihp2ild3bn4";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.2.0";
  };
  vault = {
    dependencies = [ "aws-sigv4" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cbh22sbv1y8niq0ldx0g5mmlnylsbsasha45d2zcgc9wbhcgzw7";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.18.1";
  };
  webrick = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13qm7s0gr2pmfcl7dxrmq38asaza4w0i2n9my4yzs499j731wh8r";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.8.1";
  };
  winrm = {
    dependencies = [ "builder" "erubi" "gssapi" "gyoku" "httpclient" "logging" "nori" "rubyntlm" ];
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nxf6a47d1xf1nvi7rbfbzjyyjhz0iakrnrsr2hj6y24a381sd8i";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.3.6";
  };
  winrm-elevated = {
    dependencies = [ "erubi" "winrm" "winrm-fs" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lmlaii8qapn84wxdg5d82gbailracgk67d0qsnbdnffcg8kswzd";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.2.3";
  };
  winrm-fs = {
    dependencies = [ "erubi" "logging" "rubyzip" "winrm" ];
    groups = [ "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gb91k6s1yjqw387x4w1nkpnxblq3pjdqckayl0qvz5n3ygdsb0d";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.3.5";
  };
  wisper = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rpsi0ziy78cj82sbyyywby4d0aw0a5q84v65qd28vqn79fbq5yf";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.0.1";
  };
  wmi-lite = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nnx4xz8g40dpi3ccqk5blj1ck06ydx09f9diksn1ghd8yxzavhi";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.0.7";
  };
  yajl-ruby = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lni4jbyrlph7sz8y49q84pb0sbj82lgwvnjnsiv01xf26f4v5wc";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "1.4.3";
  };
  yaml-safe_load_stream3 = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10g4wy0vmggxnb3bz1zz74rfhhzqa50hc553sn7yqrbywpzn6kzx";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "0.1.2";
  };
  zeitwerk = {
    groups = [ "default" "omnibus_package" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gir0if4nryl1jhwi28669gjwhxb7gzrm1fcc8xzsch3bnbi47jn";
      target = "ruby";
      type = "gem";
    };
    targets = [ ];
    version = "2.6.12";
  };
}
