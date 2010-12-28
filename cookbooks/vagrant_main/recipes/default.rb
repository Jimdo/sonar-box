include_recipe "php"

# We want pear 1.9.1 otherwise PHPUnit won't install
execute "pear upgrade pear" do
  not_if "pear version|grep 'PEAR Version: 1.9.1'"
end

pear_channel "components.ez.no" 
pear_channel "pear.phpunit.de" 
pear_channel "pear.symfony-project.com"
pear_channel "pear.pdepend.org"
pear_channel "pear.phpmd.org"

pear_module "phpunit/PHPUnit"
pear_module "pdepend/PHP_Depend-0.9.14"
pear_module "phpmd/PHP_PMD-0.2.5"
pear_module "PHP_CodeSniffer-1.3.0RC1"
pear_module "phpunit/phpcpd"

require_recipe "sonar"
