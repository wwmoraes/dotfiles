{
  flake.modules.homeManager.personal =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.age
        (pkgs.writeShellScriptBin "decrypt-personal" ''
          op read 'op://Personal/age/secret key' | ${lib.getExe pkgs.age} -- --decrypt --identity - --output "$(dirname "$1")/$(basename -s .age "$1")" "$1"
        '')
      ];

    };

  # done this way since my work environment doesn't allow Nix; this is
  # merely a documentation of the script needed to fucking encrypt my
  # payslips to then send to my personal email
  flake.modules.homeManager.work =
    {
      pkgs,
      ...
    }:
    {
      home.file.".local/bin/encrypt-personal" = {
        executable = true;
        source = pkgs.writeShellScriptBin "age-encrypt-personal" ''
          DIR=''$(dirname "$1")
          docker run --rm -it \
            -v ~/.config/age:/etc/age \
            -v "$DIR:$DIR" \
            p-nexus-3.development.nl.eu.abnamro.com:18445/jauderho/age \
            age \
            --encrypt \
            --recipients-file /etc/age/recipients/personal \
            --armor \
            --output "$1.age" \
            "$1"
        '';
      };

      xdg.configFile."age/recipients/personal" = {
        text = ''
          age1pq1ymp5ujnnv38wh80fgfjzf3jsxu3x7m76pkdkgw6q8xrdyas5y623v67x33rx99ftdqc4gzfhzf9425f9nmakk84q689c6duzy8mgg7jmwaw5yn8nexnq0v3nzyzmtuf9x35yhnyeqymamd992v2nwrd8tm0mdnwwz2wv26nz9tn68475fn5jfztnpvx283fhd2xfa5refrnh55r9wz5z0zqfdw4mtgg6gl0te39tnj0j8x34qdxqf5xnx3gvtyys5q06k5m7w7p3605xssh342vrg6dy9wqqxq6c74c4d7zkhtsmx78p2tz8cj4ymd9x0pd9rg76yzzhyayj33wg2kjrzd3l54ql6jxvk2nut3setjnt0e755dmtcsdxjp9fcvc46keerj3lva77sg0thayxe7qeth44ewanwmam9ss0gary4scktl3g4k23wee94vrqmxt2jwu6nv38vr393z5e75sxmge7j62ms5e8sfwfwgff4f3n7j4vueeuzm85g0ejz26xjqhlhdedngwfadm9z7y3x23m799slx4m8up3juf4pkh0syhcywtxrfmyl9amjzsyfa9ddpv4td5vwvgwrqx2pkn5work2cx07dgsp6jrtxmm5v0y4gwzhtthazdm38235n0rclx2jhgd33dy5g4xyfpukjt697vfhr4k5csjvgjyzaaaf432hj7dhwjav40u290q8w4cyk7gnz7lz95meve6pkf58xxt8yfm3g3lrdpjnk5z8jde2wpzfu3f8aujezag7yxlunypzjsj3avjed4ktt8ewppy3vy7lgssj5rrjd8mu839j2ll9224utrqy7e2kfuqyn2t8wsxmnfazje6d9jnn95q3fl5ejwj65kx4v2yfercmxkamyuqqd2wxzqkv3wkxguqhvy3p9nlypdxq70x626j92j9cxfuns8uqhg4jylr23qg6xq39ccmtn44a3p4tewfu8an74wm9rksrdzvx2furjmxawzxzfvur7t59j9xncddzqf66c8y0hfe3y3sg2andqca6k5y52duh2c4c5vd3px9w4rrkjv8u9ft4479pggwnw0rle9xd5s67033a6fvjngrfrjaq0z6nwvwa7d64anfxkuy85gk0cp5q3zf6lf4zxlgx74zud90zkc3my98svrr50dukwg6tqhqhtf0nvy72dq3x77ag3qqf5dltwjmmw2rj5xe5j9t3dhwf2406hzx6hp7w445w7c35z65vfz3cwdw9fqfdzj4aqq48vmjrvscxrstuqgaj63gsquvqdwrg5jx0vspglydvc5przfzvnjh9zzqmk2u3ngqvlucvhz7fsudgj3e2e8f6x6qquhz5j0sjresky0grys5379nrj3y7vcetyp4cth9rj47np39afu2x2a560gly59nzxe0wjemfmkf4xk33n4h95cshwlllkf3umccnhmar7eyy0lm78rv2dvj64zszkq7g9wwhdvn4vpy6cp52wjnvynrnqf2fzugxtwtcq60g9hqwn5eqtyyt0u5cp34u74c36lpsxpq63lx6gwlkqy977e7rvss72rjsk6r2qttjqay0kwff6hzwhjs2f3w99le22fx5axcnlkq2ng3zs7z9wzxxk7x8ty39qj2auzcrepnsrtkqhy3gc563uytmheaxzfre00maq32qs5dmm7rx2k5uh2vpn9qq3f72yernc6jpqprueq94jht42rvls46apfzj7exvvy68zdskssp76d0pyrzeq04ntpcfk09cvpkwsqvd7a9c3jcv78pe2h27y9dwd2vuc5q3u3pcfwppdt9e8w8q63as0t2av7930tgqp859aftacnelzqw6s2aurk5qu7rg6yvf9wtjmulfakj6f6mu4xxz2gpvmaafev5n6lejseflrwq9dupeg2q3wj3k2sgnqlfw
        '';
      };
    };
}
