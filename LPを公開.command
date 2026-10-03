#!/bin/bash
# 研修LP（index.html）の変更を GitHub Pages に反映する。
cd "$(dirname "$0")" || exit 1
BOLD=$'\033[1m'; GREEN=$'\033[32m'; RED=$'\033[31m'; DIM=$'\033[2m'; RESET=$'\033[0m'

REPO="https://github.com/yu-fukui/mitekara-training-lp.git"
PAGES="https://yu-fukui.github.io/mitekara-training-lp/"

echo "${BOLD}研修LP を公開します${RESET}"
echo

# --- 送信先の確認（ミテカラ本番LPへ誤って送らないための歯止め）---
CUR=$(git remote get-url origin 2>/dev/null)
case "$CUR" in
  *mitekara-training-lp*) ;;
  "") git remote add origin "$REPO" ;;
  *)
    echo "${RED}✖ 送信先が研修LPではありません${RESET}"
    echo "  いまの設定: $CUR"
    echo "  研修LP以外へは送信しません。Claude に連絡してください。"
    echo; echo "────────────────────────"; exit 1 ;;
esac
echo "${DIM}送信先: $REPO${RESET}"
echo

if [ -n "$(git status --porcelain)" ]; then
  git add -A
  printf "コミットの説明（空ならそのまま「研修LPを更新」）\n  > "
  read -r MSG
  [ -z "$MSG" ] && MSG="研修LPを更新"
  git commit -q -m "$MSG" || echo "${RED}コミットできませんでした${RESET}"
fi

echo "GitHub へ送信します…"
if git push -u origin main; then
  echo
  echo "${GREEN}✔ 送信しました${RESET}"
  echo "  反映まで1〜2分かかります： ${PAGES}"
  echo "  ページが古いままなら、Command+Shift+R で再読み込みしてください。"
else
  echo
  echo "${RED}✖ 送信できませんでした${RESET}"
  echo "  リポジトリ mitekara-training-lp がまだ無い場合は、先に GitHub で作ってください。"
fi

echo
echo "────────────────────────"
echo "終了しました。閉じて構いません。"
read -r -p "Enter で閉じます"
