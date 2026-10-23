# Changelog

M&M Distribution fork of Drush 8. Upstream changes are in the
[drush-ops/drush releases](https://github.com/drush-ops/drush/releases); the
8.6.0 base is described in [drush-ops/drush#6621](https://github.com/drush-ops/drush/pull/6621).

## Unreleased

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
