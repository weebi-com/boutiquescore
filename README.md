# BoutiqueScore (Dart WASM)

Tunnel web léger d’auto-évaluation (score règles Q1–Q5, pas de ML embarqué pour l’instant).

**Phase A** — pays + Q1–Q5 → score immédiat (sans téléphone).  
**Phase B** — si score > 50 et opt-in : ville, activité, montant, enregistrement, téléphone.  
Fins douces (CTA Weebi) si refus, sous le seuil, ou après envoi.

## Develop

```shell
dart pub get
dart test
dart compile wasm web/main.dart -o site/test.wasm
```

```shell
cd site
dart pub global run dhttpd --path . --port 8080
```

Open http://localhost:8080/index.html

WASM build outputs (`site/test.wasm`, `site/test.mjs`, …) are gitignored — compile before serving locally.

## Deploy (GitHub Pages)

- Custom domain: `www.boutiquescore.com` ([CNAME](CNAME) / [site/CNAME](site/CNAME))
- Workflow [`.github/workflows/deploy-pages.yml`](.github/workflows/deploy-pages.yml): test → compile WASM → publish `site/`
- In the repo: **Settings → Pages → Source = GitHub Actions**
- DNS: `www` CNAME → `\<org\>.github.io` (apex optional via GitHub A records)

Submit uses **prod Envoy** gRPC-Web:

`https://weebi-envoyproxy-prd-29758828833.europe-west1.run.app/.../SubmitEvaluation`

(`site/grpc_web_submit.mjs` — tracked in git; public RPC, no API key in the browser)

Backend Turso env lives on weebi_server Cloud Run — see `weebi_server/packages/evaluation_service/README.md`.
