#!/bin/bash

CLASS_HASH="0x022c7b08c9028e0012f60735769cee965ea68463affa38b202823a834daa9b68"
ACCOUNT_JSON="/Users/arapachanate./ubit_account.json"
KEYSTORE_JSON="/Users/arapachanate./ubit_keystore.json"
OWNER_ADDRESS="0x00a151917dd73b149ff0ef61f032feb1a73b96e0d2fff3677c1198c1164804eb"

echo ""
echo "🚀 正在部署 ZPC Token 至主網..."
echo "🔐 擁有者地址: $OWNER_ADDRESS"
echo "📦 使用 Class Hash: $CLASS_HASH"
echo "🌐 網路：mainnet"
echo "--------------------------------------------"

starkli deploy \
  --account "$ACCOUNT_JSON" \
  --keystore "$KEYSTORE_JSON" \
  --network mainnet \
  --watch \
  "$CLASS_HASH" \
  "$OWNER_ADDRESS"

echo "✅ 部署完畢。請前往 StarkScan 或 Voyager 查詢狀態。"
