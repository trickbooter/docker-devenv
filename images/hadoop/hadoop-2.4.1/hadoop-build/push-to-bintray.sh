#!/bin/bash

# Upload to bintray
curl -T hadoop-native-libs.tar.gz -u$BT_USER:$BT_APIKEY -H "X-BinTray-Package:$BT_PKG" -H "X-BinTray-Version:$BT_VER" https://api.bintray.com/content/$BT_ACC/$BT_REPO/$BT_PKG/$BT_VER/hadoop-native-libs.tar.gz;publish=1

# Publish
curl -T -u$BT_USER:$BT_APIKEY -H "Content-Type: application/json" -X POST https://api.bintray.com/content/$BT_ACC/$BT_REPO/$BT_PKG/$BT_VER/publish --data "{ \"discard\": \"false\" }"