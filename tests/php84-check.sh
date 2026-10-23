#!/bin/bash
# Runs the Drush commands we use against a Drupal 7 site with every PHP message
# shown on screen, and fails on any deprecation, warning, notice or error. That
# is what plain `drush` shows a user, and output before Drupal boots also sets
# off the "headers already sent" session warnings.
#
#   tests/php84-check.sh --root=SITE [--php=PHP] [--write]
#
#   --php    PHP binary (default: php on PATH)
#   --write  also vset/vdel, enable/disable/uninstall a core module, run cron,
#            and load a fresh dump back in: only on a throwaway site
#
# Prints one line per command; the full output of a failing command follows.
set -u
ROOT=; PHP=php; WRITE=
for a in "$@"; do
  case "$a" in
    --root=*) ROOT=${a#--root=} ;;
    --php=*) PHP=${a#--php=} ;;
    --write) WRITE=1 ;;
    *) echo "unknown option: $a" >&2; exit 2 ;;
  esac
done
[ -n "$ROOT" ] || { sed -n '7,13p' "$0"; exit 2; }
DRUSH="$(cd "$(dirname "$0")/.." && pwd)/drush.php"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
FAIL=0

# PHP's own messages, Drush's [warning]/[error] log lines and uncaught
# exceptions; not plain output (a module named panels_customerror). Also
# MariaDB 11's "mysql: Deprecated program name": Drush runs mariadb and
# mariadb-dump when they are installed.
problems() {
  grep -E "^(PHP )?(Deprecated|Warning|Notice|Fatal error|Parse error|Recoverable fatal error):|\[(warning|error)\]|headers already sent|Uncaught|Deprecated program name"
}

# check NAME ARGS...: CHECK_IN (input file) and CHECK_PATH (PATH for Drush
# only) may be set for one command.
check() {
  local name=$1; shift
  local out=$TMP/out
  # A one-time login link (uli) is a working login: never print it.
  (cd "$TMP" && PATH=${CHECK_PATH:-$PATH} "$PHP" -d error_reporting=-1 -d display_errors=1 -d log_errors=0 "$DRUSH" --root="$ROOT" "$@") 2>&1 < "${CHECK_IN:-/dev/null}" \
    | sed -E 's#user/reset/[^ ]+#user/reset/(link hidden)#' > "$out"
  local rc=${PIPESTATUS[0]}
  if [ $rc -ne 0 ] || problems < "$out" > /dev/null; then
    echo "FAIL  $name (exit $rc)"; sed 's/^/      /' "$out" | head -40; FAIL=1
  else
    echo "ok    $name"
  fi
}

check version version
check status status
check cc "cc" all
check vget vget site_name
check pm-list pm-list --type=module --status=enabled --format=list
check pm-info pm-info system --fields=status
check sqlq sqlq "SELECT COUNT(*) FROM {system}" --db-prefix
check updb updb -n
check php-eval ev 'echo VERSION;'
printf '<?php\necho variable_get("site_name");\n' > "$TMP/s.php"
check php-script php-script "$TMP/s.php"
check core-cli core-cli
check watchdog-show watchdog-show --count=1 --format=csv --fields=wid
check sql-dump sql-dump --gzip --result-file="$TMP/dump.sql"
[ -s "$TMP/dump.sql.gz" ] && gzip -t "$TMP/dump.sql.gz" || { echo "FAIL  sql-dump made no readable file"; FAIL=1; }
rm -f "$TMP/dump.sql.gz"
check uli uli --no-browser

# The MySQL/MariaDB programs: MariaDB's names when installed, the old names
# when not (sql-client=auto).
expect=mysql; command -v mariadb > /dev/null && command -v mariadb-dump > /dev/null && expect=mariadb
check db-client status --fields=db-client
grep -q "Database client *: *$expect," "$TMP/out" || { echo "FAIL  db-client: expected $expect"; FAIL=1; }
if command -v mysql > /dev/null && command -v mysqldump > /dev/null; then
  # Only the old names on Drush's PATH (PHP is called by its full path).
  mkdir "$TMP/oldbin"; ln -s "$(command -v mysql)" "$(command -v mysqldump)" "$TMP/oldbin/"
  PHP=$(command -v "$PHP") CHECK_PATH=$TMP/oldbin check db-client-old status --fields=db-client
  grep -q "Database client *: *mysql, mysqldump" "$TMP/out" || { echo "FAIL  db-client-old: expected mysql, mysqldump"; FAIL=1; }
fi
[ -n "$WRITE" ] && {
  check vset vset drush_php84_check 1
  check vdel vdel -y drush_php84_check
  check en en -y statistics
  check dis dis -y statistics
  check pm-uninstall pm-uninstall -y statistics
  check cron cron
  check sql-dump-restore sql-dump --result-file="$TMP/restore.sql"
  CHECK_IN=$TMP/restore.sql check sql-cli-restore sql-cli
  check after-restore status --fields=bootstrap
  grep -q "Successful" "$TMP/out" || { echo "FAIL  after-restore: Drupal doesn't boot"; FAIL=1; }
  rm -f "$TMP/restore.sql"
}
[ $FAIL -eq 0 ] && echo "all passed" || echo "some failed"
exit $FAIL
