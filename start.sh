#!/bin/sh
# Mengunduh definisi workflow dari Supabase lalu mengimpornya ke n8n sebelum n8n dijalankan.
# Kegagalan unduh atau impor tidak menghentikan n8n.
if [ -n "$SUPABASE_URL" ] && [ -n "$SUPABASE_KEY" ]; then
 rm -rf /tmp/wf && mkdir -p /tmp/wf
 for k in akun3 publisher analytics; do
 if wget -q -O "/tmp/wf/$k.json" --header="apikey: $SUPABASE_KEY" --header="Authorization: Bearer $SUPABASE_KEY" --header="Content-Type: application/json" --post-data="{\"p_kode\":\"$k\"}" "$SUPABASE_URL/rest/v1/rpc/ambil_workflow" && head -c 1 "/tmp/wf/$k.json" | grep -q '{'; then
 echo "workflow $k diunduh"
 else
 echo "workflow $k tidak diunduh"
 rm -f "/tmp/wf/$k.json"
 fi
 done
 if ls /tmp/wf/*.json >/dev/null 2>&1; then
 n8n import:workflow --separate --input=/tmp/wf || echo "impor workflow gagal"
 fi
fi
if command -v tini >/dev/null 2>&1; then exec tini -- n8n; fi
exec n8n

