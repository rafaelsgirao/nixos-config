{ config, hostSecretsDir, ... }:
{
  # OIDC gate (via pocket-id) for the ott-rs browser UI at ott.rafael.ovh.
  # Runs in auth-request mode only: Caddy forward_auth sends header-only
  # subrequests to /oauth2/auth; app traffic never flows through oauth2-proxy.
  services.oauth2-proxy = {
    enable = true;
    provider = "oidc";
    clientID = "3243c009-45e9-4dde-9109-9309fe86a894";
    # OAUTH2_PROXY_CLIENT_SECRET (from the pocket-id client) and
    # OAUTH2_PROXY_COOKIE_SECRET (openssl rand -base64 32 | tr '+/' '-_').
    keyFile = config.age.secrets.ENV-oauth2-proxy.path;
    redirectURL = "https://ott.rafael.ovh/oauth2/callback";
    httpAddress = "http://127.0.0.1:4180";
    upstream = [ "static://202" ];
    email.domains = [ "*" ];
    reverseProxy = true;
    # Only Caddy (loopback) may supply X-Forwarded-* headers.
    trustedProxyIP = [ "127.0.0.1/32" ];
    cookie = {
      # Parent-domain cookie so the session is shared across every gated
      # subdomain (ott, vault, ...). Callback stays on ott.rafael.ovh.
      domain = ".rafael.ovh";
      secure = true;
      expire = "168h";
    };
    extraConfig = {
      oidc-issuer-url = "https://id.rafael.ovh";
      # pocket-id has no email-verification flow, so its id_tokens always
      # carry email_verified=false; emails there are admin-managed anyway.
      insecure-oidc-allow-unverified-email = true;
      skip-provider-button = true;
      code-challenge-method = "S256";
      # Every subdomain we redirect back to after auth.
      whitelist-domain = [
        "ott.rafael.ovh"
        "vault.rafael.ovh"
      ];
    };
  };

  age.secrets.ENV-oauth2-proxy = {
    file = "${hostSecretsDir}/ENV-oauth2-proxy.age";
  };
}
