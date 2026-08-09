# BoutiqueScore (Dart WASM)

Tunnel web léger d’auto-évaluation (score règles Q1–Q5, pas de ML embarqué pour l’instant).

**Phase A** — pays + Q1–Q5 → score immédiat (sans téléphone).  
**Phase B** — si score > 50 et opt-in : ville, activité, montant, enregistrement, téléphone.  
Fins douces (CTA Weebi) si refus, sous le seuil, ou après envoi.

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

Les binaires WASM (`site/*.wasm`, `*.mjs`, maps) sont gitignorés — recompiler avant de servir.
