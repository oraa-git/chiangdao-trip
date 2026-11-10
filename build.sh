#!/bin/sh
# Builds index.html (GitHub Pages version) from trip-chiangdao.html (artifact source).
# Each build gets a new version stamp; open pages compare it with the live file
# and reload themselves when a newer one is published, so stale browser caches clear.
set -e
cd "$(dirname "$0")"
BUILD=$(date +%Y%m%d%H%M%S)
{
cat <<EOF
<!doctype html>
<html lang="th">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="0">
<meta name="build" content="$BUILD">
<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}img{max-width:100%}[hidden]{display:none!important}</style>
<script>
(function(){
  if (location.protocol === "file:") return;
  var cur = "$BUILD", busy = false;
  function check(){
    if (busy) return; busy = true;
    fetch(location.pathname + "?check=" + Date.now(), {cache: "no-store"})
      .then(function(r){ return r.ok ? r.text() : ""; })
      .then(function(t){
        var m = t.match(/<meta name="build" content="(\d+)"/);
        if (m && m[1] !== cur && location.search.indexOf("v=" + m[1]) === -1) {
          location.replace(location.pathname + "?v=" + m[1] + location.hash);
        }
      })
      .catch(function(){})
      .then(function(){ busy = false; });
  }
  check();
  document.addEventListener("visibilitychange", function(){ if (!document.hidden) check(); });
})();
</script>
EOF
cat trip-chiangdao.html
printf '\n</html>\n'
} > index.html
echo "Built index.html (build $BUILD)"
