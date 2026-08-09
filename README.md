# BoutiqueScore (Dart WASM)

Tunnel web léger d’auto-évaluation.

**Phase A** — pays + Q1–Q5 → score immédiat (sans téléphone).  
**Phase B** — si score &gt; 50 et opt-in : ville, activité, financement, enregistrement, téléphone.  
Fins douces (CTA Weebi) que l’utilisateur refuse, soit sous le seuil, soit après envoi.

## Develop

```shell
cd example/wasm
dart pub get
dart test
dart compile wasm web/main.dart -o site/test.wasm
```

```shell
cd site
dart pub global run dhttpd --path . --port 8080
```

Open http://localhost:8080/index.html
