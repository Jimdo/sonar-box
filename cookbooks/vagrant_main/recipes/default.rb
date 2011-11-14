include_recipe "php"
include_recipe "php::pear"

# We want pear 1.9.1 otherwise PHPUnit won't install
execute "pear upgrade" do
  not_if "pear version|grep 'PEAR Version: 1.9.1'"
end

pear_channel "components.ez.no" 
pear_channel "pear.phpunit.de" 
pear_channel "pear.symfony-project.com"
pear_channel "pear.pdepend.org"
pear_channel "pear.phpmd.org"

pear_module "phpunit/PHPUnit-3.5.15"
pear_module "pdepend/PHP_Depend-0.10.6"
pear_module "phpmd/PHP_PMD-1.1.0"
pear_module "PHP_CodeSniffer-1.3.1"
pear_module "phpunit/phpcpd-1.3.0"

require_recipe "sonar"
