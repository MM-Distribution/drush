# Drush 8 for Drupal 7 on PHP 8.4 (M&M Distribution fork)

Drush 8 is the last Drush that runs Drupal 7; upstream ended it in January 2025
(last release 8.5.0). This fork keeps it working on current PHP.

- **Based on** [varvashenya/drush](https://github.com/varvashenya/drush) 8.6.0
  (PHP 8.3, Symfony 7, PsySH 0.12, MySQL 8 dumps; offered upstream as
  [drush-ops/drush#6621](https://github.com/drush-ops/drush/pull/6621)), which is
  based on [drush-ops/drush](https://github.com/drush-ops/drush) 8.x.
- **Adds** PHP 8.4 fixes (see [CHANGELOG.md](CHANGELOG.md)) and
  `tests/php84-check.sh`, which runs the commands we use against a Drupal 7 site
  with every PHP message on screen and fails on any of them.
- **Needs** PHP 8.3 or newer.
- **Install:** `composer install --no-dev` in a clone, then run `drush` (or
  `php drush.php`) from it.
- **Check a site:** `tests/php84-check.sh --root=/path/to/drupal7 --php=/path/to/php8.4`
  (`--write` also enables a module and runs cron: throwaway sites only).
- **License:** GPL-2.0-or-later, like Drush ([LICENSE](LICENSE)).

The upstream README follows.

---

Drush is a command line shell and Unix scripting interface for Drupal. Drush core ships with lots of useful commands for interacting with code like modules/themes/profiles. Similarly, it runs update.php, executes sql queries and DB migrations, and misc utilities like run cron or clear cache. Drush can be extended by [3rd party commandfiles](https://www.drupal.org/project/project_module?f[2]=im_vid_3%3A4654).

[![Latest Stable Version](https://poser.pugx.org/drush/drush/v/stable.png)](https://packagist.org/packages/drush/drush) [![Total Downloads](https://poser.pugx.org/drush/drush/downloads.png)](https://packagist.org/packages/drush/drush) [![Latest Unstable Version](https://poser.pugx.org/drush/drush/v/unstable.png)](https://packagist.org/packages/drush/drush) [![License](https://poser.pugx.org/drush/drush/license.png)](https://packagist.org/packages/drush/drush) [![Documentation Status](https://readthedocs.org/projects/drush/badge/?version=master)](https://readthedocs.org/projects/drush/?badge=master)

Resources
-----------
* [Installing (and Upgrading)](http://docs.drush.org/en/8.x/install/)
* [General Documentation](http://docs.drush.org)
* [API Documentation](http://api.drush.org)
* [Drush Commands](http://drushcommands.com)
* To receive notifications on new releases, use GitHub's 'Watch' button and select 'Releases only'. Also, [this atom feed](https://github.com/drush-ops/drush/releases.atom).
* [Drush packages available via Composer](https://packagist.org/search/?type=drupal-drush)
* [A list of modules that include Drush integration](https://www.drupal.org/project/project_module?f[2]=im_vid_3%3A4654&solrsort=ds_project_latest_release+desc)
* Drush comes with a [full test suite](https://github.com/drush-ops/drush/blob/master/tests/README.md) powered by [PHPUnit](https://github.com/sebastianbergmann/phpunit). Each commit gets tested by the awesome [Travis.ci continuous integration service](https://travis-ci.org/drush-ops/drush).

Support
-----------
* Post support requests to [Drupal Answers](http://drupal.stackexchange.com/questions/tagged/drush).
* Report bugs and request features in the [GitHub Drush Issue Queue](https://github.com/drush-ops/drush/issues).
* Use pull requests (PRs) to contribute to Drush.

FAQ
------

>  Q: What does "drush" stand for?<br>
>  A: The Drupal Shell.
>
>  Q: How do I pronounce Drush?<br>
>  A: Some people pronounce the *dru* with a long 'u' like Dr*u*pal. Fidelity points
>     go to them, but they are in the minority. Most pronounce Drush so that it
>     rhymes with hush, rush, flush, etc. This is the preferred pronunciation.
>
>  Q: Does Drush have unit tests?<br>
>  A: Drush has an excellent suite of unit tests. See 
> [tests/README.md](https://github.com/drush-ops/drush/blob/master/tests/README.md) for more information.


Credits
-----------

* Originally developed by [Arto Bendiken](http://bendiken.net) for Drupal 4.7.
* Redesigned by [Franz Heinzmann](http://unbiskant.org) in May 2007 for Drupal 5.
* Maintained by [Moshe Weitzman](http://drupal.org/moshe) with much help from
  the folks listed at https://github.com/orgs/drush-ops/people.

![Drush Logo](drush_logo-black.png)
