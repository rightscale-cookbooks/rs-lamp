rs-lamp Cookbook CHANGELOG
==========================

This file is used to list changes made in each version of the rs-lamp cookbook.

v1.1.1
------

- Add kitchen testing for CentOS 6.5, RHEL 6.5, and Ubuntu 14.04.
- Update testing code to abide by Serverspec v2.

v1.1.0
------

- Update kitchen and Berksfile to reflect 'mysql' and 'database' cookbook changes.
- Update rs-lamp::default recipe to log at compile phase ([#3][]).
- Install all supported file-compression packages instead of assuming already installed.
- Update testing code.

v1.0.0
------

- Initial release

<!--- The following link definition list is generated by PimpMyChangelog --->
[#3]: https://github.com/rightscale-cookbooks/rs-lamp/issues/3