# Changelog

M&M Distribution fork of Drush 8. Upstream changes are in the
[drush-ops/drush releases](https://github.com/drush-ops/drush/releases); the
8.6.0 base is described in [drush-ops/drush#6621](https://github.com/drush-ops/drush/pull/6621).

## Unreleased

PHP 8.5, from the server trial's deprecation logs (2026-10-24):

- The SQL connection options used `PDO::MYSQL_ATTR_SSL_*`, deprecated in PHP
  8.5; now `Pdo\Mysql::ATTR_SSL_*` where it exists (8.4+), the old constants
  otherwise (same values, so settings.php may use either).
- Two `(integer)` casts (`includes/drupal.inc`, `includes/drush.inc`) are now
  `(int)`: PHP 8.5 reports them while compiling, before Drush's handler, so
  they printed and caused "headers already sent" warnings.

Fixes from an audit of this fork, the 8.6.0 base and older Drush code:

- `drush vget` (YAML output) ran out of memory on Drupal 7 variables holding
  objects that refer back to themselves; objects are written serialized
  (`!php/object`) again, as before 8.6.0.
- Log messages that aren't text (an update hook returning a Drupal 6 style
  array, backend log entries) were a TypeError under psr/log 3; updatedb
  stopped before the update was recorded. They are turned into text.
- Drupal 7 downloads ask which release to use again when there is no stable
  release (8.6.0 picked one silently: -dev snapshots, newer major versions).
  Name the version (`views-7.x-3.30`) to skip the question.
- The MySQL GTID check (8.6.0) asks the server directly: it no longer puts
  its query and error into dumps sent to stdout with `--debug`, and dump
  options in `--extra` no longer make it fail silently.
- `--sql-client` is passed on to sub-commands (sql-sync) and remote sites; a
  forced choice that isn't installed falls back to auto with a warning; no
  client at all is a warning instead of "command not found".
- make-lock and make-update stop with an error when the makefile's projects
  can't be resolved (a PHP 8 TypeError before).
- `--strict=2` failed on an undefined constant (LogLevel::FAILED), and a ''
  result no longer skips it (PHP 8 comparison change).
- Remote-to-remote core-rsync read a result key that doesn't exist, so a
  failed first copy went unnoticed.
- An annotated command with `@default-fields` made every command fail
  (implode() on a string); Sqloracle's createdb_sql() signature matches its
  parent.
- pm-updatestatus (`latest_dev`), pm-info (custom extensions without a
  version) and generate-makefile (`$name`) warnings.
- PHP 8.1 to 8.4 deprecations (errors in PHP 9): dynamic properties declared,
  null passed to string functions, `exit(NULL)`, `str_getcsv()` escape.
- symfony/yaml 7.4.21 (7.4.15 had a published crash advisory).
- `DRUSH_DEPRECATIONS_LOG=<file>` collects the deprecations Drush's error
  handler otherwise drops; tests/php84-check.sh fails on any of them and
  covers vget, --strict=2, non-text log messages and pm-updatestatus. Its
  `--write` run reloads a dump only when the dump finished.

Earlier in this release:

- PHP 8.4: explicit nullable types for the 7 parameters that defaulted to null
  (Drush::process/shell, ProcessManager::process/shell, UserAbortException,
  Queue8, DrupalBoot8::conf_path). Their deprecations printed before Drupal
  booted and set off "headers already sent" session warnings on every command.
- MariaDB: the sql commands (sql-dump, sqlq, sql-cli, sql-sync...) run
  mariadb and mariadb-dump when both are installed, mysql and mysqldump
  otherwise, so MariaDB 11 no longer prints "Deprecated program name". New
  global option --sql-client=auto|mariadb|mysql (drushrc:
  `$options['sql-client']`); `drush -v` logs the choice and `drush status`
  shows it as "Database client". The MySQL-only GTID check is skipped for
  MariaDB's dump program (MariaDB has no gtid_mode or --set-gtid-purged).
- GNU GPL v2 license text added (LICENSE).
- tests/php84-check.sh: the commands we use, run against a Drupal 7 site with
  every PHP message shown; fails on any of them, on the old program names,
  and (with --write) if a fresh dump doesn't load back in.
- Tested on PHP 8.4.27 with Drupal 7.106.
