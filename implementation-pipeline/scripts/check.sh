#!/usr/bin/env bash
# Проверяет каркас личного скилла implementation-pipeline.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

need_file() {
  [[ -f "$ROOT/$1" ]] || fail "нет файла $1"
}

need_phrase() {
  local file="$1"
  local phrase="$2"
  grep -q -F -- "$phrase" "$ROOT/$file" || fail "$file не содержит: $phrase"
}

need_file SKILL.md
need_file analysis.md
need_file plan.md
need_file implement.md
need_file review.md
need_file handoff.md
need_file examples.md

need_phrase SKILL.md "name: implementation-pipeline"
need_phrase SKILL.md "disable-model-invocation: true"
need_phrase SKILL.md "](analysis.md)"
need_phrase SKILL.md "](plan.md)"
need_phrase SKILL.md "](implement.md)"
need_phrase SKILL.md "](review.md)"
need_phrase SKILL.md "](handoff.md)"
need_phrase SKILL.md "](examples.md)"
need_phrase SKILL.md "await-chats"
need_phrase SKILL.md "исполнителей не запускать"

need_phrase plan.md "Мелкая"
need_phrase plan.md "Средняя"
need_phrase plan.md "Большая"
need_phrase plan.md "Отфильтровано"
need_phrase plan.md "Код в этом ходе не писать"
need_phrase plan.md "Бриф для чата"
need_phrase plan.md "Проработка дизайна"
need_phrase plan.md "видимого UI нет"
need_phrase plan.md "не клиентское приложение"
need_phrase plan.md "Проработка десктопа"
need_phrase plan.md "Проработка бэкенда"
need_phrase plan.md "Проработка мобилки"
need_phrase analysis.md ".cursor/project.md"
need_phrase analysis.md "вид не разобрать"

need_phrase implement.md "исполнителя не запускать"

need_phrase review.md "generalPurpose"
need_phrase review.md "Первая сверка код не меняет"
need_phrase review.md "слово «ревью»"
need_phrase review.md 'Поле `model` не передавать'
need_phrase review.md "сам вносит правки"
need_phrase review.md "Проработка дизайна"
need_phrase review.md "Проработка десктопа"

need_phrase handoff.md "Что реализовано"
need_phrase handoff.md "Как проверить"
need_phrase handoff.md "Push не делать"
need_phrase handoff.md "каталог прогона"

lines="$(wc -l < "$ROOT/SKILL.md")"
if [[ "$lines" -ge 500 ]]; then
  fail "SKILL.md слишком длинный: $lines строк"
fi

echo "OK"
