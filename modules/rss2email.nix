_: {

  environment.persistence."/pst".directories = [
    "/var/rss2email"
  ];

  services.rss2email = {
    enable = true;
    interval = "15min";
    to = "rafaelgirao+r2e-ist@protonmail.com";
    config = {
      from = "machines@rafael.ovh";
      html-mail = true;
      trust-guid = false;
      trust-link = false;
      force-from = false;
      reply-changes = true;
      multipart-html = false;
    };
    feeds = {
      #Anúncios de Cadeiras
      # 2021/2022
      "IST-2021-PO".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/PO3/2021-2022/1-semestre/rss/announcement";
      "IST-2021-CDI-I".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/CDI16/2021-2022/1-semestre/rss/announcement";
      "IST-2021-LP".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/LP2/2021-2022/1-semestre/rss/announcement";
      "IST-2021-Ges".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/Ges/2021-2022/1-semestre/rss/announcement";
      "IST-2021-FisI".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/Fis3/2021-2022/2-semestre/rss/announcement";
      "IST-2021-CDI-II".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/CDI9/2021-2022/2-semestre/rss/announcement";
      "IST-2021-EMD".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/EMD/2021-2022/2-semestre/rss/announcement";
      "IST-2021-IAED".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/IAED2/2021-2022/2-semestre/rss/announcement";
      "IST-2021-IAC".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/IAC2/2021-2022/2-semestre/rss/announcement";
      # S1 - 2022/2023
      "IST-2022-CDI-III".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/CDI-III-2/2022-2023/1-semestre/rss/announcement";

      "IST-2022-OC".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/OC-2/2022-2023/1-semestre/rss/announcement";
      "IST-2022-Apre".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/Apre2/2022-2023/1-semestre/rss/announcement";

      "IST-2022-ASA".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/ASA/2022-2023/1-semestre/rss/announcement";
      "IST-2022-SO".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/SO/2022-2023/1-semestre/rss/announcement";
      "IST-2022-APSEI".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/APSEI/2022-2023/1-semestre/rss/announcement";
      "IST-2022-Ges".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/Ges-2/2022-2023/1-semestre/rss/announcement";

      # S2 - 2022/2023
      "IST-2022-CDI".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/CDI9/2022-2023/2-semestre/rss/announcement";

      "IST-2022-TC".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/TCom2/2022-2023/2-semestre/rss/announcement";
      "IST-2022-IPM".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/IPM/2022-2023/2-semestre/rss/announcement";

      "IST-2022-EMD".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/EMD/2022-2023/2-semestre/rss/announcement";
      "IST-2022-IA".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/IArt2/2022-2023/2-semestre/rss/announcement";
      "IST-2022-BD".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/BD2-2/2022-2023/2-semestre/rss/announcement";

      # S1 - 2023/2024
      "IST-2023-RC".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/RC/2023-2024/1-semestre/rss/announcement";
      "IST-2023-CDI3".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/CDI5/2023-2024/1-semestre/rss/announcement";
      "IST-2023-CSF".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/CSF2/2023-2024/1-semestre/rss/announcement";
      "IST-2023-VI".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/VI/2023-2024/1-semestre/rss/announcement";
      "IST-2023-AMS".url =
        "https://fenix.tecnico.ulisboa.pt/disciplinas/Mod/2023-2024/1-semestre/rss/announcement";


      "HackerNews-Monthly" = {
        url = "https://rsshub.app/github/issue/headllines/hackernews-monthly";
        to = "rafaelgirao+r2e-feeds@protonmail.com";
      };
    };
  };
  systemd.services."rss2email".serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    RestrictNamespaces = true;
    NoNewPrivileges = true;
    ProtectKernelLogs = true;
    ProtectClock = true;
    PrivateDevices = true;
    ProtectControlGroups = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    PrivateTmp = true;
    MemoryDenyWriteExecute = true;

    DevicePolicy = "closed";

    ProtectHostname = true;
    RestrictSUIDSGID = true;
    LockPersonality = true;
    RestrictRealtime = true;
    ReadWritePaths = [ "/var/rss2email" ];
  };

}
