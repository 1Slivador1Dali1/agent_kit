#!/usr/bin/env bash
# Проверяет переносимый набор agent-kit: пайплайн и четыре пакета.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

need_file() {
  [[ -f "$ROOT/$1" ]] || fail "нет файла $1"
}

need_file implementation-pipeline/SKILL.md
need_file implementation-pipeline/analysis.md
need_file implementation-pipeline/plan.md
need_file front/rules/design.mdc
need_file front/design-direction/SKILL.md
need_file front/design-tokens/SKILL.md
need_file front/ui-states-feedback/SKILL.md
need_file front/motion-polish/SKILL.md
need_file front/nielsen-review/SKILL.md
need_file front/a11y-responsive-check/SKILL.md
need_file des/rules/desktop.mdc
need_file des/desktop-architecture/SKILL.md
need_file back/rules/backend.mdc
need_file back/api-design/SKILL.md
need_file mob/rules/mobile.mdc
need_file mob/mobile-architecture/SKILL.md
need_file README.md

grep -q -F -- ".cursor/project.md" "$ROOT/implementation-pipeline/analysis.md" \
  || fail "пайплайн без .cursor/project.md"
grep -q -F -- "Проработка десктопа" "$ROOT/implementation-pipeline/plan.md" \
  || fail "пайплайн без проработки десктопа"
grep -q -F -- "Проработка бэкенда" "$ROOT/implementation-pipeline/plan.md" \
  || fail "пайплайн без проработки бэкенда"
grep -q -F -- "Проработка мобилки" "$ROOT/implementation-pipeline/plan.md" \
  || fail "пайплайн без проработки мобилки"

if [[ -d "$ROOT/entity-detail-page" || -d "$ROOT/portal-entities" ]]; then
  fail "в набор попали скиллы портала"
fi

echo "OK"
